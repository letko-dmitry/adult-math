import SwiftUI

struct HookView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: AppTheme.paddingLarge)

            OnboardingHookIllustration()
                .padding(.horizontal, AppTheme.paddingLarge)
                .padding(.bottom, 40)

            // Story text
            VStack(spacing: AppTheme.spacingSection) {
                Text("You're out with friends.")
                    .font(AppTheme.hookTitle)
                    .multilineTextAlignment(.center)

                Text("The bill just arrived.")
                    .font(AppTheme.hookTitle)
                    .foregroundStyle(Color.accentColor)
                    .multilineTextAlignment(.center)
            }

            // Challenge prompt
            Text("Can you figure out the right tip?")
                .padding(.top, AppTheme.paddingMedium)
                .font(AppTheme.subtitle)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer(minLength: AppTheme.paddingLarge)

            PrimaryButton("Try it", action: onContinue)
                .padding(.horizontal, AppTheme.paddingMedium)
                .padding(.bottom, AppTheme.bottomScreenCTAInset)
        }
    }
}
