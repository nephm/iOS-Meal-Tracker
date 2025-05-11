import SwiftUI

struct MealListView: View {
    @EnvironmentObject var mealVM: MealViewModel

    var body: some View {
        VStack(spacing: 12) {
            // MARK: - Date Picker
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
                .labelsHidden() // ✅ hides "Select Date"
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

            // MARK: - Meal List
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
                            .onDelete { indexSet in
                                mealVM.deleteMeal(at: indexSet)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Your Meals")
        .toolbar {
            NavigationLink(destination: AddMealView()) {
                Image(systemName: "plus.circle")
            }
        }
    }
}
