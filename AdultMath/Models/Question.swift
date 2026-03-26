import Foundation

struct Question: Identifiable, Codable {
    let id: String
    let topic: Topic
    let questionText: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: [String]
    let scenarioData: ScenarioData
}
