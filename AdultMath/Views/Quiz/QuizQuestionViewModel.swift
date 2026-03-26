import Foundation

@Observable
@MainActor
final class QuizQuestionViewModel {
    let question: Question
    let shuffledIndices: [Int]

    private(set) var selectedIndex: Int?
    private(set) var showFeedback = false

    var isCorrect: Bool {
        selectedIndex == question.correctAnswerIndex
    }

    var canContinue: Bool {
        selectedIndex != nil
    }

    init(question: Question) {
        self.question = question
        self.shuffledIndices = Array(question.options.indices).shuffled()
    }

    /// Returns whether the answer was correct, or `nil` if already answered.
    func selectAnswer(_ index: Int) -> Bool? {
        guard selectedIndex == nil else { return nil }
        selectedIndex = index
        return index == question.correctAnswerIndex
    }

    func revealFeedback() {
        showFeedback = true
    }

    func optionState(for index: Int) -> OptionButton.State {
        guard let selected = selectedIndex else { return .idle }
        if index == question.correctAnswerIndex { return .correct }
        if index == selected { return .incorrect }
        return .disabled
    }

    func showsPositiveFeedback(for index: Int) -> Bool {
        showFeedback && selectedIndex == index && isCorrect
    }

    func showsNegativeFeedback(for index: Int) -> Bool {
        showFeedback && selectedIndex == index && !isCorrect
    }
}
