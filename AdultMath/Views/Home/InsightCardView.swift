import SwiftUI

struct InsightCardView: View {
    let text: String

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: AppTheme.cornerRadius)

        HStack(spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16))
                .foregroundStyle(AppTheme.streakFlame)

            Text(text)
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.paddingMedium)
        .contentShape(shape)
        .glassEffect(.regular, in: shape)
    }
}
