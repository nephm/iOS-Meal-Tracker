//
//  SmartSuggestionView.swift
//  MealPlan
//
//  Created by Nadiv Herath on 2025-05-06.
//
import SwiftUI

struct SmartSuggestionView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var goalVM: MacroGoalViewModel

    @State private var suggestions: [IngredientSuggestion] = []
    @State private var selectedSuggestion: IngredientSuggestion?
    @State private var showMealPicker = false

    var body: some View {
        let remaining = mealVM.remainingMacros(goal: goalVM.goal)
        let topMatches = bestSuggestions(for: remaining)

        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("📌 Remaining Macros").font(.headline)

                HStack(spacing: 20) {
                    Text("🍗 Protein: \(Int(remaining.protein))g")
                    Text("🍞 Carbs: \(Int(remaining.carbs))g")
                    Text("🥑 Fats: \(Int(remaining.fats))g")
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // ✅ Expand full width
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Top Matches
            if topMatches.isEmpty {
                Text("No suggestions found.")
                    .foregroundColor(.red)
            } else {
                List {
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
                .listStyle(InsetGroupedListStyle())
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Smart Suggestions")
        .onAppear {
            suggestions = loadIngredientSuggestions()
        }
        // Picker Dialog for Meal Type
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
                        let mealName = "\(suggestion.name)"
                        mealVM.addMeal(name: mealName, category: category, ingredients: [ingredient])

                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // Load from ingredients.json
    private func loadIngredientSuggestions() -> [IngredientSuggestion] {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
            print("ingredients.json not found")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([IngredientSuggestion].self, from: data)
        } catch {
            print("Failed to load ingredient suggestions: \(error)")
            return []
        }
    }

    // Suggest top ingredients based on remaining macros
    private func bestSuggestions(for target: MacroBreakdown) -> [IngredientSuggestion] {
        let scored = suggestions.map { item in
            let score =
                abs(target.protein - item.protein) +
                abs(target.carbs - item.carbs) +
                abs(target.fats - item.fats)
            return (item, score)
        }

        return scored.sorted { $0.1 < $1.1 }.map { $0.0 }
    }
}
