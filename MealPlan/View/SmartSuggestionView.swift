import SwiftUI

// This view shows the top suggested ingredients to help the user meet their remaining macro goals.
// The user can select suggestions and choose which meal type to add them to.

struct SmartSuggestionView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var goalVM: MacroGoalViewModel

    @State private var suggestions: [IngredientSuggestion] = []
    @State private var selectedSuggestion: IngredientSuggestion?
    @State private var showMealPicker = false

    var body: some View {
        let remaining = mealVM.remainingMacros(goal: goalVM.goal)
        let topMatches = bestSuggestions(for: remaining)

        ScrollView {
            VStack(spacing: 20) {
                // Remaining macros summary card
                VStack(alignment: .leading, spacing: 10) {
                    Text("📌 Remaining Macros").font(.headline)

                    HStack(spacing: 30) {
                        macroItem("🍗 Protein", remaining.protein)
                        macroItem("🍞 Carbs", remaining.carbs)
                        macroItem("🥑 Fats", remaining.fats)
                    }
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                // Suggested ingredients list
                if topMatches.isEmpty {
                    Text("No suggestions found.")
                        .foregroundColor(.red)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(topMatches.prefix(3)) { item in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.name)
                                    .font(.headline)

                                HStack {
                                    Text("🍗 \(Int(item.protein))g")
                                    Text("🍞 \(Int(item.carbs))g")
                                    Text("🥑 \(Int(item.fats))g")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                                Button("➕ Add to Meals") {
                                    selectedSuggestion = item
                                    showMealPicker = true
                                }
                                .font(.footnote)
                                .frame(maxWidth: .infinity)
                                .padding(6)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Smart Suggestions")
        .onAppear {
            suggestions = loadIngredientSuggestions()
        }
        .confirmationDialog("Add to which meal?", isPresented: $showMealPicker, titleVisibility: .visible) {
            ForEach(MealCategory.allCases) { category in
                Button(category.displayName) {
                    if let suggestion = selectedSuggestion {
                        let ingredient = Ingredient(
                            name: suggestion.name,
                            quantity: "1 serving",
                            protein: suggestion.protein,
                            carbs: suggestion.carbs,
                            fats: suggestion.fats
                        )
                        let mealName = suggestion.name
                        mealVM.addMeal(name: mealName, category: category, ingredients: [ingredient])
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // Displays an individual macro item as label + value
    private func macroItem(_ label: String, _ value: Double) -> some View {
        VStack(alignment: .leading) {
            Text(label)
            Text("\(Int(value))g").bold()
        }
    }

    // Load the JSON file of ingredient suggestions
    private func loadIngredientSuggestions() -> [IngredientSuggestion] {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
            print("ingredients.json not found")
            return []
        }
        // Error handling to load the JSON file
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([IngredientSuggestion].self, from: data)
        } catch {
            print("Failed to decode suggestions: \(error)")
            return []
        }
    }

    // Calculates best matching suggestions based on remaining macros
    private func bestSuggestions(for target: MacroBreakdown) -> [IngredientSuggestion] {
        let scored = suggestions.map { item in
            let score = abs(target.protein - item.protein) +
                        abs(target.carbs - item.carbs) +
                        abs(target.fats - item.fats)
            return (item, score)
        }

        return scored.sorted { $0.1 < $1.1 }.map { $0.0 }
    }
}
