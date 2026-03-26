import SwiftUI

struct FeedbackView: View {
    let isCorrect: Bool
    let explanation: [String]

    @State private var title = ""
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let correctTitles = ["Nice!", "Spot on!", "Nailed it!", "You got it!"]

    var body: some View {
        if isCorrect {
            Text(title)
                .font(AppTheme.smallBold)
                .foregroundStyle(AppTheme.accentGreen)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .accessibilityLabel("Correct. \(title)")
            .background(.thinMaterial)
            .background(AppTheme.accentGreen.opacity(0.14))
            .clipShape(.capsule)
            .overlay {
                Capsule()
                    .stroke(AppTheme.accentGreen.opacity(0.22), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            .transition(reduceMotion ? .identity : .opacity)
            .onAppear {
                if title.isEmpty {
                    title = Self.correctTitles.randomElement()!
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppTheme.revealText)

                    Text("Almost right — here's the last step")
                        .font(AppTheme.bodySemibold)
                        .foregroundStyle(AppTheme.revealText)
                }

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(explanation.prefix(4).enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .foregroundStyle(AppTheme.revealText.opacity(0.7))
                                .frame(width: 20, alignment: .trailing)

                            Text(step)
                                .font(AppTheme.caption)
                                .foregroundStyle(AppTheme.revealText)
                        }
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: 320, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.revealBackground)
            .clipShape(.rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppTheme.revealBorder, lineWidth: 1)
            }
            .transition(reduceMotion ? .identity : .opacity)
        }
    }
}
