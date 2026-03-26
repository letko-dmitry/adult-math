import SwiftUI

struct TodayPracticeCard: View {
    let todayQuizCount: Int
    let currentStreak: Int
    let totalSolved: Int
    let onStart: () -> Void

    private var headline: String {
        switch todayQuizCount {
        case 0: "Ready to practice?"
        case 1: "Great start! Keep going?"
        case 2: "Impressive dedication!"
        case 3: "You're on a roll today!"
        default: "Unstoppable!"
        }
    }

    // "3 short challenges" is intentional friendly copy suggesting a quick experience,
    // not a literal count — the quiz is 8 questions (R9).
    private var subtitle: String {
        todayQuizCount == 0
            ? "3 short challenges — about 2 minutes"
            : "\(todayQuizCount) \(todayQuizCount == 1 ? "quiz" : "quizzes") done today"
    }

    private var buttonTitle: String {
        todayQuizCount == 0 ? "Start Practice" : "Practice More"
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's quick practice")
                        .font(AppTheme.smallCaption)
                        .foregroundStyle(.secondary)

                    Text(headline)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }
                Spacer()

                if todayQuizCount > 0 {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(AppTheme.accentGreen)
                }
            }

            Text(subtitle)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            PrimaryButton(buttonTitle, action: onStart)

            // Chips: streak + solved count
            HStack(spacing: 8) {
                if currentStreak > 1 {
                    chipView(
                        icon: "flame.fill",
                        text: "\(currentStreak)-day streak",
                        iconColor: AppTheme.streakFlame
                    )
                }
                if totalSolved > 0 {
                    chipView(
                        icon: "checkmark.circle",
                        text: "\(totalSolved) solved",
                        iconColor: AppTheme.accentGreen
                    )
                }
                Spacer()
            }
        }
        .padding(AppTheme.paddingMedium)
        .background {
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color.accentColor.opacity(0.08),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(Color(.separator).opacity(0.2), lineWidth: 0.5)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }

    @ViewBuilder
    private func chipView(icon: String, text: String, iconColor: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(iconColor)
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
        .overlay { Capsule().stroke(Color(.separator).opacity(0.3), lineWidth: 0.5) }
    }
}
