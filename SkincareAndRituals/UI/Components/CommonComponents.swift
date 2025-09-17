import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    let isEnabled: Bool
    
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEnabled ? AppTheme.primaryGradient : LinearGradient(
                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .appCornerRadius(AppTheme.CornerRadius.medium)
        }
        .disabled(!isEnabled)
        .appShadow(AppTheme.Shadows.medium)
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.primaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppTheme.surfaceColor)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.primaryColor, lineWidth: 2)
                )
                .appCornerRadius(AppTheme.CornerRadius.medium)
        }
        .appShadow(AppTheme.Shadows.small)
    }
}

// MARK: - Progress Bar
struct ProgressBar: View {
    let progress: Double
    let geometry: GeometryProxy
    
    var body: some View {
        GeometryReader { progressGeometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: geometry.size.height * 0.008)
                    .appCornerRadius(geometry.size.height * 0.004)
                
                Rectangle()
                    .fill(AppTheme.primaryGradient)
                    .frame(width: progressGeometry.size.width * progress, height: geometry.size.height * 0.008)
                    .appCornerRadius(geometry.size.height * 0.004)
            }
        }
        .frame(height: geometry.size.height * 0.008)
    }
}

// MARK: - Selection Card
struct SelectionCard<Content: View>: View {
    let isSelected: Bool
    let content: Content
    let geometry: GeometryProxy
    
    init(isSelected: Bool, geometry: GeometryProxy, @ViewBuilder content: () -> Content) {
        self.isSelected = isSelected
        self.geometry = geometry
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(geometry.size.height * 0.015)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(isSelected ? AppTheme.primaryColor.opacity(0.1) : AppTheme.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(
                                isSelected ? AppTheme.primaryColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .appShadow(isSelected ? AppTheme.Shadows.medium : AppTheme.Shadows.small)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Icon Card
struct IconCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let geometry: GeometryProxy
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: icon)
                    .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.primaryColor : AppTheme.textSecondary)
                
                VStack(spacing: geometry.size.height * 0.005) {
                    Text(title)
                        .font(.system(size: geometry.size.height * 0.018, weight: .semibold))
                        .foregroundColor(isSelected ? AppTheme.primaryColor : AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.system(size: geometry.size.height * 0.014))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(geometry.size.height * 0.015)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(isSelected ? AppTheme.primaryColor.opacity(0.1) : AppTheme.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(
                                isSelected ? AppTheme.primaryColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .appShadow(isSelected ? AppTheme.Shadows.medium : AppTheme.Shadows.small)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let geometry: GeometryProxy
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: geometry.size.height * 0.02))
            .padding(geometry.size.height * 0.015)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .appShadow(AppTheme.Shadows.small)
    }
}

// MARK: - Navigation Header
struct NavigationHeader: View {
    let title: String
    let subtitle: String
    let progress: Double
    let showBackButton: Bool
    let onBack: (() -> Void)?
    let geometry: GeometryProxy
    
    init(title: String, subtitle: String, progress: Double, showBackButton: Bool = false, onBack: (() -> Void)? = nil, geometry: GeometryProxy) {
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.012) {
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: geometry.size.height * 0.025))
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
                
                Spacer()
            }
            
            VStack(spacing: geometry.size.height * 0.006) {
                Text(title)
                    .font(.system(size: geometry.size.height * 0.025, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                
                Text(subtitle)
                    .font(.system(size: geometry.size.height * 0.018))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            ProgressBar(progress: progress, geometry: geometry)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
    }
}
