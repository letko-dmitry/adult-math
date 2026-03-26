import SwiftUI

struct PaywallView: View {
    let topic: Topic
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(.systemBackground), AppTheme.accentGreen.opacity(0.08)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Illustration
                    PaywallIllustration(topic: topic)

                    // Title
                    Text(topic.title)
                        .font(AppTheme.heroTitle)

                    // Description
                    Text(topic.description)
                        .font(AppTheme.bodyText)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.paddingXLarge)

                    // Benefits in single glass container
                    benefitsCard

                    Spacer(minLength: 0)

                    VStack(spacing: 12) {
                        // Unlock button (non-functional)
                        PrimaryButton("Unlock with Premium", icon: "lock.open.fill", action: {})

                        Text("7-day free trial, then $4.99/month")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, AppTheme.paddingMedium)
                    .padding(.bottom, AppTheme.bottomScreenCTAInset)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") {
                        dismiss()
                    }
                    .labelStyle(.iconOnly)
                }
            }
        }
    }

    // MARK: - Sub-Views

    private var benefitsCard: some View {
        let shape = RoundedRectangle(cornerRadius: AppTheme.cornerRadius)

        return VStack(alignment: .leading, spacing: AppTheme.spacingSection) {
            benefitRow(icon: "brain.head.profile", text: "10+ practice scenarios")
            benefitRow(icon: "chart.line.uptrend.xyaxis", text: "Track your progress")
            benefitRow(icon: "sparkles", text: "Step-by-step solutions")
            benefitRow(icon: "slider.horizontal.3", text: "Multiple difficulty levels")
            benefitRow(icon: "arrow.triangle.2.circlepath", text: "New questions added regularly")
        }
        .padding(AppTheme.paddingMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(shape)
        .glassEffect(.regular, in: shape)
        .padding(.horizontal, AppTheme.paddingMedium)
    }

    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(AppTheme.accentGreen)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
        }
    }
}
