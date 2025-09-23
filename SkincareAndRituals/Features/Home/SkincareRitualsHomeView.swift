import SwiftUI

struct SkincareRitualsHomeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: AppTheme.Spacing.md) {
                        Text("Skincare & Rituals")
                            .font(AppTheme.Typography.largeTitle)
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(.top, geometry.size.height * 0.05)
                    }
                    
                    ScrollView {
                        VStack(spacing: AppTheme.Spacing.lg) {
                            // Add Routine Panel
                            AddRoutineCard()
                            
                            // Environmental Factors
                            HStack(spacing: AppTheme.Spacing.md) {
                                UVIndexCard()
                                HumidityCard()
                            }
                            
                            // Pollution Level Panel
                            PollutionLevelCard()
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.bottom, 100) // Space for bottom navigation
                    }
                }
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    BottomNavigationView(selectedTab: $selectedTab)
                        .background(
                            Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                        )
                }
            }
        }
    }
}

// MARK: - Add Routine Card
struct AddRoutineCard: View {
    var body: some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("AI skin analysis results & your concerns will be used to prepare a personalized skincare routine just for you.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    // Add routine action
                }) {
                    Text("Add Routine")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(AppTheme.primaryColor)
                        )
                }
            }
            
            Spacer()
            
            // Decorative icon
            VStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.primaryColor)
                
                Image(systemName: "square.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.softPink)
                
                Image(systemName: "triangle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.warmBeige)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.softPink.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(AppTheme.softPink.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - UV Index Card
struct UVIndexCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
                
                Text("UV Index")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Text("6")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.orange)
            
            Text("High UV – Wear sunscreen and limit sun exposure.")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Humidity Card
struct HumidityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                
                Text("Humidity")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Text("40%")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.blue)
            
            Text("Moderate humidity – Balanced skin condition.")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Pollution Level Card
struct PollutionLevelCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                    
                    Text("Pollution Level")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                HStack(alignment: .bottom, spacing: AppTheme.Spacing.sm) {
                    Text("13")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Good")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green)
                        )
                }
                
                Text("Low pollution – Minimal impact on skin.")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Bottom Navigation
struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcon(for: index))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == index ? AppTheme.primaryColor : AppTheme.textSecondary)
                        
                        if selectedTab == index {
                            Circle()
                                .fill(AppTheme.primaryColor)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
        }
        .background(Color.white)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "drop.fill"
        case 2: return "camera.fill"
        case 3: return "sparkles"
        case 4: return "person.fill"
        default: return "circle"
        }
    }
}

#Preview {
    SkincareRitualsHomeView()
}
