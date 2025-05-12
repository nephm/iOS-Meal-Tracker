import SwiftUI

struct IngredientSuggestion: Codable, Identifiable {
    // Attributes
    let id = UUID()
    let name: String
    let protein: Double
    let carbs: Double
    let fats: Double
}
