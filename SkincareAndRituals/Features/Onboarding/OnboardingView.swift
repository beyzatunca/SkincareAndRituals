import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Section
                    VStack(spacing: AppTheme.Spacing.md) {
                        // App Icon/Logo
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Image(systemName: "sparkles")
                                .font(.system(size: geometry.size.height * 0.08, weight: .light))
                                .foregroundColor(AppTheme.primaryColor)
                                .padding(AppTheme.Spacing.md)
                                .background(
                                    Circle()
                                        .fill(AppTheme.primaryColor.opacity(0.1))
                                        .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                                )
                            
                            Text("Skincare & Rituals")
                                .font(.system(size: geometry.size.height * 0.035, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        .padding(.top, geometry.size.height * 0.05)
                        
                        // Welcome text
                        Text("Discover Your Perfect Skincare Routine")
                            .font(.system(size: geometry.size.height * 0.025, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                    }
                    
                    Spacer()
                    
                    // Features Section - Centered between title and button
                    VStack(spacing: AppTheme.Spacing.lg) {
                        FeatureRow(icon: "person.crop.circle", title: "Personalized Analysis", subtitle: "Tailored to your skin type and concerns", geometry: geometry)
                        FeatureRow(icon: "sparkles", title: "Expert Discovery", subtitle: "Curated by skincare professionals", geometry: geometry)
                        FeatureRow(icon: "heart", title: "Simple & Effective", subtitle: "Easy-to-follow routines that work", geometry: geometry)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    Spacer()
                    
                    // Bottom Section
                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton("Start Survey") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.startSurvey()
                            }
                        }
                        
                        Text("Takes only 2-3 minutes")
                            .font(.system(size: geometry.size.height * 0.015))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, geometry.size.height * 0.05)
                }
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let geometry: GeometryProxy
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Icon with circular background
            ZStack {
                Circle()
                    .fill(AppTheme.primaryColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .padding(.horizontal, AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    OnboardingView(viewModel: SurveyViewModel())
}
