import SwiftUI

struct EntryView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel
    @EnvironmentObject var mealVM: MealViewModel
    @State var showSetupSheet: Bool = false
    @State private var navigateToMain: Bool = false
    @State private var navigateToEditMacro: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            if needSetUp {
                // First-time user view
                Text("Welcome to MacroMates!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Set up your macros to start tracking your nutrition goals")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button {
                    navigateToEditMacro = true
                } label: {
                    Text("Set Up Macros")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                // Returning user view
                Text("Welcome Back to MacroMates!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    navigateToMain = true
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
        .fullScreenCover(isPresented: $navigateToMain) {
            MainContentView()
                .environmentObject(goalVM)
                .environmentObject(mealVM)
        }
        .sheet(isPresented: $navigateToEditMacro, onDismiss: {
            // Check if macros were set up, and if they were, navigate to main
            if !needSetUp {
                navigateToMain = true
            }
        }) {
            EditGoalsView()
                .environmentObject(goalVM)
        }
    }
    
    private var needSetUp: Bool {
        if goalVM.goal.carbGoal == 0 && goalVM.goal.fatGoal == 0 && goalVM.goal.proteinGoal == 0 {
            return true
        }
        return false
    }
}

