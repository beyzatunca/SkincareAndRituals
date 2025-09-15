import Foundation

// MARK: - Profile Menu Item
struct ProfileMenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let action: ProfileAction
    let badge: String?
    
    init(title: String, icon: String, action: ProfileAction, badge: String? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
        self.badge = badge
    }
}

// MARK: - Profile Action
enum ProfileAction: String, CaseIterable {
    case mySkinProfile = "My Skin Profile"
    case routinePreferences = "Routine Preferences"
    case routineForYou = "Routine for you"
    case myShelf = "My Shelf"
    case faceScans = "Face Scans"
    case subscriptionManagement = "Subscription Management"
    case frequentlyAskedQuestions = "Frequently Asked Questions"
    case appSettings = "App Settings"
    case contactUs = "Contact us"
    case privacyPolicy = "Privacy policy"
    case moneyBackPolicy = "Money-back Policy"
    case termsOfUse = "Terms of Use"
    case logOut = "Log Out"
    
    var icon: String {
        switch self {
        case .mySkinProfile: return "face.smiling"
        case .routinePreferences: return "slider.horizontal.3"
        case .routineForYou: return "sparkles"
        case .myShelf: return "books.vertical"
        case .faceScans: return "viewfinder"
        case .subscriptionManagement: return "person.crop.circle.badge.checkmark"
        case .frequentlyAskedQuestions: return "questionmark.circle"
        case .appSettings: return "gearshape"
        case .contactUs: return "bubble.left.and.bubble.right"
        case .privacyPolicy: return "hand.raised"
        case .moneyBackPolicy: return "dollarsign.circle"
        case .termsOfUse: return "doc.text"
        case .logOut: return "rectangle.portrait.and.arrow.right"
        }
    }
}


// MARK: - Profile Section
enum ProfileSection: String, CaseIterable, Identifiable {
    case personal = "PERSONAL"
    case needHelp = "NEED HELP?"
    case legal = "LEGAL"
    
    var id: String { rawValue }
    
    var items: [ProfileMenuItem] {
        switch self {
        case .personal:
            return [
                ProfileMenuItem(title: "My Skin Profile", icon: ProfileAction.mySkinProfile.icon, action: .mySkinProfile),
                ProfileMenuItem(title: "Routine Preferences", icon: ProfileAction.routinePreferences.icon, action: .routinePreferences),
                ProfileMenuItem(title: "Routine for you", icon: ProfileAction.routineForYou.icon, action: .routineForYou),
                ProfileMenuItem(title: "My Shelf", icon: ProfileAction.myShelf.icon, action: .myShelf),
                ProfileMenuItem(title: "Face Scans (2)", icon: ProfileAction.faceScans.icon, action: .faceScans, badge: "2"),
                ProfileMenuItem(title: "Subscription Management", icon: ProfileAction.subscriptionManagement.icon, action: .subscriptionManagement)
            ]
        case .needHelp:
            return [
                ProfileMenuItem(title: "Frequently Asked Questions", icon: ProfileAction.frequentlyAskedQuestions.icon, action: .frequentlyAskedQuestions),
                ProfileMenuItem(title: "App Settings", icon: ProfileAction.appSettings.icon, action: .appSettings),
                ProfileMenuItem(title: "Contact us", icon: ProfileAction.contactUs.icon, action: .contactUs)
            ]
        case .legal:
            return [
                ProfileMenuItem(title: "Privacy policy", icon: ProfileAction.privacyPolicy.icon, action: .privacyPolicy),
                ProfileMenuItem(title: "Money-back Policy", icon: ProfileAction.moneyBackPolicy.icon, action: .moneyBackPolicy),
                ProfileMenuItem(title: "Terms of Use", icon: ProfileAction.termsOfUse.icon, action: .termsOfUse)
            ]
        }
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String
    var avatar: String?
    var joinDate: Date
    var subscriptionStatus: SubscriptionStatus
    var faceScansCount: Int
    var preferences: UserPreferences
    
    // Skin Profile Information
    var gender: String
    var ageRange: String
    var skinType: String
    var skinSensitivity: String
    var skinConcerns: String
    
    init(name: String = "User", avatar: String? = nil, joinDate: Date = Date(), subscriptionStatus: SubscriptionStatus = .free, faceScansCount: Int = 2, preferences: UserPreferences = UserPreferences(), gender: String = "Prefer not to say", ageRange: String = "18-24", skinType: String = "Normal", skinSensitivity: String = "Not sensitive", skinConcerns: String = "Acne or pimples") {
        self.name = name
        self.avatar = avatar
        self.joinDate = joinDate
        self.subscriptionStatus = subscriptionStatus
        self.faceScansCount = faceScansCount
        self.preferences = preferences
        self.gender = gender
        self.ageRange = ageRange
        self.skinType = skinType
        self.skinSensitivity = skinSensitivity
        self.skinConcerns = skinConcerns
    }
}

// MARK: - Subscription Status
enum SubscriptionStatus: String, CaseIterable, Codable {
    case free = "Free"
    case premium = "Premium"
    case pro = "Pro"
    
    var displayName: String {
        switch self {
        case .free: return "Free Plan"
        case .premium: return "Premium Plan"
        case .pro: return "Pro Plan"
        }
    }
    
    var color: String {
        switch self {
        case .free: return "6B7280"
        case .premium: return "8B5CF6"
        case .pro: return "F59E0B"
        }
    }
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    var notifications: Bool
    var darkMode: Bool
    var language: String
    var units: String
    
    init(notifications: Bool = true, darkMode: Bool = false, language: String = "English", units: String = "Metric") {
        self.notifications = notifications
        self.darkMode = darkMode
        self.language = language
        self.units = units
    }
}

// MARK: - Profile ViewModel
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var showingLogOutAlert = false
    @Published var selectedAction: ProfileAction?
    
    init() {
        self.userProfile = UserProfile()
    }
    
    // MARK: - Actions
    func handleAction(_ action: ProfileAction) {
        switch action {
        case .logOut:
            selectedAction = action
            showingLogOutAlert = true
        case .contactUs:
            selectedAction = action
            openContactUs()
        case .appSettings:
            // App Settings is handled in ProfileView, don't set selectedAction
            return
        case .mySkinProfile:
            // My Skin Profile is handled in ProfileView, don't set selectedAction
            return
        default:
            // Handle other actions
            selectedAction = action
            print("Selected action: \(action.rawValue)")
        }
    }
    
    private func openContactUs() {
        if let url = URL(string: "mailto:support@skincareandrituals.com") {
            UIApplication.shared.open(url)
        }
    }
    
    
    func logOut() {
        // Handle logout logic
        print("User logged out")
    }
    
    // MARK: - Computed Properties
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: userProfile.joinDate)
    }
    
    var subscriptionDisplayText: String {
        return userProfile.subscriptionStatus.displayName
    }
}
