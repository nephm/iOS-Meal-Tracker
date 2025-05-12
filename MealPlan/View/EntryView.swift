import SwiftUI

// This is the app's entry screen.
// It checks whether the user has set up their macro goals.
// If not, it shows a setup prompt. If goals exist, it shows a welcome back screen.

struct EntryView: View {
    @EnvironmentObject var goalVM: MacroGoalViewModel
    @EnvironmentObject var mealVM: MealViewModel

    // Controls full screen and sheet navigation
    @State var showSetupSheet: Bool = false
    @State private var navigateToMain: Bool = false
    @State private var navigateToEditMacro: Bool = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if needSetUp {
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

                // Button to open setup sheet
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
                Text("Welcome Back to MacroMates!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Spacer()

                // Button to continue into the main app
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

        // Opens the main app view in full screen
        .fullScreenCover(isPresented: $navigateToMain) {
            MainContentView()
                .environmentObject(goalVM)
                .environmentObject(mealVM)
        }

        // Opens the macro setup sheet and returns to main if setup is completed
        .sheet(isPresented: $navigateToEditMacro, onDismiss: {
            // If macros are now set, navigate to main
            if !needSetUp {
                navigateToMain = true
            }
        }) {
            EditGoalsView()
                .environmentObject(goalVM)
        }
    }

    // Determines if the user needs to set up macros (all values are zero)
    private var needSetUp: Bool {
        if goalVM.goal.carbGoal == 0 && goalVM.goal.fatGoal == 0 && goalVM.goal.proteinGoal == 0 {
            return true
        }
        return false
    }
}
