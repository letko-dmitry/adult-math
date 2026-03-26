import SwiftUI

struct OnboardingQuizPreviewIllustration: View {
    private static let receipt = ReceiptData(
        restaurantName: "BISTRO 74",
        lineItems: [
            ReceiptLineItem(name: "Tacos", price: 12.50),
            ReceiptLineItem(name: "Tea", price: 3.50),
        ],
        subtotal: 16.00,
        tipPercentage: 18,
        total: nil
    )

    private static let nutrition = NutritionData(
        title: "Quick Lunch",
        ingredients: [
            NutritionItem(name: "Wrap", calories: 320),
            NutritionItem(name: "Chips", calories: 180),
        ],
        totalCalories: 500,
        calorieLimit: nil
    )

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Label("5 quick questions", systemImage: "bolt.fill")
                    .font(AppTheme.smallSemibold)
                    .foregroundStyle(AppTheme.accentGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppTheme.accentGreen.opacity(0.12), in: Capsule())

                Label("Tips, deals, calories", systemImage: "square.stack.3d.up.fill")
                    .font(AppTheme.smallSemibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6), in: Capsule())
            }

            ZStack {
                Circle()
                    .fill(AppTheme.accentGreen.opacity(0.1))
                    .frame(width: 210, height: 210)
                    .offset(x: -72, y: -10)

                Circle()
                    .fill(AppTheme.revealBackground)
                    .frame(width: 170, height: 170)
                    .offset(x: 92, y: 10)

                NutritionLabelView(data: Self.nutrition, hideTotal: true)
                    .frame(width: 148)
                    .fixedSize(horizontal: false, vertical: true)
                    .rotationEffect(.degrees(-11))
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 8)
                    .offset(x: -82, y: 26)

                OnboardingPriceTagPreviewCard()
                    .frame(width: 156)
                    .fixedSize(horizontal: false, vertical: true)
                    .rotationEffect(.degrees(9))
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 8)
                    .offset(x: 88, y: 30)

                ReceiptCardView(data: Self.receipt)
                    .frame(width: 176)
                    .fixedSize(horizontal: false, vertical: true)
                    .rotationEffect(.degrees(-2))
                    .shadow(color: .black.opacity(0.08), radius: 16, y: 10)
                    .offset(y: 24)
            }
            .frame(height: 214)
        }
        .frame(maxWidth: .infinity)
        .accessibilityHidden(true)
    }
}
