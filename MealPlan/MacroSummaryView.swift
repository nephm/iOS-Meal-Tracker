import SwiftUI

struct MacroSummaryView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var goalVM: MacroGoalViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Today's Summary")
                .font(.largeTitle)
                .bold()

            VStack(alignment: .leading, spacing: 12) {
                macroLine("🍗 Protein", current: mealVM.totalProtein, goal: goalVM.goal.proteinGoal)
                macroLine("🍞 Carbs", current: mealVM.totalCarbs, goal: goalVM.goal.carbGoal)
                macroLine("🥑 Fats", current: mealVM.totalFats, goal: goalVM.goal.fatGoal)
                macroLine("🔥 Calories", current: mealVM.totalCalories, goal: goalVM.goal.totalCalories)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()

            // 🔗 Navigation to Smart Suggestions
            NavigationLink(destination: SmartSuggestionView()) {
                Text("Get Meal Suggestions")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Macro Summary")
    }

    func macroLine(_ label: String, current: Double, goal: Double) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(label).fontWeight(.semibold)
                Spacer()
                Text("\(Int(current)) / \(Int(goal))")
            }
            ProgressView(value: current, total: goal)
                .accentColor(.blue)
        }
    }
}
