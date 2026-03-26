import SwiftUI

struct QuizResultNotificationPrompt: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(NotificationState.self) private var notificationState
    @Environment(NotificationService.self) private var notificationService

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 12)

        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.streakFlame)

                Text("\(progressManager.currentStreak) \(progressManager.currentStreak == 1 ? "day" : "days") in a row — want a nudge so you don't break it?")
                    .font(AppTheme.captionMedium)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Dismiss", systemImage: "xmark") {
                    withAnimation { notificationState.dismissForever() }
                }
                .labelStyle(.iconOnly)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.tertiary)
                .frame(width: 44, height: 44)
                .buttonStyle(.plain)
            }

            Button {
                let time = NotificationState.roundedCurrentTime
                Task {
                    let granted = await notificationService
                        .requestPermissionAndSchedule(hour: time.hour, minute: time.minute)
                    if granted {
                        withAnimation { notificationState.enable(hour: time.hour, minute: time.minute) }
                    }
                }
            } label: {
                Text("Remind me at \(NotificationState.formattedCurrentTime)")
                    .font(AppTheme.smallCaption)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glass)
            .tint(.accent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .glassEffect(.regular, in: shape)
        .padding(.horizontal, AppTheme.paddingXLarge)
    }
}
