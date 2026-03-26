import Foundation

struct QuizResult: Codable, Identifiable {
    let id: UUID
    let topic: Topic?
    let score: Int
    let totalQuestions: Int
    let date: Date
    let answerTimes: [TimeInterval]?

    init(topic: Topic?, score: Int, totalQuestions: Int, date: Date = .now, answerTimes: [TimeInterval]? = nil) {
        self.id = UUID()
        self.topic = topic
        self.score = score
        self.totalQuestions = totalQuestions
        self.date = date
        self.answerTimes = answerTimes
    }

    // Explicit CodingKeys for backward-compatible decoding (learning #2)
    private enum CodingKeys: String, CodingKey {
        case id, topic, score, totalQuestions, date, answerTimes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        topic = try container.decodeIfPresent(Topic.self, forKey: .topic)
        score = try container.decode(Int.self, forKey: .score)
        totalQuestions = try container.decode(Int.self, forKey: .totalQuestions)
        date = try container.decode(Date.self, forKey: .date)
        answerTimes = try container.decodeIfPresent([TimeInterval].self, forKey: .answerTimes)
    }
}
