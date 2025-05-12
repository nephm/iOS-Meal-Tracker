import SwiftUI

// This view contains the main tab navigation for the app.
// It includes three sections: Meals, Summary, and Goals.

struct MainContentView: View {
    var body: some View {
        TabView {
            // Meals tab for viewing and managing meals
            NavigationView {
                MealListView()
            }
            .tabItem {
                Label("Meals", systemImage: "fork.knife")
            }

            // Summary tab showing macro progress and training toggle
            NavigationView {
                MacroSummaryView()
            }
            .tabItem {
                Label("Summary", systemImage: "chart.bar")
            }

            // Goals tab to review or edit macro goals
            NavigationView {
                MacroGoalView()
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
        }
    }
}
