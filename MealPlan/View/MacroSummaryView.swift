import SwiftUI

struct MacroSummaryView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var goalVM: MacroGoalViewModel

    var body: some View {
        VStack(spacing: 20) {

            // ✅ Training Day Toggle
            Toggle("Training Day", isOn: $goalVM.isTrainingDay)
                .padding(.horizontal)

            if goalVM.isTrainingDay {
                Text("Macros adjusted for training 💪")
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            Spacer()

            // ✅ Adjusted calorie ring
            HStack(spacing: 24) {
                RingView(
                    progress: mealVM.totalCalories / goalVM.adjustedCalories,
                    color: .orange,
                    label: "Calories",
                    value: "\(Int(mealVM.totalCalories)) / \(Int(goalVM.adjustedCalories)) kcal"
                )
            }

            // ✅ Adjusted Macros Section
            VStack(alignment: .leading, spacing: 12) {
                macroLine("🍗 Protein", current: mealVM.totalProtein, goal: goalVM.adjustedProtein)
                macroLine("🍞 Carbs", current: mealVM.totalCarbs, goal: goalVM.adjustedCarbs)
                macroLine("🥑 Fats", current: mealVM.totalFats, goal: goalVM.adjustedFats)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()

            // Navigation to Smart Suggestions
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

    // MARK: - Macro Progress Line
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

// MARK: - Ring View
struct RingView: View {
    var progress: Double
    var color: Color
    var label: String
    var value: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: progress)

                Text(value)
                    .font(.caption)
                    .bold()
            }
            .frame(width: 150, height: 150)

            Text(label)
                .font(.footnote)
        }
    }
}
