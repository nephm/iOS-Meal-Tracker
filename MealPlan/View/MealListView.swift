import SwiftUI

struct MealListView: View {
    @EnvironmentObject var mealVM: MealViewModel

    var body: some View {
        NavigationView {
            List {
                // Loop through all meal categories: Breakfast, Lunch, etc.
                ForEach(MealCategory.allCases) { category in
                    let mealsForCategory = mealVM.meals(for: category)

                    // Show section only if meals exist for that category
                    if !mealsForCategory.isEmpty {
                        Section(header: Text(category.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)) {

                            // Loop through meals in this category
                            ForEach(mealsForCategory) { meal in
                                VStack(alignment: .leading, spacing: 4) {
                                    // Meal Name (e.g. "Chicken Wrap")
                                    Text(meal.name)
                                        .font(.headline)

                                    // Category and macros shown in multiple Texts
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
                            // Enable swipe-to-delete
                            .onDelete { indexSet in
                                let idsToDelete = indexSet.map { mealsForCategory[$0].id }
                                mealVM.meals.removeAll { idsToDelete.contains($0.id) }
                                mealVM.saveMeals()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your Meals")

            // Toolbar with Add Meal (+) button
            .toolbar {
                NavigationLink(destination: AddMealView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
