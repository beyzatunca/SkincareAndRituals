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
                    
                    // Features Section
                    VStack(spacing: AppTheme.Spacing.sm) {
                        FeatureRow(icon: "person.crop.circle", title: "Personalized Analysis", subtitle: "Tailored to your skin type and concerns", geometry: geometry)
                        FeatureRow(icon: "sparkles", title: "Expert Recommendations", subtitle: "Curated by skincare professionals", geometry: geometry)
                        FeatureRow(icon: "heart", title: "Simple & Effective", subtitle: "Easy-to-follow routines that work", geometry: geometry)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, geometry.size.height * 0.03)
                    
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
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: geometry.size.height * 0.025))
                .foregroundColor(AppTheme.primaryColor)
                .frame(width: geometry.size.height * 0.025)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: geometry.size.height * 0.018, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: geometry.size.height * 0.014))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.surfaceColor.opacity(0.5))
        )
    }
}

#Preview {
    OnboardingView(viewModel: SurveyViewModel())
}
