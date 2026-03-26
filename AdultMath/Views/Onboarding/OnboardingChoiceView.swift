import SwiftUI

struct OnboardingChoiceView: View {
    let sampleWasCorrect: Bool
    let onStartQuiz: () -> Void
    let onSkip: () -> Void

    private var headline: String {
        sampleWasCorrect ? "Nice — you've got this!" : "That's what practice is for!"
    }

    private var subtitle: String {
        "Ready for a full round?\nJust 5 quick questions."
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            VStack(spacing: 0) {
                OnboardingQuizPreviewIllustration()
                    .padding(.horizontal, 12)
                    .padding(.bottom, 90)

                Text(headline)
                    .font(AppTheme.displayTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingLarge)

                Text(subtitle)
                    .padding(.top, AppTheme.spacingContent)
                    .font(AppTheme.subtitleLarge)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingXLarge)
            }

            Spacer(minLength: 0)

            VStack(spacing: AppTheme.spacingSection) {
                PrimaryButton("Let's go", action: onStartQuiz)

                Button(action: onSkip) {
                    Text("I'll start later")
                        .font(AppTheme.subtitle)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, AppTheme.bottomScreenCTAInset)
        }
    }
}
