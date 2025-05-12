import Foundation

struct Meal: Identifiable, Codable {
    
    //Attributes
    var id = UUID()
    var name: String
    var category: MealCategory
    var ingredients: [Ingredient]

    // Calculate protein from all ingredients in the meal
        var totalProtein: Double {
            ingredients.reduce(0) { $0 + $1.protein }
        }

    // Calculate carbs from all ingredients in the meal
        var totalCarbs: Double {
            ingredients.reduce(0) { $0 + $1.carbs }
        }

    // Calculate fats from all ingredients in the meal
        var totalFats: Double {
            ingredients.reduce(0) { $0 + $1.fats }
        }

    // Calculate Total energy content (kcal) for each meal
        var totalCalories: Double {
            totalProtein * 4 + totalCarbs * 4 + totalFats * 9
        }
    
}
