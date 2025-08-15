import SwiftUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        NavigationView {
            if surveyViewModel.isOnboardingComplete {
                SurveyView(viewModel: surveyViewModel)
            } else {
                OnboardingView(viewModel: surveyViewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
