//
//  EditGoalsView.swift
//  MealPlan
//
//  Created by Nadiv Herath on 2025-05-04.
//
import SwiftUI

struct EditGoalsView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var proteinInput: String = ""
    @State private var carbsInput: String = ""
    @State private var fatsInput: String = ""

    var body: some View {
        Form {
            Section(header: Text("Set Your Macro Goals")) {
                TextField("Protein (g)", text: $proteinInput)
                    .keyboardType(.decimalPad)

                TextField("Carbs (g)", text: $carbsInput)
                    .keyboardType(.decimalPad)

                TextField("Fats (g)", text: $fatsInput)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Estimated Daily Calories")) {
                Text("\(totalCalories, specifier: "%.0f") kcal")
                    .font(.headline)
                    .foregroundColor(.orange)
            }

            Section {
                Button("Save Goals") {
                    saveGoals()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Edit Goals")
        .onAppear {
            proteinInput = String(format: "%.0f", goalVM.goal.proteinGoal)
            carbsInput = String(format: "%.0f", goalVM.goal.carbGoal)
            fatsInput = String(format: "%.0f", goalVM.goal.fatGoal)
        }
    }

    private var totalCalories: Double {
        let p = Double(proteinInput) ?? 0
        let c = Double(carbsInput) ?? 0
        let f = Double(fatsInput) ?? 0
        return (p * 4) + (c * 4) + (f * 9)
    }

    private func saveGoals() {
        guard let protein = Double(proteinInput),
              let carbs = Double(carbsInput),
              let fats = Double(fatsInput) else { return }

        goalVM.updateGoal(protein: protein, carbs: carbs, fats: fats)
        presentationMode.wrappedValue.dismiss()
    }
}
