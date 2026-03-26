import SwiftUI

struct HomeView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(NotificationState.self) private var notificationState
    @State private var activeFullScreen: FullScreenDestination?
    @State private var selectedLockedTopic: Topic?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    private var activeTopics: [Topic] { Topic.unlocked }

    private var lockedTopics: [Topic] { Topic.locked }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.spacingContent) {
                // Header
                Text("Math that feels usable in real life")
                    .font(AppTheme.heroTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, AppTheme.paddingMedium)
                    .padding(.top, 8)

                // Single contextual banner slot: notification (priority) → user state
                ContextualBannerView {
                    activeFullScreen = progressManager.isFirstQuizComplete ? .quiz(nil) : .firstQuiz
                }
                .padding(.horizontal, AppTheme.paddingMedium)

                // Hero card with chips
                TodayPracticeCard(
                    todayQuizCount: progressManager.todayQuizCount,
                    currentStreak: progressManager.currentStreak,
                    totalSolved: progressManager.totalProblemsSolved,
                    onStart: {
                        activeFullScreen = progressManager.isFirstQuizComplete ? .quiz(nil) : .firstQuiz
                    }
                )
                .padding(.horizontal, AppTheme.paddingMedium)

                // Active topics section
                VStack(alignment: .leading, spacing: AppTheme.spacingSection) {
                    Text("Active topics")
                        .font(AppTheme.sectionTitle)
                        .padding(.horizontal, AppTheme.paddingMedium)

                    if let insight = progressManager.currentInsight {
                        InsightCardView(text: insight)
                            .padding(.horizontal, AppTheme.paddingMedium)
                    }

                    LazyVGrid(columns: columns, spacing: AppTheme.spacingSection) {
                        ForEach(activeTopics) { topic in
                            TopicCardView(
                                topic: topic,
                                confidenceState: progressManager.confidenceState(for: topic)
                            ) {
                                activeFullScreen = .quiz(topic)
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.paddingMedium)
                }

                // Coming later section
                if !lockedTopics.isEmpty {
                    VStack(alignment: .leading, spacing: AppTheme.spacingSection) {
                        Text("Unlock with Premium")
                            .font(AppTheme.sectionTitle)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, AppTheme.paddingMedium)

                        LazyVGrid(columns: columns, spacing: AppTheme.spacingSection) {
                            ForEach(lockedTopics) { topic in
                                TopicCardView(topic: topic) {
                                    selectedLockedTopic = topic
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.paddingMedium)
                    }
                }

            }
            .padding(.bottom, AppTheme.paddingXLarge)
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear {
            progressManager.checkAndUpdateStreak()
            notificationState.checkPhaseTransition(
                homeState: progressManager.userHomeState,
                streak: progressManager.currentStreak,
                totalQuizzes: progressManager.totalQuizzesCompleted
            )
            if !progressManager.onboardingComplete {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    activeFullScreen = .onboarding
                }
            }
        }
        .fullScreenCover(item: $activeFullScreen) { destination in
            switch destination {
            case .onboarding:
                OnboardingContainerView {
                    activeFullScreen = nil
                }
                .interactiveDismissDisabled()
            case .quiz(let topic):
                QuizContainerView(topic: topic, mode: .standard, onDismiss: {
                    activeFullScreen = nil
                })
            case .firstQuiz:
                QuizContainerView(
                    topic: .tipsAndChecks,
                    mode: .firstQuiz,
                    onDismiss: { activeFullScreen = nil },
                    onCommitComplete: {
                        progressManager.recordFirstQuizComplete()
                        activeFullScreen = nil
                    }
                )
                .interactiveDismissDisabled()
            }
        }
        .sheet(item: $selectedLockedTopic) { topic in
            PaywallView(topic: topic)
                .presentationDetents([.large])
        }
    }

}
