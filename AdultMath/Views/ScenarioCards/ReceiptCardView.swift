import SwiftUI

struct ReceiptCardView: View {
    let data: ReceiptData

    var body: some View {
        VStack(spacing: 0) {
            // Restaurant name
            Text(data.restaurantName)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .padding(.top, 20)
                .padding(.bottom, 4)

            Text("- - - - - - - - - - - - - - - -")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)

            // Line items
            VStack(spacing: 6) {
                ForEach(Array(data.lineItems.enumerated()), id: \.offset) { _, item in
                    HStack {
                        Text(item.name)
                            .font(AppTheme.receiptFont)
                            .lineLimit(1)
                        Spacer()
                        Text(formatPrice(item.price))
                            .font(AppTheme.receiptFont)
                    }
                }
            }
            .padding(.horizontal, 20)

            // Dashed separator
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .foregroundStyle(.secondary.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            // Subtotal
            VStack(spacing: 6) {
                HStack {
                    Text("Subtotal")
                        .font(AppTheme.receiptBold)
                    Spacer()
                    Text(formatPrice(data.subtotal))
                        .font(AppTheme.receiptBold)
                }

                if let tipPercent = data.tipPercentage {
                    HStack {
                        Text("Tip (\(tipPercent)%)")
                            .font(AppTheme.receiptFont)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("?")
                            .font(AppTheme.receiptBold)
                            .foregroundStyle(Color.accentColor)
                    }
                }

                if let total = data.total {
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                        .foregroundStyle(.secondary.opacity(0.5))
                        .frame(height: 1)
                        .padding(.vertical, 4)

                    HStack {
                        Text("TOTAL")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                        Spacer()
                        Text(formatPrice(total))
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.receiptBackground)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        }
    }

    private func formatPrice(_ value: Double) -> String {
        value.formatted(.currency(code: "USD"))
    }
}

private struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}
