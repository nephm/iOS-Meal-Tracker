import SwiftUI

struct IngredientSuggestion: Codable, Identifiable {
    let id = UUID()
    let name: String
    let protein: Double
    let carbs: Double
    let fats: Double
}
