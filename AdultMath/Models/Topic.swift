import Foundation

enum Topic: String, CaseIterable, Identifiable, Codable {
    case foodAndCalories
    case tipsAndChecks
    case travelTime
    case shoppingAndDiscounts
    case homeBudget
    case cookingPortions
    case timeManagement
    case fitnessGoals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .foodAndCalories: "Food & Calories"
        case .tipsAndChecks: "Tips & Checks"
        case .travelTime: "Travel Time"
        case .shoppingAndDiscounts: "Shopping & Discounts"
        case .homeBudget: "Home Budget"
        case .cookingPortions: "Cooking Portions"
        case .timeManagement: "Time Management"
        case .fitnessGoals: "Fitness Goals"
        }
    }

    var description: String {
        switch self {
        case .foodAndCalories:
            "Count calories, compare meals, and make smarter food choices"
        case .tipsAndChecks:
            "Calculate tips, split bills, and handle restaurant checks with confidence"
        case .travelTime:
            "Estimate travel times, distances, and fuel costs for your trips"
        case .shoppingAndDiscounts:
            "Find the best deals, calculate discounts, and compare unit prices"
        case .homeBudget:
            "Track spending, plan budgets, and manage household expenses"
        case .cookingPortions:
            "Scale recipes, convert measurements, and calculate portions"
        case .timeManagement:
            "Estimate task durations, plan schedules, and manage your time"
        case .fitnessGoals:
            "Calculate calories burned, track workout progress, and hit your targets"
        }
    }

    var iconName: String {
        switch self {
        case .foodAndCalories: "fork.knife"
        case .tipsAndChecks: "dollarsign.circle"
        case .travelTime: "car.fill"
        case .shoppingAndDiscounts: "cart.fill"
        case .homeBudget: "house.fill"
        case .cookingPortions: "frying.pan.fill"
        case .timeManagement: "clock.fill"
        case .fitnessGoals: "figure.run"
        }
    }

    var isLocked: Bool {
        switch self {
        case .foodAndCalories, .tipsAndChecks, .shoppingAndDiscounts:
            false
        default:
            true
        }
    }

    static let unlocked: [Topic] = allCases.filter { !$0.isLocked }
    static let locked: [Topic] = allCases.filter { $0.isLocked }
}
