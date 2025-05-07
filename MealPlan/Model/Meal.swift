import Foundation

struct Meal: Identifiable, Codable {
    var id = UUID()
    var name: String                      // ✅ New property
    var category: MealCategory
    var ingredients: [Ingredient]

    var totalProtein: Double {
        ingredients.reduce(0) { $0 + $1.protein }
    }

    var totalCarbs: Double {
        ingredients.reduce(0) { $0 + $1.carbs }
    }

    var totalFats: Double {
        ingredients.reduce(0) { $0 + $1.fats }
    }

    var totalCalories: Double {
        totalProtein * 4 + totalCarbs * 4 + totalFats * 9
    }
}
