import Foundation

import Foundation

// This view model compares the user's actual intake with their macro goals.

class MacroSummaryViewModel: ObservableObject {
    let mealVM: MealViewModel
    let goalVM: MacroGoalViewModel

    // Initialize with shared view models for meal tracking and goals
    init(mealVM: MealViewModel, goalVM: MacroGoalViewModel) {
        self.mealVM = mealVM
        self.goalVM = goalVM
    }

    // Calculate how much protein remains for the day
    var proteinRemaining: Double {
        goalVM.goal.proteinGoal - mealVM.totalProtein
    }

    // Calculate how many carbs remain for the day
    var carbsRemaining: Double {
        goalVM.goal.carbGoal - mealVM.totalCarbs
    }

    // Calculate how much fat remains for the day
    var fatsRemaining: Double {
        goalVM.goal.fatGoal - mealVM.totalFats
    }

    // Calculate how many calories remain for the day
    var caloriesRemaining: Double {
        goalVM.goal.totalCalories - mealVM.totalCalories
    }
}
