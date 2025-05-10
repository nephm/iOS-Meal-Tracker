//
//  MealPlanApp.swift
//  MealPlan
//
//  Created by Nadiv Herath on 2025-05-03.
//

import SwiftUI

@main
struct MacroMateApp: App {
    @StateObject var mealVM = MealViewModel()
    @StateObject var goalVM = MacroGoalViewModel()

    var body: some Scene {
        WindowGroup {
            EntryView()
                .environmentObject(mealVM)
                .environmentObject(goalVM)
        }
    }
}
