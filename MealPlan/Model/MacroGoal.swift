import Foundation

// Represents the user's daily macronutrient intake goals
struct MacroGoal: Codable {
    var proteinGoal: Double     // e.g., 150 grams
    var carbGoal: Double        // e.g., 250 grams
    var fatGoal: Double         // e.g., 60 grams

    var totalCalories: Double {
        (proteinGoal * 4) + (carbGoal * 4) + (fatGoal * 9)
    }
}
