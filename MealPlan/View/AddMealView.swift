import SwiftUI

// This view allows users to add a new meal for the day.
// It includes fields for naming the meal, selecting its category, and listing ingredients.
// The user can either manually enter ingredient data or use auto-suggestions loaded from a local JSON file.

struct AddMealView: View {
    // Access to the environment and shared view model to store the meal
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealVM: MealViewModel
    
    // User inputs for naming the meal and selecting its category
    @State private var mealName: String = ""
    @State private var selectedCategory: MealCategory = .lunch
    
    // Fields for entering new ingredient information
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    @State private var newProtein: String = ""
    @State private var newCarbs: String = ""
    @State private var newFats: String = ""
    
    // Local state for storing added ingredients and JSON-based suggestions
    @State private var ingredients: [Ingredient] = []
    @State private var allSuggestions: [IngredientSuggestion] = []
    @State private var showSuggestions = false
    @State private var suggestionsLoaded = false
    
    // Alert the user if they try to save without filling required fields
    @State private var showAlert = false
    
    var body: some View {
        // Scrollable layout containing all input fields, ingredient list, and save button
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
            // Load suggestions once when the view appears
            if !suggestionsLoaded {
                allSuggestions = loadIngredientSuggestions()
                suggestionsLoaded = true
            }
        }
        // Error handling for no input
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Missing Info"),
                message: Text("Please enter a meal name and at least one ingredient."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Section for entering meal name and selecting its category
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
    
    // Section for entering ingredient info and selecting from suggestions
    @ViewBuilder
    private func ingredientFormSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Add Ingredient")
                .font(.headline)
            
            TextField("Name", text: $newIngredientName)
                .onChange(of: newIngredientName) { _, newValue in
                    showSuggestions = !newValue.isEmpty
                }
            
            // Display top 5 matching suggestions when user types
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
                        Text(suggestion.name)
                            .foregroundColor(.blue)
                    }
                }
            }
            // Text fields to show quantity and macros
            TextField("Quantity (e.g. 100g)", text: $newIngredientQuantity)
            TextField("Protein (g)", text: $newProtein).keyboardType(.decimalPad)
            TextField("Carbs (g)", text: $newCarbs).keyboardType(.decimalPad)
            TextField("Fats (g)", text: $newFats).keyboardType(.decimalPad)
            
            // Button to add ingredients
            Button(action: addIngredient) {
                Label("Add Ingredient", systemImage: "plus.circle.fill")
            }
            .disabled(newIngredientName.isEmpty || newProtein.isEmpty || newCarbs.isEmpty || newFats.isEmpty)
        }
    }
    
    // Section that displays a list of all ingredients added for this meal
    @ViewBuilder
    private func ingredientListSection() -> some View {
        if !ingredients.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Ingredients Added")
                    .font(.headline)
                
                ForEach(ingredients, id: \.id) { ingredient in
                    VStack(alignment: .leading) {
                        Text(ingredient.name).font(.subheadline)
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
    
    // Save button to finalize the meal and add it to the view model
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
    
    // Helper function to add a new ingredient to the list using input values
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
        
        // Clear fields after adding
        newIngredientName = ""
        newIngredientQuantity = ""
        newProtein = ""
        newCarbs = ""
        newFats = ""
    }
    
    // Function to delete selected ingredient(s) from the list
    private func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    // Function to load suggestions from the JSON file
    private func loadIngredientSuggestions() -> [IngredientSuggestion] {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
            print("ingredients.json not found")
            return []
        }
        
        //Error handling for loading data from the JSON file
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([IngredientSuggestion].self, from: data)
        } catch {
            print("Failed to decode suggestions: \(error)")
            return []
        }
    }
}
