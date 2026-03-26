import SwiftUI

struct ContextualBannerView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(NotificationState.self) private var notificationState
    @Environment(NotificationService.self) private var notificationService
    let onStartQuiz: () -> Void

    var body: some View {
        if let variant = notificationState.cardForHome(homeState: progressManager.userHomeState) {
            NotificationReminderCard(
                variant: variant,
                onEnable: { hour, minute in
                    Task {
                        let granted = await notificationService
                            .requestPermissionAndSchedule(hour: hour, minute: minute)
                        if granted {
                            notificationState.enable(hour: hour, minute: minute)
                        }
                    }
                },
                onDismiss: {
                    withAnimation { notificationState.dismissForever() }
                }
            )
        } else {
            switch progressManager.userHomeState {
            case .returning:
                ReturnStateCard(
                    title: "Keep your streak going",
                    subtitle: "Today's practice is waiting for you.",
                    onStart: onStartQuiz
                )
            case .afterInactivity:
                ReturnStateCard(
                    title: "Pick up where you left off",
                    subtitle: "One quick step and you're back in it.",
                    onStart: onStartQuiz
                )
            case .newUser, .afterFirstSession:
                EmptyView()
            }
        }
    }
}
