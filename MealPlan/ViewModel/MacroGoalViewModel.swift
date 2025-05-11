import Foundation
import SwiftUI

// Manages the user's target macro goals and saves/loads them
class MacroGoalViewModel: ObservableObject {
    @Published var goal: MacroGoal  // Daily macro goal (protein, carbs, fats)
    @Published var isTrainingDay: Bool = false  // ✅ Training day toggle

    private let goalKey = "macroGoals"

    init() {
        self.goal = Self.loadGoal()
    }

    // MARK: - Adjusted Macros (Training Day Support)

    var adjustedProtein: Double {
        isTrainingDay ? goal.proteinGoal + 20 : goal.proteinGoal
    }

    var adjustedCarbs: Double {
        isTrainingDay ? goal.carbGoal + 40 : goal.carbGoal
    }

    var adjustedFats: Double {
        isTrainingDay ? max(goal.fatGoal - 10, 0) : goal.fatGoal
    }

    var adjustedCalories: Double {
        (adjustedProtein * 4) + (adjustedCarbs * 4) + (adjustedFats * 9)
    }

    // MARK: - Update Goal

    func updateGoal(protein: Double, carbs: Double, fats: Double) {
        goal = MacroGoal(proteinGoal: protein, carbGoal: carbs, fatGoal: fats)
        saveGoal()
    }

    // MARK: - Save/Load

    private func saveGoal() {
        do {
            let data = try JSONEncoder().encode(goal)
            UserDefaults.standard.set(data, forKey: goalKey)
        } catch {
            print("❌ Failed to save macro goals: \(error)")
        }
    }

    private static func loadGoal() -> MacroGoal {
        guard let data = UserDefaults.standard.data(forKey: "macroGoals") else {
            return MacroGoal(proteinGoal: 0, carbGoal: 0, fatGoal: 0)
        }
        do {
            return try JSONDecoder().decode(MacroGoal.self, from: data)
        } catch {
            print("❌ Failed to load macro goals: \(error)")
            return MacroGoal(proteinGoal: 0, carbGoal: 0, fatGoal: 0)
        }
    }
}
