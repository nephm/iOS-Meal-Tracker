import SwiftUI

struct MainContentView: View {
    @StateObject var goalVM = MacroGoalViewModel()
    @StateObject var mealVM = MealViewModel()
    
    var body: some View {
        TabView {

            NavigationView {
                MacroSummaryView()
                    .environmentObject(mealVM)
                    .environmentObject(goalVM)
            }
            .tabItem {
                Label("Summary", systemImage: "chart.bar.doc.horizontal")
            }
            
            NavigationView {
                MealListView()
                    .environmentObject(mealVM)
            }
            .tabItem {
                Label("Meals", systemImage: "fork.knife")
            }

            NavigationView {
                MacroGoalView()
                    .environmentObject(goalVM)
            }
            .tabItem {
                Label("Goals", systemImage: "target")
            }
        }
    }
}
