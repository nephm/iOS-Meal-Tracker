import Foundation
import SwiftUI

// This view model manages the user's daily macro goals.
// It includes logic for a training day toggle, which adjusts targets for gym days.
// It also handles saving and loading goals from UserDefaults.

class MacroGoalViewModel: ObservableObject {
    // User’s base macro goals
    @Published var goal: MacroGoal

    // Training day toggle to dynamically adjust macros
    @Published var isTrainingDay: Bool = false

    // UserDefaults storage key
    private let goalKey = "macroGoals"

    // Load saved goals on initialization, or set to defaults if not found
    init() {
        self.goal = Self.loadGoal()
    }

    // Adjust macros for training days
    var adjustedProtein: Double {
        isTrainingDay ? goal.proteinGoal + 20 : goal.proteinGoal
    }

    var adjustedCarbs: Double {
        isTrainingDay ? goal.carbGoal + 40 : goal.carbGoal
    }

    var adjustedFats: Double {
        isTrainingDay ? max(goal.fatGoal - 10, 0) : goal.fatGoal
    }

    // Adjust calorie goal based on the updated macros
    var adjustedCalories: Double {
        (adjustedProtein * 4) + (adjustedCarbs * 4) + (adjustedFats * 9)
    }

    // Update the goal with new macro values and save them
    func updateGoal(protein: Double, carbs: Double, fats: Double) {
        goal = MacroGoal(proteinGoal: protein, carbGoal: carbs, fatGoal: fats)
        saveGoal()
    }

    // Save current goal to UserDefaults
    private func saveGoal() {
        do {
            let data = try JSONEncoder().encode(goal)
            UserDefaults.standard.set(data, forKey: goalKey)
        } catch {
            print("Failed to save macro goals: \(error)")
        }
    }

    // Load saved macro goal from UserDefaults or return default values
    private static func loadGoal() -> MacroGoal {
        guard let data = UserDefaults.standard.data(forKey: "macroGoals") else {
            return MacroGoal(proteinGoal: 0, carbGoal: 0, fatGoal: 0)
        }
        //Error handling for data retrieval from JSON file
        do {
            return try JSONDecoder().decode(MacroGoal.self, from: data)
        } catch {
            print("Failed to load macro goals: \(error)")
            return MacroGoal(proteinGoal: 0, carbGoal: 0, fatGoal: 0)
        }
    }
}
