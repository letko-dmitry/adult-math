import Foundation

struct NutritionData: Codable {
    let title: String
    let ingredients: [NutritionItem]
    let totalCalories: Int
    let calorieLimit: Int?
}

struct NutritionItem: Codable {
    let name: String
    let calories: Int
}
