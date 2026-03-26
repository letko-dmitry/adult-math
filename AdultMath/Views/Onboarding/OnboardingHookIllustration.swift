import SwiftUI

struct OnboardingHookIllustration: View {
    private static let sampleReceipt = ReceiptData(
        restaurantName: "PARKSIDE DINER",
        lineItems: [
            ReceiptLineItem(name: "Noodles", price: 14.00),
            ReceiptLineItem(name: "Lemonade", price: 4.50),
            ReceiptLineItem(name: "Fries to share", price: 7.00),
        ],
        subtotal: 25.50,
        tipPercentage: 20,
        total: nil
    )

    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.accentGreen.opacity(0.14))
                .frame(width: 220, height: 220)
                .offset(x: -66, y: -6)

            Circle()
                .fill(AppTheme.revealBackground)
                .frame(width: 172, height: 172)
                .offset(x: 92, y: 24)

            Ellipse()
                .fill(.white.opacity(0.92))
                .frame(width: 290, height: 84)
                .blur(radius: 10)
                .offset(y: 88)

            HStack(spacing: -12) {
                Circle()
                    .fill(AppTheme.accentGreen.opacity(0.18))
                    .frame(width: 36, height: 36)

                Circle()
                    .fill(AppTheme.revealBorder.opacity(0.9))
                    .frame(width: 36, height: 36)

                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 36, height: 36)
            }
            .overlay {
                HStack(spacing: 18) {
                    Image(systemName: "person.fill")
                    Image(systemName: "person.fill")
                    Image(systemName: "person.fill")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            }
            .offset(x: -78, y: -78)

            ReceiptCardView(data: Self.sampleReceipt)
                .frame(width: 236)
                .fixedSize(horizontal: false, vertical: true)
                .rotationEffect(.degrees(-7))
                .shadow(color: .black.opacity(0.08), radius: 16, y: 12)
                .offset(y: 18)

            Label("20% tip", systemImage: "sparkles")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.accentGreen)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(.white, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(AppTheme.accentGreen.opacity(0.16), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
                .offset(x: 122, y: -92)
                .zIndex(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 256)
        .accessibilityHidden(true)
    }
}
