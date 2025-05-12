import SwiftUI

// This view allows users to manually set or update their macro goals 
// It calculates the estimated calorie goal based on those macros and lets users save their targets.
// On save, the view updates the goal in MacroGoalViewModel and dismisses itself.

struct EditGoalsView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel
    @Environment(\.presentationMode) var presentationMode

    // User input fields for each macronutrient
    @State private var proteinInput: String = ""
    @State private var carbsInput: String = ""
    @State private var fatsInput: String = ""

    var body: some View {
        Form {
            // Section for entering target macros
            Section(header: Text("Set Your Macro Goals")) {
                TextField("Protein (g)", text: $proteinInput)
                    .keyboardType(.decimalPad)

                TextField("Carbs (g)", text: $carbsInput)
                    .keyboardType(.decimalPad)

                TextField("Fats (g)", text: $fatsInput)
                    .keyboardType(.decimalPad)
            }

            // Section to display auto-calculated total daily calories
            Section(header: Text("Estimated Daily Calories")) {
                Text("\(totalCalories, specifier: "%.0f") kcal")
                    .font(.headline)
                    .foregroundColor(.orange)
            }

            // Save button section
            Section {
                Button("Save Goals") {
                    saveGoals()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Goals")
        .onAppear {
            // Populate input fields with existing goal values on load
            proteinInput = String(format: "%.0f", goalVM.goal.proteinGoal)
            carbsInput = String(format: "%.0f", goalVM.goal.carbGoal)
            fatsInput = String(format: "%.0f", goalVM.goal.fatGoal)
        }
    }

    // Calculate calories using standard macro-to-calorie ratios
    private var totalCalories: Double {
        let p = Double(proteinInput) ?? 0
        let c = Double(carbsInput) ?? 0
        let f = Double(fatsInput) ?? 0
        return (p * 4) + (c * 4) + (f * 9)
    }

    // Save macro goals to the view model and dismiss the view
    private func saveGoals() {
        guard let protein = Double(proteinInput),
              let carbs = Double(carbsInput),
              let fats = Double(fatsInput) else { return }

        goalVM.updateGoal(protein: protein, carbs: carbs, fats: fats)
        presentationMode.wrappedValue.dismiss()
    }
}
