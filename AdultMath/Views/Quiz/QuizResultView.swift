import SwiftUI

struct QuizResultView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(NotificationState.self) private var notificationState

    let score: Int
    let totalQuestions: Int
    let isFirstQuizToday: Bool
    let buttonTitle: String
    let onDismiss: () -> Void

    init(score: Int, totalQuestions: Int, isFirstQuizToday: Bool,
         buttonTitle: String = "Back to Home", onDismiss: @escaping () -> Void) {
        self.score = score
        self.totalQuestions = totalQuestions
        self.isFirstQuizToday = isFirstQuizToday
        self.buttonTitle = buttonTitle
        self.onDismiss = onDismiss
    }

    private var clampedScore: Int {
        min(max(score, 0), totalQuestions)
    }

    private var message: String {
        let ratio = Double(clampedScore) / Double(totalQuestions)
        if ratio >= 0.9 { return "Outstanding! You really know your stuff." }
        if ratio >= 0.7 { return "Great job! You're getting confident with numbers." }
        if ratio >= 0.5 { return "Nice effort! Practice makes progress." }
        return "Keep going! Every practice session builds your skills."
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            ResultScoreRing(
                score: clampedScore,
                totalQuestions: totalQuestions
            )
            .padding(.horizontal, 24)

            Text(message)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, AppTheme.paddingXLarge)

            if isFirstQuizToday && progressManager.currentStreak > 1 {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(AppTheme.streakFlame)
                    Text("Streak maintained! Great habit.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .glassEffect(.regular.tint(AppTheme.streakFlame), in: RoundedRectangle(cornerRadius: 12))
            }

            if notificationState.shouldShowOnQuizResult(streak: progressManager.currentStreak) {
                QuizResultNotificationPrompt()
            }

            Spacer()

            PrimaryButton(buttonTitle, action: onDismiss)
                .padding(.horizontal, AppTheme.paddingMedium)
                .padding(.bottom, AppTheme.bottomScreenCTAInset)
        }
        .frame(maxHeight: .infinity)
    }
}

private struct ResultScoreRing: View {
    let score: Int
    let totalQuestions: Int

    private var progress: CGFloat {
        guard totalQuestions > 0 else { return 0 }
        return CGFloat(score) / CGFloat(totalQuestions)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.12), lineWidth: 18)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            Color.accentColor.opacity(0.65),
                            Color.accentColor,
                            AppTheme.accentGreen,
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 6) {
                Text("\(score)/\(totalQuestions)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.accentColor)

                Text("questions correct")
                    .font(AppTheme.captionMedium)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 188, height: 188)
        .padding(12)
        .background(
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.secondarySystemBackground),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay {
            Circle()
                .stroke(Color(.separator).opacity(0.12), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 16, y: 10)
        .accessibilityHidden(true)
    }
}
