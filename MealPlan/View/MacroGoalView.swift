import SwiftUI

// This view displays the user’s current macro goals and total daily calories.

struct MacroGoalView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Macro Goals")
                .font(.title2)
                .fontWeight(.bold)

            // Macro goal rows
            macroLine("🍗 Protein", value: goalVM.goal.proteinGoal, unit: "g")
            macroLine("🍞 Carbs", value: goalVM.goal.carbGoal, unit: "g")
            macroLine("🥑 Fats", value: goalVM.goal.fatGoal, unit: "g")

            // Total calories derived from macro values
            HStack {
                Text("🔥 Estimated Calories:")
                Spacer()
                Text("\(Int(goalVM.goal.totalCalories)) kcal")
                    .fontWeight(.semibold)
            }

            Spacer()

            // Button to edit macro goals
            NavigationLink(destination: EditGoalsView()) {
                Text("Edit Goals")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Macro Goals")
    }

    // Helper to display a macro row with value and unit
    func macroLine(_ label: String, value: Double, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(Int(value)) \(unit)")
                .fontWeight(.semibold)
        }
    }
}
