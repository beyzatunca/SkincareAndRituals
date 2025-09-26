import SwiftUI

struct RoutinePreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Routine Preferences")
                    .font(.largeTitle)
                    .padding()
                
                Text("This is a test view")
                    .font(.body)
                    .padding()
                
                Button("Close") {
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    RoutinePreferencesView()
}
