import SwiftUI

struct CommitmentContractView: View {
    var isHighScore: Bool = true
    let onCommit: () -> Void

    @State private var holdProgress: CGFloat = 0
    @State private var isHolding = false
    @State private var isCommitted = false
    @State private var showContinue = false
    @State private var showConfetti = false

    private let holdDuration: CGFloat = 0.8

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 24)

                WeeklyPlannerIllustration(
                    isCommitted: isCommitted,
                    isHolding: isHolding
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 28)

                Text(isHighScore
                     ? "You're sharper than you thought!"
                     : "Imagine where a week of practice takes you.")
                    .font(AppTheme.heroTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingXLarge)

                Text(isHighScore
                     ? "Keep the rhythm going — a few minutes a day is all it takes."
                     : "A few minutes a day changes everything. No pressure — just a simple rhythm.")
                    .font(AppTheme.bodyText)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingXLarge)
                    .padding(.top, 12)

                Spacer(minLength: 24)

                VStack(spacing: 16) {
                    if !isCommitted {
                        ZStack {
                            Circle()
                                .stroke(Color.accentColor.opacity(0.2), lineWidth: 6)
                                .frame(width: 88, height: 88)

                            Circle()
                                .trim(from: 0, to: holdProgress)
                                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .frame(width: 88, height: 88)
                                .rotationEffect(.degrees(-90))

                            Circle()
                                .fill(Color.accentColor.opacity(0.15))
                                .frame(width: 76, height: 76)
                                .scaleEffect(isHolding ? 1 : 0.85)

                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.accentColor)
                                .scaleEffect(isHolding ? 1.1 : 1.0)
                        }
                        .animation(.easeInOut(duration: 0.2), value: isHolding)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !isHolding && !isCommitted {
                                        startHolding()
                                    }
                                }
                                .onEnded { _ in
                                    if !isCommitted {
                                        stopHolding()
                                    }
                                }
                        )
                        .transition(.scale.combined(with: .opacity))

                        Text("Hold to agree")
                            .font(AppTheme.captionMedium)
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(AppTheme.accentGreen)
                            .transition(.scale.combined(with: .opacity))

                        Text("You're in!")
                            .font(AppTheme.sectionTitle)
                            .transition(.opacity)

                        if showContinue {
                            PrimaryButton("Let's go", action: onCommit)
                                .padding(.horizontal, AppTheme.paddingMedium)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 200, alignment: .bottom)
                .sensoryFeedback(.success, trigger: isCommitted)
                .animation(.spring(duration: 0.5, bounce: 0.2), value: isCommitted)
                .animation(.easeInOut(duration: 0.3), value: showContinue)
                .padding(.bottom, AppTheme.bottomScreenCTAInset)
            }

            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
    }

    private func startHolding() {
        isHolding = true
        withAnimation(.linear(duration: holdDuration)) {
            holdProgress = 1.0
        }
        Task {
            try? await Task.sleep(for: .seconds(holdDuration))
            if isHolding {
                completeCommitment()
            }
        }
    }

    private func stopHolding() {
        isHolding = false
        withAnimation(.easeOut(duration: 0.3)) {
            holdProgress = 0
        }
    }

    private func completeCommitment() {
        isHolding = false
        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
            isCommitted = true
            showConfetti = true
        }
        Task {
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation(.easeInOut(duration: 0.3)) {
                showContinue = true
            }
        }
    }
}

private struct WeeklyPlannerIllustration: View {
    let isCommitted: Bool
    let isHolding: Bool

    private let weekdayTitles = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    private var currentDayIndex: Int {
        let weekday = Calendar.current.component(.weekday, from: .now)
        return (weekday + 5) % 7
    }

    private var weekDates: [Int] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let offsetToMonday = currentDayIndex
        guard let monday = calendar.date(byAdding: .day, value: -offsetToMonday, to: today) else {
            let fallbackDay = calendar.component(.day, from: today)
            return Array(repeating: fallbackDay, count: weekdayTitles.count)
        }

        return (0..<weekdayTitles.count).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: monday) else {
                return nil
            }
            return calendar.component(.day, from: date)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This week")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(isCommitted ? "Today is locked in." : "Start with today.")
                        .font(AppTheme.smallCaption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(isCommitted ? "Planned" : "Today")
                    .font(AppTheme.chipSemibold)
                    .foregroundStyle(isCommitted ? AppTheme.accentGreen : AppTheme.revealText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(badgeBackgroundColor, in: Capsule())
            }

            HStack(spacing: 8) {
                ForEach(weekdayTitles.indices, id: \.self) { index in
                    WeeklyPlannerDayCell(
                        weekdayTitle: weekdayTitles[index],
                        dayNumber: weekDates[safe: index] ?? 0,
                        state: dayState(for: index),
                        isAnimating: isHolding && index == currentDayIndex
                    )
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.secondarySystemBackground),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(Color(.separator).opacity(0.14), lineWidth: 0.8)
        }
        .frame(height: 170)
        .shadow(color: .black.opacity(0.05), radius: 18, y: 10)
        .accessibilityHidden(true)
    }

    private func dayState(for index: Int) -> WeeklyPlannerDayCell.State {
        if index < currentDayIndex {
            return .past
        }

        if index == currentDayIndex {
            return isCommitted ? .committedToday : .today
        }

        return .upcoming
    }

    private var badgeBackgroundColor: Color {
        isCommitted ? AppTheme.accentGreen.opacity(0.14) : AppTheme.revealBackground
    }
}

private struct WeeklyPlannerDayCell: View {
    enum State {
        case past
        case today
        case committedToday
        case upcoming
    }

    let weekdayTitle: String
    let dayNumber: Int
    let state: State
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text(weekdayTitle)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(titleColor)

            ZStack {
                Circle()
                    .fill(indicatorBackgroundColor)
                    .frame(width: 30, height: 30)

                switch state {
                case .committedToday:
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppTheme.accentGreen)
                case .today:
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 10, height: 10)
                case .past, .upcoming:
                    EmptyView()
                }
            }

            Text(dayNumber == 0 ? " " : "\(dayNumber)")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(numberColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 92)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(backgroundColor)
                .stroke(borderColor, lineWidth: 1)
        }
        .shadow(color: shadowColor, radius: state == .today || state == .committedToday ? 14 : 8, y: 6)
        .scaleEffect(isAnimating ? 1.04 : (state == .today || state == .committedToday ? 1.02 : 1))
        .animation(.easeInOut(duration: 0.2), value: isAnimating)
        .animation(.spring(duration: 0.35, bounce: 0.18), value: state)
    }

    private var backgroundColor: Color {
        switch state {
        case .past:
            return Color(.systemGray6)
        case .today:
            return AppTheme.revealBackground
        case .committedToday:
            return AppTheme.accentGreen.opacity(0.16)
        case .upcoming:
            return Color(.systemBackground)
        }
    }

    private var borderColor: Color {
        switch state {
        case .past:
            return Color(.separator).opacity(0.08)
        case .today:
            return AppTheme.revealBorder
        case .committedToday:
            return AppTheme.accentGreen.opacity(0.55)
        case .upcoming:
            return Color(.separator).opacity(0.18)
        }
    }

    private var indicatorBackgroundColor: Color {
        switch state {
        case .past:
            return Color(.systemGray5)
        case .today:
            return Color.accentColor.opacity(0.14)
        case .committedToday:
            return AppTheme.accentGreen.opacity(0.16)
        case .upcoming:
            return Color(.systemGray6)
        }
    }

    private var titleColor: Color {
        switch state {
        case .past:
            return .secondary
        case .today:
            return AppTheme.revealText
        case .committedToday:
            return AppTheme.accentGreen
        case .upcoming:
            return .secondary
        }
    }

    private var numberColor: Color {
        switch state {
        case .past:
            return .secondary
        case .today:
            return .primary
        case .committedToday:
            return AppTheme.accentGreen
        case .upcoming:
            return .primary
        }
    }

    private var shadowColor: Color {
        switch state {
        case .past:
            return .black.opacity(0.02)
        case .today:
            return Color.accentColor.opacity(0.12)
        case .committedToday:
            return AppTheme.accentGreen.opacity(0.12)
        case .upcoming:
            return .black.opacity(0.05)
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
