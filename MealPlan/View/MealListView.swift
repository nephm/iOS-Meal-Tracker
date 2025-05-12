import SwiftUI

// This view displays the user's meals for the selected date.
// Users can select the date using a date picker and see meals grouped by category.
// Each meal displays its name and macro breakdown. Users can delete meals via swipe.

struct MealListView: View {
    @EnvironmentObject var mealVM: MealViewModel

    var body: some View {
        VStack(spacing: 12) {
            // Allows the user to select which day to view meals from.
            // Updates mealVM.selectedDate whenever the user picks a new date.
            HStack {
                Spacer()

                DatePicker(
                    "",
                    selection: Binding(
                        get: { MealViewModel.convertToDate(from: mealVM.selectedDate) },
                        set: { mealVM.setDate($0) }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden() 
                .datePickerStyle(.compact)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .accentColor(.blue)

                Spacer()
            }
            // Displays meals grouped by category (e.g., Breakfast, Lunch).
            // Each section shows the meal's name and macro breakdown.
            List {
                ForEach(MealCategory.allCases) { category in
                    let mealsForCategory = mealVM.meals(for: category)
                    if !mealsForCategory.isEmpty {
                        Section(header: Text(category.displayName).font(.headline)) {
                            ForEach(mealsForCategory) { meal in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(meal.name).font(.headline)

                                    HStack(spacing: 8) {
                                        Text(meal.category.displayName)
                                        Text("•")
                                        Text("P: \(Int(meal.totalProtein))g")
                                        Text("C: \(Int(meal.totalCarbs))g")
                                        Text("F: \(Int(meal.totalFats))g")
                                        Text("•")
                                        Text("\(Int(meal.totalCalories)) kcal")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            // Enables swipe-to-delete for meals in this category
                            .onDelete { indexSet in
                                mealVM.deleteMeal(at: indexSet)
                            }
                        }
                    }
                }
            }
        }
        // Sets the navigation bar title
        .navigationTitle("Your Meals")

        // Add button in the navigation bar to go to AddMealView
        .toolbar {
            NavigationLink(destination: AddMealView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}
