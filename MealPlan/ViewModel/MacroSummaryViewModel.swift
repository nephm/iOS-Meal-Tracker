import Foundation

// Compares user's total macros consumed vs their daily macro goals
class MacroSummaryViewModel: ObservableObject {
    let mealVM: MealViewModel
    let goalVM: MacroGoalViewModel

    // Initialize with access to Meal and Goal view models
    init(mealVM: MealViewModel, goalVM: MacroGoalViewModel) {
        self.mealVM = mealVM
        self.goalVM = goalVM
    }

    // Macros remaining before user hits their goal
    var proteinRemaining: Double {
        goalVM.goal.proteinGoal - mealVM.totalProtein
    }

    var carbsRemaining: Double {
        goalVM.goal.carbGoal - mealVM.totalCarbs
    }

    var fatsRemaining: Double {
        goalVM.goal.fatGoal - mealVM.totalFats
    }

    var caloriesRemaining: Double {
        goalVM.goal.totalCalories - mealVM.totalCalories
    }
}
