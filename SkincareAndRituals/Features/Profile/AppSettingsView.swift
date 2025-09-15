import SwiftUI

// MARK: - App Settings View
struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentLanguage = "English"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Language Setting Card
                languageSettingCard
                
                Spacer()
            }
            .background(Color(hex: "F8F8F8"))
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Spacer()
            
            Text("App Settings")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "111111"))
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
    
    // MARK: - Language Setting Card
    private var languageSettingCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Language")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(currentLanguage)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
            
            Text("To change the language, you will be redirected to Lóvi page on System Settings of your device")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "6B7280"))
                .lineLimit(nil)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 20)
        .onTapGesture {
            openSystemSettings()
        }
    }
    
    // MARK: - Actions
    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Preview
struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView()
    }
}
