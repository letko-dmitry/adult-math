import Testing
import Foundation
@testable import AdultMath

@Suite("ProgressManager Analytics")
struct ProgressManagerTests {

    // MARK: - Total Problems Solved

    @Test("totalProblemsSolved sums scores across all quizzes")
    @MainActor func totalProblemsSolved() {
        let manager = makeCleanManager()
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .foodAndCalories, score: 5, totalQuestions: 10)
        #expect(manager.totalProblemsSolved == 12)
    }

    @Test("totalProblemsSolved is 0 for empty history")
    @MainActor func totalProblemsSolvedEmpty() {
        let manager = makeCleanManager()
        #expect(manager.totalProblemsSolved == 0)
    }

    // MARK: - Confidence State

    @Test("confidenceState returns 'Ready for practice' when no quizzes taken")
    @MainActor func confidenceStateNoQuizzes() {
        let manager = makeCleanManager()
        #expect(manager.confidenceState(for: .tipsAndChecks) == "Ready for practice")
    }

    @Test("confidenceState returns 'Building confidence' for 1-2 quizzes with low average")
    @MainActor func confidenceStateBuildingConfidence() {
        let manager = makeCleanManager()
        // 5/10 = 0.5, which is < 0.7
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 5, totalQuestions: 10)
        #expect(manager.confidenceState(for: .tipsAndChecks) == "Building confidence")
    }

    @Test("confidenceState returns 'Getting comfortable' for 1-2 quizzes with high average")
    @MainActor func confidenceStateGettingComfortable() {
        let manager = makeCleanManager()
        // 8/10 = 0.8, which is >= 0.7
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 8, totalQuestions: 10)
        #expect(manager.confidenceState(for: .tipsAndChecks) == "Getting comfortable")
    }

    @Test("confidenceState returns 'Feeling solid' for 3+ quizzes with high average")
    @MainActor func confidenceStateFeelingSolid() {
        let manager = makeCleanManager()
        // 3 quizzes, average = (9 + 8 + 9) / (10 + 10 + 10) = 26/30 ≈ 0.867 >= 0.8
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 9, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 8, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 9, totalQuestions: 10)
        #expect(manager.confidenceState(for: .tipsAndChecks) == "Feeling solid")
    }

    @Test("confidenceState returns 'Getting comfortable' for 3+ quizzes with moderate average")
    @MainActor func confidenceStateModerateAfterMany() {
        let manager = makeCleanManager()
        // 3 quizzes, average = (7 + 6 + 7) / (10 + 10 + 10) = 20/30 ≈ 0.667 < 0.8
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 6, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        #expect(manager.confidenceState(for: .tipsAndChecks) == "Getting comfortable")
    }

    // MARK: - Strongest Topic

    @Test("strongestTopic returns topic with highest average score")
    @MainActor func strongestTopicReturnsHighest() {
        let manager = makeCleanManager()
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 6, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .foodAndCalories, score: 9, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .shoppingAndDiscounts, score: 7, totalQuestions: 10)
        #expect(manager.strongestTopic == .foodAndCalories)
    }

    @Test("strongestTopic is nil when no quizzes taken")
    @MainActor func strongestTopicEmpty() {
        let manager = makeCleanManager()
        #expect(manager.strongestTopic == nil)
    }

    @Test("strongestTopic ignores locked topics")
    @MainActor func strongestTopicIgnoresLocked() {
        let manager = makeCleanManager()
        // travelTime is locked, so even with a perfect score it should not be strongest
        manager.recordQuizCompletion(topic: .travelTime, score: 10, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 5, totalQuestions: 10)
        #expect(manager.strongestTopic == .tipsAndChecks)
    }

    // MARK: - Least Practiced Topic

    @Test("leastPracticedTopic returns topic with fewest quizzes")
    @MainActor func leastPracticedReturnsLowest() {
        let manager = makeCleanManager()
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 8, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .foodAndCalories, score: 9, totalQuestions: 10)
        // shoppingAndDiscounts has 0 quizzes, which is lowest among unlocked
        #expect(manager.leastPracticedTopic == .shoppingAndDiscounts)
    }

    @Test("leastPracticedTopic ignores locked topics")
    @MainActor func leastPracticedIgnoresLocked() {
        let manager = makeCleanManager()
        // All unlocked topics get quizzes; locked topics should not be returned
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .foodAndCalories, score: 7, totalQuestions: 10)
        manager.recordQuizCompletion(topic: .shoppingAndDiscounts, score: 7, totalQuestions: 10)
        let result = manager.leastPracticedTopic
        #expect(result != nil)
        #expect(result?.isLocked == false)
    }

    // MARK: - User Home State

    @Test("userHomeState is .newUser when no quizzes completed")
    @MainActor func homeStateNewUser() {
        let manager = makeCleanManager()
        #expect(manager.userHomeState == .newUser)
    }

    @Test("userHomeState is .afterFirstSession when quiz completed today")
    @MainActor func homeStateAfterFirstSession() {
        let manager = makeCleanManager()
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        // Just completed a quiz, so streak > 0 and todayQuizCount > 0
        #expect(manager.userHomeState == .afterFirstSession)
    }

    @Test("userHomeState is .afterInactivity when streak is 0 but has history")
    @MainActor func homeStateAfterInactivity() {
        let manager = makeCleanManager()
        manager.recordQuizCompletion(topic: .tipsAndChecks, score: 7, totalQuestions: 10)
        // Simulate inactivity: currentStreak is private(set), so write 0 to UserDefaults
        // and re-initialize so the manager reads the reset value.
        // Quiz history is still in UserDefaults from the recordQuizCompletion call above.
        UserDefaults.standard.set(0, forKey: "currentStreak")
        let inactiveManager = ProgressManager()
        #expect(inactiveManager.userHomeState == .afterInactivity)
    }

    // MARK: - First Quiz Complete

    @Test("isFirstQuizComplete defaults to false")
    @MainActor func isFirstQuizCompleteDefault() {
        let manager = makeCleanManager()
        #expect(manager.isFirstQuizComplete == false)
    }

    @Test("recordFirstQuizComplete persists to UserDefaults")
    @MainActor func recordFirstQuizCompletePersists() {
        let manager = makeCleanManager()
        manager.recordFirstQuizComplete()
        #expect(manager.isFirstQuizComplete == true)
        // Verify persistence: read directly from UserDefaults
        #expect(UserDefaults.standard.bool(forKey: "isFirstQuizComplete") == true)
    }

    // MARK: - Empty History Defaults

    @Test("empty history returns sensible defaults")
    @MainActor func emptyHistoryDefaults() {
        let manager = makeCleanManager()
        #expect(manager.totalProblemsSolved == 0)
        #expect(manager.todayProblemsSolved == 0)
        #expect(manager.quizCount(for: .tipsAndChecks) == 0)
        #expect(manager.averageScore(for: .tipsAndChecks) == nil)
        #expect(manager.strongestTopic == nil)
        #expect(manager.leastPracticedTopic != nil) // returns an unlocked topic with 0 quizzes
        #expect(manager.userHomeState == .newUser)
    }

    // MARK: - Helpers

    /// Creates a ProgressManager with a unique UserDefaults suite to avoid test pollution.
    @MainActor private func makeCleanManager() -> ProgressManager {
        // Each test gets a fresh ProgressManager.
        // Because ProgressManager reads from UserDefaults on init, we create a fresh one
        // whose quizHistory key is empty (default state).
        // Note: This relies on the test process having a clean UserDefaults state
        // for the quizHistory key, which is true when tests run in a fresh simulator.
        let manager = ProgressManager()
        // Clear any leftover state from other tests in this process
        UserDefaults.standard.removeObject(forKey: "quizHistory")
        UserDefaults.standard.removeObject(forKey: "currentStreak")
        UserDefaults.standard.removeObject(forKey: "bestStreak")
        UserDefaults.standard.removeObject(forKey: "lastActiveDate")
        UserDefaults.standard.removeObject(forKey: "isFirstQuizComplete")
        // Re-initialize to pick up clean state
        return ProgressManager()
    }
}
