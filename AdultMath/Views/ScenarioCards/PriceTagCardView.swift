import SwiftUI

struct PriceTagCardView: View {
    let data: PriceTagData

    var body: some View {
        VStack(spacing: 0) {
            // Store header
            HStack {
                Image(systemName: "cart.fill")
                    .font(.system(size: 14))
                Text(data.storeName)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            // Items
            VStack(spacing: 8) {
                ForEach(Array(data.items.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 15, weight: .medium))
                            if let unit = item.unit {
                                Text(unit)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            if data.hideSalePrices == true, let originalPrice = item.originalPrice {
                                // Quiz mode: show original price normally, sale price as "?"
                                Text(formatPrice(originalPrice))
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                Text("?")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.accentColor)
                            } else {
                                if let original = item.originalPrice {
                                    Text(formatPrice(original))
                                        .font(.system(size: 13, design: .monospaced))
                                        .strikethrough()
                                        .foregroundStyle(.secondary)
                                }
                                Text(formatPrice(item.price))
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .foregroundStyle(item.originalPrice != nil ? Color.red : .primary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 8)
            .padding(.bottom, data.discountLabel == nil ? 14 : 0)

            // Discount badge
            if let label = data.discountLabel {
                HStack(spacing: 6) {
                    Image(systemName: "tag.fill")
                        .font(.system(size: 12))
                    Text(label)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.red))
                .padding(.top, 4)
                .padding(.bottom, 14)
            }
        }
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
    }

    private func formatPrice(_ value: Double) -> String {
        value.formatted(.currency(code: "USD"))
    }
}
