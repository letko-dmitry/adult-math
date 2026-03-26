import Foundation
import SwiftUI

@MainActor
@Observable
final class ProgressManager {
    // MARK: - Persisted State

    private static let onboardingCompleteKey = "onboardingComplete"
    private static let currentStreakKey = "currentStreak"
    private static let bestStreakKey = "bestStreak"
    private static let lastActiveDateKey = "lastActiveDate"

    private(set) var onboardingComplete: Bool = false {
        didSet { UserDefaults.standard.set(onboardingComplete, forKey: Self.onboardingCompleteKey) }
    }

    private(set) var currentStreak: Int = 0 {
        didSet { UserDefaults.standard.set(currentStreak, forKey: Self.currentStreakKey) }
    }

    private(set) var bestStreak: Int = 0 {
        didSet { UserDefaults.standard.set(bestStreak, forKey: Self.bestStreakKey) }
    }

    private var lastActiveDateString: String = "" {
        didSet { UserDefaults.standard.set(lastActiveDateString, forKey: Self.lastActiveDateKey) }
    }

    // MARK: - First Quiz

    private(set) var isFirstQuizComplete: Bool = false {
        didSet { UserDefaults.standard.set(isFirstQuizComplete, forKey: Self.firstQuizCompleteKey) }
    }

    private static let firstQuizCompleteKey = "isFirstQuizComplete"

    func recordFirstQuizComplete() {
        isFirstQuizComplete = true
    }

    // MARK: - Quiz History

    private(set) var quizHistory: [QuizResult] = []

    private static let quizHistoryKey = "quizHistory"

    // MARK: - Computed (cached today)

    private var todayStart: Date {
        Calendar.current.startOfDay(for: .now)
    }

    private var todayResults: [QuizResult] {
        let start = todayStart
        return quizHistory.filter { Calendar.current.startOfDay(for: $0.date) == start }
    }

    var isTodayComplete: Bool {
        lastActiveDate == todayStart
    }

    var totalQuizzesCompleted: Int {
        quizHistory.count
    }

    var todayQuizCount: Int {
        todayResults.count
    }

    // MARK: - Analytics

    var totalProblemsSolved: Int {
        quizHistory.reduce(0) { $0 + $1.score }
    }

    var todayProblemsSolved: Int {
        todayResults.reduce(0) { $0 + $1.score }
    }

    func quizCount(for topic: Topic) -> Int {
        quizHistory.filter { $0.topic == topic }.count
    }

    func averageScore(for topic: Topic) -> Double? {
        let matching = quizHistory.filter { $0.topic == topic }
        guard !matching.isEmpty else { return nil }
        let total = matching.reduce(0.0) { $0 + Double($1.score) / Double($1.totalQuestions) }
        return total / Double(matching.count)
    }

    func confidenceState(for topic: Topic) -> String {
        let count = quizCount(for: topic)
        guard count > 0 else { return "Ready for practice" }
        let avg = averageScore(for: topic) ?? 0.0
        if count <= 2 {
            return avg < 0.7 ? "Building confidence" : "Getting comfortable"
        } else {
            return avg >= 0.8 ? "Feeling solid" : "Getting comfortable"
        }
    }

    var strongestTopic: Topic? {
        Topic.unlocked
            .filter { quizCount(for: $0) >= 1 }
            .max { (averageScore(for: $0) ?? 0.0) < (averageScore(for: $1) ?? 0.0) }
    }

    var leastPracticedTopic: Topic? {
        Topic.unlocked.min { quizCount(for: $0) < quizCount(for: $1) }
    }

    // MARK: - Timing Insights

    func averageAnswerTime(for topic: Topic) -> TimeInterval? {
        let times = quizHistory
            .filter { $0.topic == topic }
            .compactMap(\.answerTimes)
            .flatMap { $0 }
        guard !times.isEmpty else { return nil }
        return times.reduce(0, +) / Double(times.count)
    }

    func averageAnswerTimeOverall() -> TimeInterval? {
        let times = quizHistory.compactMap(\.answerTimes).flatMap { $0 }
        guard !times.isEmpty else { return nil }
        return times.reduce(0, +) / Double(times.count)
    }

    var fastestTopic: Topic? {
        let withTimes = Topic.unlocked.filter { averageAnswerTime(for: $0) != nil }
        return withTimes.min { (averageAnswerTime(for: $0) ?? .infinity) < (averageAnswerTime(for: $1) ?? .infinity) }
    }

    /// Single most relevant insight message, or nil if not enough data.
    var currentInsight: String? {
        // 1. Speed improvement: compare latest quiz to previous average
        let quizzesWithTiming = quizHistory.filter { $0.answerTimes != nil }
        if quizzesWithTiming.count >= 2,
           let latest = quizzesWithTiming.last,
           let latestTimes = latest.answerTimes,
           !latestTimes.isEmpty {
            let latestAvg = latestTimes.reduce(0, +) / Double(latestTimes.count)

            // Use topic-specific comparison when available, overall otherwise
            let previousQuizzes: ArraySlice<QuizResult>
            let insightLabel: String
            if let topic = latest.topic {
                previousQuizzes = quizzesWithTiming.dropLast().filter { $0.topic == topic }[...]
                insightLabel = topic.title.lowercased()
            } else {
                previousQuizzes = quizzesWithTiming.dropLast()[...]
                insightLabel = "math"
            }
            let previousTimes = previousQuizzes.compactMap(\.answerTimes).flatMap { $0 }
            if !previousTimes.isEmpty {
                let previousAvg = previousTimes.reduce(0, +) / Double(previousTimes.count)
                if latestAvg < previousAvg * 0.85 {
                    return "You're getting faster with \(insightLabel)!"
                }
            }
        }

        // 2. Personalization: strongest topic + suggested next
        if let strongest = strongestTopic,
           let suggested = leastPracticedTopic,
           strongest != suggested {
            return "\(strongest.title) looks strongest — try \(suggested.title) next."
        }

        // 3. Fastest topic
        if let fastest = fastestTopic {
            return "Your quickest topic is \(fastest.title)."
        }

        return nil
    }

    var userHomeState: HomeState {
        if totalQuizzesCompleted == 0 {
            return .newUser
        } else if currentStreak == 0 && totalQuizzesCompleted > 0 {
            return .afterInactivity
        } else if currentStreak >= 1 && todayQuizCount == 0 {
            return .returning
        } else {
            return .afterFirstSession
        }
    }

    private var lastActiveDate: Date? {
        get {
            guard !lastActiveDateString.isEmpty else { return nil }
            return try? Date(lastActiveDateString, strategy: .iso8601)
        }
        set {
            if let date = newValue {
                lastActiveDateString = date.formatted(.iso8601)
            } else {
                lastActiveDateString = ""
            }
        }
    }

    // MARK: - Init

    init() {
        self.onboardingComplete = UserDefaults.standard.bool(forKey: Self.onboardingCompleteKey)
        self.currentStreak = UserDefaults.standard.integer(forKey: Self.currentStreakKey)
        self.bestStreak = UserDefaults.standard.integer(forKey: Self.bestStreakKey)
        self.lastActiveDateString = UserDefaults.standard.string(forKey: Self.lastActiveDateKey) ?? ""
        self.isFirstQuizComplete = UserDefaults.standard.bool(forKey: Self.firstQuizCompleteKey)
        loadQuizHistory()
    }

    // MARK: - Actions

    func recordQuizCompletion(topic: Topic?, score: Int, totalQuestions: Int, answerTimes: [TimeInterval]? = nil) {
        let result = QuizResult(topic: topic, score: score, totalQuestions: totalQuestions, answerTimes: answerTimes)
        quizHistory.append(result)
        saveQuizHistory()
        recordActivity()
    }

    func recordOnboardingComplete() {
        onboardingComplete = true
        recordActivity()
    }

    func checkAndUpdateStreak() {
        guard let lastDate = lastActiveDate else { return }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let daysSinceLastActive = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0

        if daysSinceLastActive > 1 {
            currentStreak = 0
        }
    }

    // MARK: - Private

    private func recordActivity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        if let lastDate = lastActiveDate {
            let daysSinceLastActive = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0

            if daysSinceLastActive == 1 {
                currentStreak += 1
            } else if daysSinceLastActive > 1 {
                currentStreak = 1
            }
            // daysSinceLastActive == 0: same day, no change
        } else {
            currentStreak = 1
        }

        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }

        lastActiveDate = today
    }

    private func loadQuizHistory() {
        guard let data = UserDefaults.standard.data(forKey: Self.quizHistoryKey),
              let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) else {
            return
        }
        quizHistory = decoded
    }

    private func saveQuizHistory() {
        guard let data = try? JSONEncoder().encode(quizHistory) else { return }
        UserDefaults.standard.set(data, forKey: Self.quizHistoryKey)
    }

}
