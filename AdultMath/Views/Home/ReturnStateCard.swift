import SwiftUI

struct ReturnStateCard: View {
    let title: String
    let subtitle: String
    let onStart: () -> Void

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: AppTheme.cornerRadius)

        Button(action: onStart) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))

                Text(subtitle)
                    .font(AppTheme.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.paddingMedium)
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular, in: shape)
    }
}
