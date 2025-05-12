import Foundation

// Struct to represent the user's daily macronutrient intake goals
struct MacroGoal: Codable {
    
    // MacroNutrient Attribites
    
    var proteinGoal: Double
    var carbGoal: Double
    var fatGoal: Double
    
    // Function to calculate the total calories
    
    var totalCalories: Double {
        (proteinGoal * 4) + (carbGoal * 4) + (fatGoal * 9)
    }
}
