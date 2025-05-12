import SwiftUI

// This view shows the user's daily macro progress.
// It includes a training day toggle to adjust macro targets on gym days.

struct MacroSummaryView: View {
    @EnvironmentObject var mealVM: MealViewModel
    @EnvironmentObject var goalVM: MacroGoalViewModel

    var body: some View {
        VStack(spacing: 20) {
            
            // Toggle for training day, which increases macro targets
            Toggle("Training Day", isOn: $goalVM.isTrainingDay)
                .padding(.horizontal)

            // Informational label when training day is enabled
            if goalVM.isTrainingDay {
                Text("Macros adjusted for training 💪")
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            Spacer()

            // Circular ring showing total calorie intake vs adjusted goal
            HStack(spacing: 24) {
                RingView(
                    progress: mealVM.totalCalories / goalVM.adjustedCalories,
                    color: .orange,
                    label: "Calories",
                    value: "\(Int(mealVM.totalCalories)) / \(Int(goalVM.adjustedCalories)) kcal"
                )
            }

            // Vertical stack of macro progress bars
            VStack(alignment: .leading, spacing: 12) {
                macroLine("🍗 Protein", current: mealVM.totalProtein, goal: goalVM.adjustedProtein)
                macroLine("🍞 Carbs", current: mealVM.totalCarbs, goal: goalVM.adjustedCarbs)
                macroLine("🥑 Fats", current: mealVM.totalFats, goal: goalVM.adjustedFats)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Spacer()

            // Button to navigate to smart suggestions
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

    // Displays a single macro as a label, intake text, and progress bar
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

// A circular progress ring used to show calorie intake visually
struct RingView: View {
    var progress: Double
    var color: Color
    var label: String
    var value: String

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)

                // Foreground progress ring
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.6), value: progress)

                // Calorie label inside the ring
                Text(value)
                    .font(.caption)
                    .bold()
            }
            .frame(width: 150, height: 150)

            // Label below the ring
            Text(label)
                .font(.footnote)
        }
    }
}
