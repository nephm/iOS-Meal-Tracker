import Foundation

// Struct to represent a single food item with macronutrient values
struct Ingredient: Identifiable, Codable, Hashable {
    //Attributes
    var id = UUID()
    var name: String
    var quantity: String

    // Macronutrients attributes
    var protein: Double
    var carbs: Double
    var fats: Double

    init(id: UUID = UUID(), name: String, quantity: String, protein: Double, carbs: Double, fats: Double) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
    
}
