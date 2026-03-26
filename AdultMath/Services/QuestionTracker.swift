import Foundation
import NonEmpty

@MainActor
@Observable
final class QuestionTracker {
    private var answeredIDs: Set<String> = []
    private static let fileName = "answered_questions.json"

    init() {
        load()
    }

    func markAnswered(_ questionID: String) {
        answeredIDs.insert(questionID)
    }

    func savePendingChanges() {
        save()
    }

    /// Returns questions prioritizing unseen ones, filling up to `minCount` from seen questions if needed.
    /// When all are answered, resets the pool and starts fresh.
    func prioritized(_ questions: NonEmptyArray<Question>, minCount: Int = 8) -> NonEmptyArray<Question> {
        let poolIDs = Set(questions.map(\.id))
        let unseen = questions.filter { !answeredIDs.contains($0.id) }

        if unseen.isEmpty {
            answeredIDs.subtract(poolIDs)
            save()
            return NonEmptyArray(rawValue: questions.shuffled())!
        }

        // Fill up to minCount with seen questions if unseen pool is too small
        if unseen.count < minCount {
            let seen = questions.filter { answeredIDs.contains($0.id) }.shuffled()
            let combined = unseen.shuffled() + seen.prefix(minCount - unseen.count)
            return NonEmptyArray(rawValue: combined)!
        }

        return NonEmptyArray(rawValue: unseen.shuffled())!
    }

    // MARK: - File persistence

    private static var fileURL: URL {
        URL.documentsDirectory.appending(path: fileName)
    }

    private func load() {
        guard let data = try? Data(contentsOf: Self.fileURL),
              let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            return
        }
        answeredIDs = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(answeredIDs) else { return }
        try? data.write(to: Self.fileURL, options: .atomic)
    }
}
