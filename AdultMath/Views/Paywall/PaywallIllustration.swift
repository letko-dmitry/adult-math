import SwiftUI

struct PaywallIllustration: View {
    let topic: Topic

    /// Two other locked topics to show behind the main card
    private var backgroundTopics: [Topic] {
        let locked: [Topic] = [.travelTime, .homeBudget, .cookingPortions, .timeManagement, .fitnessGoals]
        return locked.filter { $0 != topic }.prefix(2).map { $0 }
    }

    var body: some View {
        ZStack {
            // Decorative background circles
            Circle()
                .fill(AppTheme.accentGreen.opacity(0.14))
                .frame(width: 190, height: 190)
                .offset(x: -58, y: -4)

            Circle()
                .fill(AppTheme.revealBackground)
                .frame(width: 155, height: 155)
                .offset(x: 82, y: 18)

            // Ground shadow
            Ellipse()
                .fill(.white.opacity(0.92))
                .frame(width: 270, height: 72)
                .blur(radius: 10)
                .offset(y: 84)

            // Back-left card (other locked topic)
            PaywallPreviewCard(topic: backgroundTopics[0])
                .frame(width: 170)
                .fixedSize(horizontal: false, vertical: true)
                .rotationEffect(.degrees(-10))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 8)
                .offset(x: -68, y: 16)

            // Back-right card (other locked topic)
            PaywallPreviewCard(topic: backgroundTopics[1])
                .frame(width: 170)
                .fixedSize(horizontal: false, vertical: true)
                .rotationEffect(.degrees(8))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 8)
                .offset(x: 72, y: 20)

            // Front center card (selected topic)
            PaywallPreviewCard(topic: topic)
                .frame(width: 200)
                .fixedSize(horizontal: false, vertical: true)
                .rotationEffect(.degrees(-2))
                .shadow(color: .black.opacity(0.08), radius: 16, y: 10)
                .offset(y: 14)

            // Floating badge
            Label("5 topics", systemImage: "lock.open.fill")
                .font(AppTheme.smallSemibold)
                .foregroundStyle(AppTheme.accentGreen)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(.white, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(AppTheme.accentGreen.opacity(0.16), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.05), radius: 10, y: 6)
                .offset(x: 112, y: -86)
                .zIndex(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .accessibilityHidden(true)
    }
}
