import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var animate = false

    private let colors: [Color] = [
        .green, .mint, .orange, .yellow, .accentColor,
        AppTheme.accentGreen,
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(
                            x: animate ? particle.endX : particle.startX,
                            y: animate ? geometry.size.height + 60 : particle.startY
                        )
                        .opacity(animate ? 0 : 1)
                }
            }
            .onAppear {
                particles = (0..<30).map { _ in
                    ConfettiParticle(
                        color: colors.randomElement()!,
                        size: CGFloat.random(in: 8...16),
                        startX: CGFloat.random(in: 0...geometry.size.width),
                        startY: CGFloat.random(in: -60...geometry.size.height * 0.28),
                        endX: CGFloat.random(in: 0...geometry.size.width)
                    )
                }
                withAnimation(.easeIn(duration: 3.2)) {
                    animate = true
                }
            }
        }
    }
}

private struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
}
