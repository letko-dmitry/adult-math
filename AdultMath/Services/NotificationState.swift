import Foundation

@MainActor
@Observable
final class NotificationState {
    // MARK: - Persisted Properties

    private(set) var enabled: Bool = false {
        didSet { UserDefaults.standard.set(enabled, forKey: Self.enabledKey) }
    }

    private(set) var dismissed: Bool = false {
        didSet { UserDefaults.standard.set(dismissed, forKey: Self.dismissedKey) }
    }

    private(set) var phase: Int = 0 {
        didSet { UserDefaults.standard.set(phase, forKey: Self.phaseKey) }
    }

    private(set) var reminderHour: Int = 19 {
        didSet { UserDefaults.standard.set(reminderHour, forKey: Self.reminderHourKey) }
    }

    private(set) var reminderMinute: Int = 0 {
        didSet { UserDefaults.standard.set(reminderMinute, forKey: Self.reminderMinuteKey) }
    }

    private static let enabledKey = "notificationEnabled"
    private static let dismissedKey = "notificationDismissed"
    private static let phaseKey = "notificationPhase"
    private static let reminderHourKey = "reminderHour"
    private static let reminderMinuteKey = "reminderMinute"

    // MARK: - Init

    init() {
        self.enabled = UserDefaults.standard.bool(forKey: Self.enabledKey)
        self.dismissed = UserDefaults.standard.bool(forKey: Self.dismissedKey)
        self.phase = UserDefaults.standard.integer(forKey: Self.phaseKey)
        self.reminderHour = UserDefaults.standard.object(forKey: Self.reminderHourKey) as? Int ?? 19
        self.reminderMinute = UserDefaults.standard.object(forKey: Self.reminderMinuteKey) as? Int ?? 0
    }

    // MARK: - Card Variant

    enum CardVariant {
        case presets
        case contextual
        case persistent
    }

    func cardForHome(homeState: HomeState) -> CardVariant? {
        guard !enabled, !dismissed else { return nil }
        if phase >= 3 { return .persistent }

        switch (phase, homeState) {
        case (0, .afterFirstSession): return .presets
        case (1, .returning), (1, .afterInactivity): return .contextual
        default: return nil
        }
    }

    func shouldShowOnQuizResult(streak: Int) -> Bool {
        !enabled && !dismissed && phase == 2 && streak >= 2
    }

    // MARK: - Actions

    func enable(hour: Int, minute: Int) {
        reminderHour = hour
        reminderMinute = minute
        enabled = true
    }

    func dismissForever() {
        dismissed = true
    }

    func advanceFromQuizResult() {
        if phase == 2 {
            phase = 3
        }
    }

    /// Call from HomeView.onAppear to advance phase when the opportunity for the current phase has passed.
    func checkPhaseTransition(homeState: HomeState, streak: Int, totalQuizzes: Int) {
        guard !enabled, !dismissed else { return }

        switch phase {
        case 0:
            if homeState == .returning || homeState == .afterInactivity {
                phase = 1
            }
        case 1:
            if homeState == .afterFirstSession {
                phase = 2
            }
        case 2:
            if streak > 2 || totalQuizzes >= 5 {
                phase = 3
            }
        default:
            break
        }
    }

    // MARK: - Time Helpers (for notification UI)

    static var roundedCurrentTime: (hour: Int, minute: Int) {
        let now = Date.now
        let hour = Calendar.current.component(.hour, from: now)
        let minute = (Calendar.current.component(.minute, from: now) / 5) * 5
        return (hour, minute)
    }

    static var formattedCurrentTime: String {
        let time = roundedCurrentTime
        var components = DateComponents()
        components.hour = time.hour
        components.minute = time.minute
        let date = Calendar.current.date(from: components) ?? .now
        return date.formatted(date: .omitted, time: .shortened)
    }
}
