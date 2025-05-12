import SwiftUI

struct IngredientSuggestion: Codable, Identifiable {
    // Attributes
    var id = UUID()
    let name: String
    let protein: Double
    let carbs: Double
    let fats: Double
}
