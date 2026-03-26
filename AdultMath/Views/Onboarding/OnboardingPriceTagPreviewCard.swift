import SwiftUI

struct OnboardingPriceTagPreviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label("Fresh Market", systemImage: "cart.fill")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.bottom, 14)

            itemRow(
                title: "Coffee Beans",
                unit: "12 oz",
                currentPrice: "$8.99",
                originalPrice: "$11.99",
                isDiscounted: true
            )

            Divider()
                .overlay(Color(.separator).opacity(0.22))
                .padding(.vertical, 10)

            itemRow(
                title: "Granola",
                unit: nil,
                currentPrice: "$4.49",
                originalPrice: nil,
                isDiscounted: false
            )

            Text("SAVE 25%")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.red))
                .padding(.top, 14)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .stroke(Color(.separator).opacity(0.18), lineWidth: 0.8)
        }
    }

    @ViewBuilder
    private func itemRow(
        title: String,
        unit: String?,
        currentPrice: String,
        originalPrice: String?,
        isDiscounted: Bool
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                if let unit {
                    Text(unit)
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 3) {
                if let originalPrice {
                    Text(originalPrice)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .strikethrough()
                }

                Text(currentPrice)
                    .font(.system(size: isDiscounted ? 18 : 17, weight: .bold, design: .monospaced))
                    .foregroundStyle(isDiscounted ? Color.red : .primary)
            }
        }
    }
}
