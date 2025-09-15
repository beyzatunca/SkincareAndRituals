import SwiftUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        NavigationView {
            if surveyViewModel.isNewUser {
                // New user flow: Show onboarding and survey
                if surveyViewModel.isOnboardingComplete {
                    SurveyView(viewModel: surveyViewModel)
                } else {
                    OnboardingView(viewModel: surveyViewModel)
                }
            } else {
                // Existing user flow: Go directly to main app
                MainTabContainerView(surveyViewModel: surveyViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
