import SwiftUI

struct TopicCardView: View {
    let topic: Topic
    var confidenceState: String?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(topic.isLocked ? 0.1 : 0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: topic.iconName)
                        .font(.system(size: 20))
                        .foregroundStyle(topic.isLocked ? .secondary : Color.accentColor)
                }

                Text(topic.title)
                    .font(AppTheme.bodySemibold)
                    .foregroundStyle(topic.isLocked ? .secondary : .primary)
                    .lineLimit(1)

                Text(topic.description)
                    .font(AppTheme.chip)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let confidenceState, !topic.isLocked {
                    Text(confidenceState)
                        .font(AppTheme.tiny)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .contentShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .glassEffect(.regular.interactive(true), in: RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .overlay(alignment: .topTrailing) {
                if topic.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .padding(10)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
