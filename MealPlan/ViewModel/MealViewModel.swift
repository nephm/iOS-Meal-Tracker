import Foundation
import SwiftUI

// MARK: - Macro Breakdown Struct for Suggestions
struct MacroBreakdown {
    var protein: Double
    var carbs: Double
    var fats: Double
    var calories: Double
}

// MARK: - Meal View Model
class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []

    private let mealsKey = "savedMeals"

    init() {
        loadMeals()
    }

    // MARK: - Add Meal with Name Support
    func addMeal(name: String, category: MealCategory, ingredients: [Ingredient]) {
        let newMeal = Meal(name: name, category: category, ingredients: ingredients)
        meals.append(newMeal)
        saveMeals()
    }

    func deleteMeal(at offsets: IndexSet) {
        meals.remove(atOffsets: offsets)
        saveMeals()
    }

    // MARK: - Save/Load from UserDefaults
    func saveMeals() {
        do {
            let data = try JSONEncoder().encode(meals)
            UserDefaults.standard.set(data, forKey: mealsKey)
        } catch {
            print("Failed to save meals: \(error)")
        }
    }

    func loadMeals() {
        guard let data = UserDefaults.standard.data(forKey: mealsKey) else { return }
        do {
            meals = try JSONDecoder().decode([Meal].self, from: data)
        } catch {
            print("Failed to load meals: \(error)")
        }
    }

    // MARK: - Total Macros for the Day
    var totalProtein: Double {
        meals.reduce(0) { $0 + $1.totalProtein }
    }

    var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.totalCarbs }
    }

    var totalFats: Double {
        meals.reduce(0) { $0 + $1.totalFats }
    }

    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }

    // MARK: - Total Macros by Category
    func totalCalories(for category: MealCategory) -> Double {
        meals
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.totalCalories }
    }

    func meals(for category: MealCategory) -> [Meal] {
        meals.filter { $0.category == category }
    }

    // MARK: - Remaining Macros for Smart Suggestions
    func remainingMacros(goal: MacroGoal) -> MacroBreakdown {
        let remainingProtein = max(goal.proteinGoal - totalProtein, 0)
        let remainingCarbs = max(goal.carbGoal - totalCarbs, 0)
        let remainingFats = max(goal.fatGoal - totalFats, 0)
        let remainingCalories = max(goal.totalCalories - totalCalories, 0)

        return MacroBreakdown(
            protein: remainingProtein,
            carbs: remainingCarbs,
            fats: remainingFats,
            calories: remainingCalories
        )
    }
}
