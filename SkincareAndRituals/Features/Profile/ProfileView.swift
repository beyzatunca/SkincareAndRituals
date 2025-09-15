import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingActionSheet = false
    @State private var showingAppSettings = false
    @State private var showingMySkinProfile = false
    
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
        .sheet(isPresented: $showingAppSettings, onDismiss: {
            showingAppSettings = false
        }) {
            AppSettingsView()
        }
        .sheet(isPresented: $showingMySkinProfile) {
            MySkinProfileView()
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
                if section != .getInvolved {
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
        HStack(spacing: 16) {
            // Icon
            Image(systemName: item.icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "6B7280"))
                .frame(width: 24, height: 24)
            
            // Title
            Text(item.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Badge
            if let badge = item.badge {
                Text(badge)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "8B5CF6"))
                    .cornerRadius(12)
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "9CA3AF"))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .onTapGesture {
            print("🔴 Button tapped: \(item.action.rawValue)")
            if item.action == .appSettings || item.action == .mySkinProfile {
                // Handle App Settings and My Skin Profile directly in ProfileView
                print("🔴 Calling ProfileView.handleAction for: \(item.action.rawValue)")
                handleAction(item.action)
            } else {
                print("🔴 Calling ProfileViewModel.handleAction for: \(item.action.rawValue)")
                viewModel.handleAction(item.action)
            }
        }
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
            // Navigate to skin profile - ensure state is reset first
            print("🟡 MySkinProfile action - current state: \(showingMySkinProfile)")
            if showingMySkinProfile {
                print("🟡 Resetting showingMySkinProfile to false")
                showingMySkinProfile = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("🟡 Setting showingMySkinProfile to true")
                showingMySkinProfile = true
            }
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
            // Open app settings - ensure state is reset first
            if showingAppSettings {
                showingAppSettings = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showingAppSettings = true
            }
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
