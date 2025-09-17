import SwiftUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        NavigationView {
            if surveyViewModel.isNewUser {
                // New user flow: Show onboarding, survey, and face analysis
                if surveyViewModel.isOnboardingComplete {
                    MainTabContainerView(surveyViewModel: surveyViewModel)
                } else if surveyViewModel.showFaceAnalysis {
                    FaceAnalysisView(surveyViewModel: surveyViewModel)
                } else {
                    SurveyView(viewModel: surveyViewModel)
                }
            } else {
                // Existing user flow: Go directly to main app
                MainTabContainerView(surveyViewModel: surveyViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            print("🔴 ContentView appeared - isNewUser: \(surveyViewModel.isNewUser), showFaceAnalysis: \(surveyViewModel.showFaceAnalysis), isOnboardingComplete: \(surveyViewModel.isOnboardingComplete)")
        }
        .onChange(of: surveyViewModel.showFaceAnalysis) { newValue in
            print("🔴 showFaceAnalysis changed to: \(newValue)")
        }
        .onChange(of: surveyViewModel.isOnboardingComplete) { newValue in
            print("🔴 isOnboardingComplete changed to: \(newValue)")
        }
    }
}

#Preview {
    ContentView()
}
