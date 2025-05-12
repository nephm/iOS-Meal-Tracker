import Foundation
import SwiftUI

// Struct to show breakdown of macro values for a given meal 
struct MacroBreakdown {
    var protein: Double
    var carbs: Double
    var fats: Double
    var calories: Double
}

// This view model manages all meals for the user, organized by date.
// It includes functions for adding, deleting, and computing totals.
// It also supports switching between days and calculating remaining macros.

class MealViewModel: ObservableObject {
    // Store meals grouped by date (formatted "yyyy-MM-dd")
    @Published var mealsByDate: [String: [Meal]] = [:]

    // Currently selected day
    @Published var selectedDate: String = MealViewModel.getTodayDate()

    // UserDefaults key to save all meal data
    private let mealsKey = "savedMealsByDate"

    // Load previously saved meals when the app starts
    init() {
        loadMeals()
    }

    // Add a new meal to the current selected date
    func addMeal(name: String, category: MealCategory, ingredients: [Ingredient]) {
        let newMeal = Meal(name: name, category: category, ingredients: ingredients)
        if mealsByDate[selectedDate] != nil {
            mealsByDate[selectedDate]?.append(newMeal)
        } else {
            mealsByDate[selectedDate] = [newMeal]
        }
        saveMeals()
    }

    // Delete a meal from the selected date
    func deleteMeal(at offsets: IndexSet) {
        mealsByDate[selectedDate]?.remove(atOffsets: offsets)
        saveMeals()
    }

    // Get meals only for the current selected date
    var meals: [Meal] {
        mealsByDate[selectedDate] ?? []
    }

    // Filter meals by category
    func meals(for category: MealCategory) -> [Meal] {
        meals.filter { $0.category == category }
    }

    // Sum of total protein for the day
    var totalProtein: Double {
        meals.reduce(0) { $0 + $1.totalProtein }
    }

    // Sum of total carbs for the day
    var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.totalCarbs }
    }

    // Sum of total fats for the day
    var totalFats: Double {
        meals.reduce(0) { $0 + $1.totalFats }
    }

    // Sum of total calories for the day
    var totalCalories: Double {
        meals.reduce(0) { $0 + $1.totalCalories }
    }

    // Calculate how many macros remain based on the current macro goal
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

    // Save meals by date to UserDefaults
    func saveMeals() {
        do {
            let data = try JSONEncoder().encode(mealsByDate)
            UserDefaults.standard.set(data, forKey: mealsKey)
        } catch {
            print("Failed to save meals: \(error)")
        }
    }

    // Load meals by date from UserDefaults
    func loadMeals() {
        guard let data = UserDefaults.standard.data(forKey: mealsKey) else { return }
        do {
            mealsByDate = try JSONDecoder().decode([String: [Meal]].self, from: data)
        } catch {
            print("Failed to load meals: \(error)")
        }
    }

    // Get today's date formatted as a string
    static func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    // Change the selected date to view or edit meals for a different day
    func setDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: date)
    }
    
    // Deletes meals by their unique IDs from the current selected date
    func deleteMeals(with ids: [UUID]) {
        mealsByDate[selectedDate]?.removeAll { ids.contains($0.id) }
        saveMeals()
    }

    // Convert a date string (yyyy-MM-dd) to a Date object
    static func convertToDate(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
}
