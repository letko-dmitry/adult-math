import Foundation
import NonEmpty
import RswiftResources

enum QuestionBank {

    // MARK: - Public API

    static func questions(for topic: Topic) -> NonEmptyArray<Question>? {
        switch topic {
        case .tipsAndChecks: tipsAndChecksQuestions
        case .foodAndCalories: foodAndCaloriesQuestions
        case .shoppingAndDiscounts: shoppingAndDiscountsQuestions
        case .travelTime, .homeBudget, .cookingPortions, .timeManagement, .fitnessGoals: nil
        }
    }

    static func mixedQuestions() -> NonEmptyArray<Question> {
        tipsAndChecksQuestions + foodAndCaloriesQuestions + shoppingAndDiscountsQuestions
    }

    // MARK: - Loaded Questions

    static let tipsAndChecksQuestions: NonEmptyArray<Question> = load(R.file.tips_and_checksJson)
    static let foodAndCaloriesQuestions: NonEmptyArray<Question> = load(R.file.food_and_caloriesJson)
    static let shoppingAndDiscountsQuestions: NonEmptyArray<Question> = load(R.file.shopping_and_discountsJson)

    // MARK: - JSON Loader

    private static func load(_ resource: FileResource) -> NonEmptyArray<Question> {
        guard let url = resource.url() else {
            fatalError("Missing resource URL for \(resource)")
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(NonEmptyArray<Question>.self, from: data)
        } catch {
            fatalError("Failed to decode questions from \(resource): \(error)")
        }
    }
}
