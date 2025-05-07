import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                MealListView()
            }
            .tabItem {
                Label("Meals", systemImage: "fork.knife")
            }

            NavigationView {
                MacroSummaryView()
            }
            .tabItem {
                Label("Summary", systemImage: "chart.bar.doc.horizontal")
            }

            NavigationView {
                MacroGoalView()
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
        }
    }
}
