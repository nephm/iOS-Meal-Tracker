import Foundation

// Represents a single food item with macronutrient values
struct Ingredient: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String              // Name of the ingredient, e.g., "Chicken Breast"
    var quantity: String          // Optional description, e.g., "100g" or "1 cup"

    // Macronutrients in grams (per entry)
    var protein: Double           // e.g., 31g protein
    var carbs: Double             // e.g., 0g carbs
    var fats: Double              // e.g., 3.6g fat

    init(id: UUID = UUID(), name: String, quantity: String, protein: Double, carbs: Double, fats: Double) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
}
