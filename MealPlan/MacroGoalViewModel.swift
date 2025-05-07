import Foundation

// Manages the user's target macro goals and saves/loads them
class MacroGoalViewModel: ObservableObject {
    @Published var goal: MacroGoal  // Daily macro goal (protein, carbs, fats)

    private let goalKey = "macroGoals"

    init() {
        self.goal = Self.loadGoal()  // Load from UserDefaults or use default
    }

    // Update the macro goal and save it
    func updateGoal(protein: Double, carbs: Double, fats: Double) {
        goal = MacroGoal(proteinGoal: protein, carbGoal: carbs, fatGoal: fats)
        saveGoal()
    }

    // Save the current goal to UserDefaults
    private func saveGoal() {
        do {
            let data = try JSONEncoder().encode(goal)
            UserDefaults.standard.set(data, forKey: goalKey)
        } catch {
            print("❌ Failed to save macro goals: \(error)")
        }
    }

    // Load goal from UserDefaults or return empty default goal
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
