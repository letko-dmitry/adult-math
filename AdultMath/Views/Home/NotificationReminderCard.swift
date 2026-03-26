import SwiftUI

struct NotificationReminderCard: View {
    let variant: NotificationState.CardVariant
    let onEnable: (Int, Int) -> Void
    let onDismiss: () -> Void

    private var currentHour: Int { NotificationState.roundedCurrentTime.hour }
    private var currentMinute: Int { NotificationState.roundedCurrentTime.minute }
    private var timeString: String { NotificationState.formattedCurrentTime }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: AppTheme.cornerRadius)

        VStack(alignment: .leading, spacing: AppTheme.spacingSection) {
            HStack(spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(AppTheme.streakFlame)

                headerText

                Spacer()

                Button("Dismiss", systemImage: "xmark", action: onDismiss)
                    .labelStyle(.iconOnly)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
                    .frame(width: 44, height: 44)
                    .buttonStyle(.plain)
            }

            actionContent
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.paddingMedium)
        .contentShape(shape)
        .glassEffect(.regular, in: shape)
    }

    @ViewBuilder
    private var headerText: some View {
        switch variant {
        case .presets:
            Text("Pick a time for your daily reminder")
                .font(AppTheme.bodySemibold)
        case .contextual:
            Text("You came back — remind at this time?")
                .font(AppTheme.bodySemibold)
        case .persistent:
            Text("Set a daily reminder")
                .font(AppTheme.bodySemibold)
        }
    }

    @ViewBuilder
    private var actionContent: some View {
        switch variant {
        case .presets:
            HStack(spacing: 8) {
                presetButton("Morning", hour: 8, minute: 0)
                presetButton("Afternoon", hour: 13, minute: 0)
                presetButton("Evening", hour: 19, minute: 0)
            }
        case .contextual, .persistent:
            Button {
                onEnable(currentHour, currentMinute)
            } label: {
                Text("Remind me at \(timeString)")
                    .font(AppTheme.captionMedium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.glass)
            .tint(.accent)
        }
    }

    private func presetButton(_ title: String, hour: Int, minute: Int) -> some View {
        Button {
            onEnable(hour, minute)
        } label: {
            Text(title)
                .font(AppTheme.smallCaption)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.glass)
        .tint(.accent)
    }
}
