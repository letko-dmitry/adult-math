import SwiftUI

struct StreakCounterView: View {
    let currentStreak: Int
    let bestStreak: Int

    var body: some View {
        HStack(spacing: AppTheme.spacingSection) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(currentStreak > 1 ? AppTheme.streakFlame : .secondary)

                Text(currentStreak > 1 ? "\(currentStreak)-day streak" : "Start your streak!")
                    .font(AppTheme.bodySemibold)
                    .foregroundStyle(currentStreak > 1 ? .primary : .secondary)
            }

            Spacer()

            if bestStreak > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Text("Best: \(bestStreak)")
                        .font(AppTheme.smallCaption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, AppTheme.paddingMedium)
        .padding(.vertical, 12)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))
    }
}
