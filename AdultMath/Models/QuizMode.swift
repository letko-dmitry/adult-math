import Foundation

enum QuizMode: Sendable, Equatable {
    case standard
    case firstQuiz

    var quizSize: Int {
        switch self {
        case .standard: 8
        case .firstQuiz: 5
        }
    }

    var isFirstQuiz: Bool {
        self == .firstQuiz
    }
}
