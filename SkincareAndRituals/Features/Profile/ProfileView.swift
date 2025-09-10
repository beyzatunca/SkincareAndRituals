import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header
                    profileHeaderSection
                    
                    // Scans & Diary Card
                    scansAndDiaryCard
                    
                    // Profile Sections
                    profileSectionsView
                    
                    // Log Out Button
                    logOutButton
                    
                    Spacer(minLength: 100)
                }
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Log Out", isPresented: $viewModel.showingLogOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                viewModel.logOut()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .onChange(of: viewModel.selectedAction) { action in
            if let action = action {
                handleAction(action)
            }
        }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            // Avatar with edit button
            ZStack {
                Circle()
                    .fill(Color(hex: "E5E7EB"))
                    .frame(width: 80, height: 80)
                
                Text("😊")
                    .font(.system(size: 40))
                
                // Edit button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle edit profile
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color(hex: "8B5CF6"))
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(width: 80, height: 80)
            }
            
            // User name
            Text(viewModel.userProfile.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "111111"))
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Scans & Diary Card
    private var scansAndDiaryCard: some View {
        Button(action: {
            viewModel.handleAction(.faceScans)
        }) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "6B7280"))
                
                Text("Scans & Diary - September")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    // MARK: - Profile Sections View
    private var profileSectionsView: some View {
        VStack(spacing: 32) {
            ForEach(ProfileSection.allCases) { section in
                if section == .getInvolved {
                    socialMediaSectionView
                } else {
                    profileSectionView(section: section)
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Profile Section View
    private func profileSectionView(section: ProfileSection) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            Text(section.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
                .padding(.horizontal, 4)
            
            // Section Items
            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                    profileMenuItemView(item: item, isLast: index == section.items.count - 1)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Profile Menu Item View
    private func profileMenuItemView(item: ProfileMenuItem, isLast: Bool) -> some View {
        Button(action: {
            viewModel.handleAction(item.action)
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "6B7280"))
                    .frame(width: 24, height: 24)
                
                // Title
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                // Badge
                if let badge = item.badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "8B5CF6"))
                        .clipShape(Capsule())
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            // Divider
            VStack {
                Spacer()
                if !isLast {
                    Rectangle()
                        .fill(Color(hex: "E5E7EB"))
                        .frame(height: 1)
                        .padding(.leading, 60)
                }
            }
        )
    }
    
    // MARK: - Social Media Section View
    private var socialMediaSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            Text("GET INVOLVED")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                // Share Lóvi item
                Button(action: {
                    viewModel.handleAction(.shareLovi)
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "6B7280"))
                            .frame(width: 24, height: 24)
                        
                        Text("Share Lóvi")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "111111"))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Divider
                Rectangle()
                    .fill(Color(hex: "E5E7EB"))
                    .frame(height: 1)
                    .padding(.leading, 60)
                
                // Social Media Platforms
                HStack(spacing: 20) {
                    ForEach(SocialMediaPlatform.allCases) { platform in
                        socialMediaButton(platform: platform)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.white)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Social Media Button
    private func socialMediaButton(platform: SocialMediaPlatform) -> some View {
        Button(action: {
            if let url = URL(string: platform.url) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(hex: platform.color))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: platform.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                Text(platform.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Log Out Button
    private var logOutButton: some View {
        Button(action: {
            viewModel.handleAction(.logOut)
        }) {
            Text("Log Out")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "111111"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "E5E7EB"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    // MARK: - Action Handling
    private func handleAction(_ action: ProfileAction) {
        switch action {
        case .mySkinProfile:
            // Navigate to skin profile
            print("Navigate to My Skin Profile")
        case .routinePreferences:
            // Navigate to routine preferences
            print("Navigate to Routine Preferences")
        case .routineForYou:
            // Navigate to routine for you
            print("Navigate to Routine for You")
        case .myShelf:
            // Navigate to my shelf
            print("Navigate to My Shelf")
        case .faceScans:
            // Navigate to face scans
            print("Navigate to Face Scans")
        case .subscriptionManagement:
            // Navigate to subscription management
            print("Navigate to Subscription Management")
        case .frequentlyAskedQuestions:
            // Show FAQ
            print("Show FAQ")
        case .appSettings:
            // Open app settings
            print("Open App Settings")
        case .suggestFeature:
            // Show suggest feature
            print("Show Suggest Feature")
        case .contactUs:
            // Open contact us
            print("Open Contact Us")
        case .shareLovi:
            // Share app
            print("Share App")
        case .privacyPolicy:
            // Show privacy policy
            print("Show Privacy Policy")
        case .moneyBackPolicy:
            // Show money back policy
            print("Show Money Back Policy")
        case .termsOfUse:
            // Show terms of use
            print("Show Terms of Use")
        case .logOut:
            // Handle logout
            print("Handle Logout")
        }
    }
}
