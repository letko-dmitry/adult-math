import Foundation

enum FullScreenDestination: Identifiable {
    case onboarding
    case quiz(Topic?)
    case firstQuiz

    var id: String {
        switch self {
        case .onboarding: "onboarding"
        case .quiz(let topic): "quiz-\(topic?.rawValue ?? "mixed")"
        case .firstQuiz: "firstQuiz"
        }
    }
}
