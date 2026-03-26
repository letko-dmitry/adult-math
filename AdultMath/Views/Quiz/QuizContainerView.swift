import SwiftUI

struct QuizContainerView: View {
    let topic: Topic?
    let mode: QuizMode
    let onDismiss: () -> Void
    var onCommitComplete: (() -> Void)?

    @Environment(ProgressManager.self) private var progressManager
    @Environment(QuestionTracker.self) private var questionTracker
    @Environment(NotificationState.self) private var notificationState
    @State private var questions: [Question]?
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var showResult = false
    @State private var showCommitment = false
    @State private var wasTodayCompleteAtStart = false
    @State private var showCloseConfirmation = false
    @State private var answeredCount = 0
    @State private var questionStartTime: Date = .now
    @State private var answerTimes: [TimeInterval] = []

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.screenBackground
                    .ignoresSafeArea()

                // Phase 1: Commitment
                if showCommitment {
                    CommitmentContractView(
                        isHighScore: score >= 4,
                        onCommit: {
                            onCommitComplete?()
                        }
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .navigationBarHidden(true)

                // Phase 2: Results
                } else if showResult, let questions {
                    QuizResultView(
                        score: score,
                        totalQuestions: questions.count,
                        isFirstQuizToday: !wasTodayCompleteAtStart,
                        buttonTitle: mode.isFirstQuiz ? "Continue" : "Back to Home",
                        onDismiss: {
                            notificationState.advanceFromQuizResult()
                            if mode.isFirstQuiz {
                                withAnimation { showCommitment = true }
                            } else {
                                onDismiss()
                            }
                        }
                    )
                    .navigationBarHidden(true)

                // Phase 3: Questions
                } else if let questions, currentIndex < questions.count {
                    QuizQuestionView(
                        question: questions[currentIndex],
                        onAnswer: { correct in
                            let elapsed = Date.now.timeIntervalSince(questionStartTime)
                            answerTimes.append(elapsed)
                            answeredCount += 1
                            questionTracker.markAnswered(questions[currentIndex].id)
                            if correct { score += 1 }
                        },
                        onContinue: advanceToNext
                    )
                    .id(currentIndex)
                    .toolbar {
                        if !mode.isFirstQuiz {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close quiz", systemImage: "xmark") {
                                    if answeredCount > 0 {
                                        showCloseConfirmation = true
                                    } else {
                                        onDismiss()
                                    }
                                }
                                .labelStyle(.iconOnly)
                            }
                        }

                        ToolbarItem(placement: .principal) {
                            QuizProgressBar(current: currentIndex, total: questions.count)
                        }
                    }
                }
            }
        }
        .onAppear {
            wasTodayCompleteAtStart = progressManager.isTodayComplete
            loadQuestions()
            questionStartTime = .now
        }
        .alert("End Quiz?", isPresented: $showCloseConfirmation) {
            Button("Continue", role: .cancel) {}
            Button("End", role: .destructive) { onDismiss() }
        } message: {
            Text("You've answered \(answeredCount) of \(questions?.count ?? 0) questions. Your progress won't be saved.")
        }
    }

    private func loadQuestions() {
        guard questions == nil else { return }

        let effectiveTopic: Topic? = mode.isFirstQuiz ? .tipsAndChecks : topic

        let pool = if let effectiveTopic {
            QuestionBank.questions(for: effectiveTopic) ?? QuestionBank.mixedQuestions()
        } else {
            QuestionBank.mixedQuestions()
        }
        questions = Array(questionTracker.prioritized(pool, minCount: mode.quizSize).prefix(mode.quizSize))
    }

    private func advanceToNext() {
        guard let questions else { return }
        if currentIndex + 1 >= questions.count {
            progressManager.recordQuizCompletion(
                topic: mode.isFirstQuiz ? .tipsAndChecks : topic,
                score: score,
                totalQuestions: questions.count,
                answerTimes: answerTimes
            )
            questionTracker.savePendingChanges()
            withAnimation { showResult = true }
        } else {
            withAnimation { currentIndex += 1 }
            questionStartTime = .now
        }
    }
}
