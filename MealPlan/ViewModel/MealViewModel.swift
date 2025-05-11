import Foundation
import SwiftUI

// MARK: - Macro Breakdown Struct
struct MacroBreakdown {
    var protein: Double
    var carbs: Double
    var fats: Double
    var calories: Double
}

// MARK: - Meal View Model
class MealViewModel: ObservableObject {
    @Published var mealsByDate: [String: [Meal]] = [:]   // All meals grouped by date (yyyy-MM-dd)
    @Published var selectedDate: String = MealViewModel.getTodayDate()  // The current date being viewed

    private let mealsKey = "savedMealsByDate"

    init() {
        loadMeals()
    }

    // MARK: - Add Meal for Selected Date
    func addMeal(name: String, category: MealCategory, ingredients: [Ingredient]) {
        let newMeal = Meal(name: name, category: category, ingredients: ingredients)
        if mealsByDate[selectedDate] != nil {
            mealsByDate[selectedDate]?.append(newMeal)
        } else {
            mealsByDate[selectedDate] = [newMeal]
        }
        saveMeals()
    }

    // MARK: - Delete Meal from Selected Date
    func deleteMeal(at offsets: IndexSet) {
        mealsByDate[selectedDate]?.remove(atOffsets: offsets)
        saveMeals()
    }

    // MARK: - Meals and Totals for Selected Date
    var meals: [Meal] {
        mealsByDate[selectedDate] ?? []
    }

    func meals(for category: MealCategory) -> [Meal] {
        meals.filter { $0.category == category }
    }

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

    // MARK: - Remaining Macros Compared to Goal
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

    // MARK: - Save/Load with UserDefaults
    func saveMeals() {
        do {
            let data = try JSONEncoder().encode(mealsByDate)
            UserDefaults.standard.set(data, forKey: mealsKey)
        } catch {
            print("Failed to save meals: \(error)")
        }
    }

    func loadMeals() {
        guard let data = UserDefaults.standard.data(forKey: mealsKey) else { return }
        do {
            mealsByDate = try JSONDecoder().decode([String: [Meal]].self, from: data)
        } catch {
            print("Failed to load meals: \(error)")
        }
    }

    // MARK: - Date Helpers
    static func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: date)
    }
    
    static func convertToDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }

}
