import SwiftUI

struct OnboardingContainerView: View {
    let onComplete: () -> Void

    @Environment(ProgressManager.self) private var progressManager
    @Environment(QuestionTracker.self) private var questionTracker
    @State private var step = 0
    @State private var sampleWasCorrect = false

    // Sample question for onboarding (first from tips pool)
    private var sampleQuestion: Question {
        QuestionBank.tipsAndChecksQuestions.first
    }

    var body: some View {
        ZStack {
            AppTheme.screenBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                switch step {
                case 0:
                    // Story hook
                    HookView(onContinue: { withAnimation { step = 1 } })

                case 1:
                    // Sample question
                    QuizQuestionView(
                        question: sampleQuestion,
                        onAnswer: { correct in
                            sampleWasCorrect = correct
                            questionTracker.markAnswered(sampleQuestion.id)
                        },
                        onContinue: { withAnimation { step = 2 } }
                    )

                case 2:
                    // Choice: try a full round or skip
                    OnboardingChoiceView(
                        sampleWasCorrect: sampleWasCorrect,
                        onStartQuiz: { withAnimation { step = 3 } },
                        onSkip: {
                            progressManager.recordOnboardingComplete()
                            onComplete()
                        }
                    )

                case 3:
                    // First quiz (5 questions + results + commitment)
                    QuizContainerView(
                        topic: .tipsAndChecks,
                        mode: .firstQuiz,
                        onDismiss: {
                            progressManager.recordOnboardingComplete()
                            onComplete()
                        },
                        onCommitComplete: {
                            progressManager.recordFirstQuizComplete()
                            progressManager.recordOnboardingComplete()
                            onComplete()
                        }
                    )

                default:
                    EmptyView()
                }
            }
        }
    }
}
