import Foundation

// MARK: - App Tab Enum
enum AppTab: String, CaseIterable {
    case home = "home"
    case products = "products"
    case scan = "scan"
    case explore = "explore"
    case profile = "profile"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .products: return "Products"
        case .scan: return "Scan product"
        case .explore: return "Explore routines"
        case .profile: return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .products: return "drop.fill" // Placeholder for iconProduct
        case .scan: return "viewfinder" // Placeholder for iconScan
        case .explore: return "sparkles"
        case .profile: return "person.crop.circle"
        }
    }
    
    var activeIconName: String {
        switch self {
        case .home: return "house.fill"
        case .products: return "drop.fill" // Placeholder for iconProduct
        case .scan: return "viewfinder" // Placeholder for iconScan
        case .explore: return "sparkles"
        case .profile: return "person.crop.circle.fill"
        }
    }
}
