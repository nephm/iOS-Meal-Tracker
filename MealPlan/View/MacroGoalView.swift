import SwiftUI

struct MacroGoalView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Daily Macro Goals")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            VStack(alignment: .leading, spacing: 12) {
                macroLine("🍗 Protein", value: goalVM.goal.proteinGoal, unit: "g")
                macroLine("🍞 Carbs", value: goalVM.goal.carbGoal, unit: "g")
                macroLine("🥑 Fats", value: goalVM.goal.fatGoal, unit: "g")
                macroLine("🔥 Calories", value: goalVM.goal.totalCalories, unit: "kcal")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            Spacer()

            NavigationLink(destination: EditGoalsView()) {
                Text("Edit Goals")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Macro Goals")
    }

    func macroLine(_ label: String, value: Double, unit: String) -> some View {
        HStack {
            Text(label).fontWeight(.semibold)
            Spacer()
            Text("\(Int(value)) \(unit)")
        }
        .font(.title3)
    }
}


