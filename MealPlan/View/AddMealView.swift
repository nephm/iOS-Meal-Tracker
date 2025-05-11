import SwiftUI

struct AddMealView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealVM: MealViewModel

    // Meal details
    @State private var mealName: String = ""
    @State private var selectedCategory: MealCategory = .lunch

    // Ingredient form input
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    @State private var newProtein: String = ""
    @State private var newCarbs: String = ""
    @State private var newFats: String = ""

    // Added ingredients
    @State private var ingredients: [Ingredient] = []

    // Suggestions from JSON
    @State private var allSuggestions: [IngredientSuggestion] = []
    @State private var showSuggestions = false
    @State private var suggestionsLoaded = false

    // Error alert
    @State private var showAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                mealDetailsSection()
                Divider()
                ingredientFormSection()
                Divider()
                ingredientListSection()
                saveButton
            }
            .padding()
        }
        .navigationTitle("Add Meal")
        .onAppear {
            if !suggestionsLoaded {
                allSuggestions = loadIngredientSuggestions()
                suggestionsLoaded = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Missing Info"),
                  message: Text("Please enter a meal name and at least one ingredient."),
                  dismissButton: .default(Text("OK")))
        }
    }

    // MARK: - View Sections

    @ViewBuilder
    private func mealDetailsSection() -> some View {
        VStack(spacing: 20) {
            TextField("Meal Name (e.g. Chicken Wrap)", text: $mealName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Meal Type", selection: $selectedCategory) {
                ForEach(MealCategory.allCases) { category in
                    Text(category.displayName).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    @ViewBuilder
    private func ingredientFormSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Add Ingredient")
                .font(.headline)

            TextField("Name", text: $newIngredientName)
                .onChange(of: newIngredientName) { _, newValue in
                    showSuggestions = !newValue.isEmpty
                }


            if showSuggestions && !newIngredientName.isEmpty {
                let filtered = allSuggestions.filter {
                    $0.name.lowercased().contains(newIngredientName.lowercased())
                }
                ForEach(filtered.prefix(5)) { suggestion in
                    Button(action: {
                        newIngredientName = suggestion.name
                        newProtein = String(suggestion.protein)
                        newCarbs = String(suggestion.carbs)
                        newFats = String(suggestion.fats)
                        showSuggestions = false
                    }) {
                        Text(suggestion.name).foregroundColor(.blue)
                    }
                }
            }

            TextField("Quantity (e.g. 100g)", text: $newIngredientQuantity)
            TextField("Protein (g)", text: $newProtein).keyboardType(.decimalPad)
            TextField("Carbs (g)", text: $newCarbs).keyboardType(.decimalPad)
            TextField("Fats (g)", text: $newFats).keyboardType(.decimalPad)

            Button(action: addIngredient) {
                Label("Add Ingredient", systemImage: "plus.circle.fill")
            }
            .disabled(newIngredientName.isEmpty || newProtein.isEmpty || newCarbs.isEmpty || newFats.isEmpty)
        }
    }

    @ViewBuilder
    private func ingredientListSection() -> some View {
        if !ingredients.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Ingredients Added")
                    .font(.headline)

                ForEach(ingredients, id: \.id) { ingredient in
                    VStack(alignment: .leading) {
                        Text(ingredient.name)
                            .font(.subheadline)

                        // ✅ Split long text into multiple pieces
                        HStack(spacing: 6) {
                            Text(ingredient.quantity)
                            Text("•")
                            Text("P: \(ingredient.protein, specifier: "%.1f")g")
                            Text("C: \(ingredient.carbs, specifier: "%.1f")g")
                            Text("F: \(ingredient.fats, specifier: "%.1f")g")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteIngredient)
            }
        }
    }


    private var saveButton: some View {
        Button("Save Meal") {
            if mealName.isEmpty || ingredients.isEmpty {
                showAlert = true
            } else {
                mealVM.addMeal(name: mealName, category: selectedCategory, ingredients: ingredients)
                presentationMode.wrappedValue.dismiss()
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    // MARK: - Logic

    private func addIngredient() {
        guard let protein = Double(newProtein),
              let carbs = Double(newCarbs),
              let fats = Double(newFats) else { return }

        let ingredient = Ingredient(
            name: newIngredientName,
            quantity: newIngredientQuantity,
            protein: protein,
            carbs: carbs,
            fats: fats
        )

        ingredients.append(ingredient)

        newIngredientName = ""
        newIngredientQuantity = ""
        newProtein = ""
        newCarbs = ""
        newFats = ""
    }

    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }

    private func loadIngredientSuggestions() -> [IngredientSuggestion] {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
            print("ingredients.json not found")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([IngredientSuggestion].self, from: data)
        } catch {
            print("Failed to decode suggestions: \(error)")
            return []
        }
    }
}

