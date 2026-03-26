import SwiftUI

struct OptionButton: View {
    enum State {
        case idle, correct, incorrect, disabled
    }

    let text: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: state == .idle ? .regular : .medium, design: .rounded))
                    .foregroundStyle(foregroundColor)
                    .multilineTextAlignment(.leading)
                Spacer()
                if state == .correct {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.accentGreen)
                } else if state == .incorrect {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.accentOrange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .frame(minHeight: 60)
            .contentShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
            .glassEffect(glassConfig, in: RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
        }
        .buttonStyle(.plain)
        .disabled(state != .idle)
    }

    private var foregroundColor: Color {
        switch state {
        case .idle: .primary
        case .correct: AppTheme.correctText
        case .incorrect: AppTheme.incorrectText
        case .disabled: .secondary
        }
    }

    private var glassConfig: Glass {
        switch state {
        case .idle: .regular.interactive(true)
        case .correct: .regular.tint(AppTheme.accentGreen)
        case .incorrect: .regular.tint(AppTheme.accentOrange)
        case .disabled: .regular
        }
    }
}
