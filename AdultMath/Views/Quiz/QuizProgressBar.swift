import SwiftUI

struct QuizProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index < current ? Color.accentColor : index == current ? Color.accentColor.opacity(0.5) : Color.secondary.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
