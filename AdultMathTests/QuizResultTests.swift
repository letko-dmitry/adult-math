import Foundation
import Testing
@testable import AdultMath

@Suite("QuizResult Codable")
struct QuizResultTests {

    @Test("Encodes and decodes with answerTimes")
    func roundTripWithTiming() throws {
        let result = QuizResult(
            topic: .tipsAndChecks,
            score: 6,
            totalQuestions: 8,
            answerTimes: [3.2, 5.1, 2.8, 4.0, 6.3, 3.5, 2.1, 4.7]
        )

        let data = try JSONEncoder().encode(result)
        let decoded = try JSONDecoder().decode(QuizResult.self, from: data)

        #expect(decoded.score == 6)
        #expect(decoded.totalQuestions == 8)
        #expect(decoded.answerTimes?.count == 8)
        #expect(decoded.answerTimes?[0] == 3.2)
    }

    @Test("Decodes legacy format without answerTimes")
    func legacyFormatWithoutTiming() throws {
        // Simulate old persisted data that has no answerTimes field
        let json = """
        {
            "id": "550E8400-E29B-41D4-A716-446655440000",
            "topic": "tipsAndChecks",
            "score": 7,
            "totalQuestions": 10,
            "date": 733000000.0
        }
        """
        let data = json.data(using: .utf8)!
        let decoded = try JSONDecoder().decode(QuizResult.self, from: data)

        #expect(decoded.score == 7)
        #expect(decoded.totalQuestions == 10)
        #expect(decoded.answerTimes == nil)
    }

    @Test("Encodes and decodes without answerTimes")
    func roundTripWithoutTiming() throws {
        let result = QuizResult(topic: .foodAndCalories, score: 5, totalQuestions: 8)

        let data = try JSONEncoder().encode(result)
        let decoded = try JSONDecoder().decode(QuizResult.self, from: data)

        #expect(decoded.score == 5)
        #expect(decoded.answerTimes == nil)
    }
}
