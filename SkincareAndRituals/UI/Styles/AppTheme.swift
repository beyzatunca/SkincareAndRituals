import SwiftUI

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App Theme
struct AppTheme {
    // MARK: - Modern Color Palette
    static let darkCharcoal = Color(hex: "#332c2b")      // Dark charcoal
    static let warmBeige = Color(hex: "#e3c0b9")         // Warm beige
    static let softPink = Color(hex: "#ecc7cf")          // Soft pink
    static let darkSoftPink = Color(hex: "#d4a5b0")      // Dark soft pink (2 tones darker)
    static let creamWhite = Color(hex: "#CFC9C1")        // New background color
    
    // MARK: - Legacy Colors (for compatibility)
    static let primaryColor = Color(hex: "#332c2b")      // Dark charcoal
    static let secondaryColor = Color(hex: "#e3c0b9")    // Warm beige
    static let accentColor = Color(hex: "#ecc7cf")       // Soft pink
    static let backgroundColor = Color(hex: "#CFC9C1")   // New background color
    static let surfaceColor = Color(hex: "#CFC9C1")      // New background color
    static let textPrimary = Color(hex: "#332c2b")       // Dark charcoal
    static let textSecondary = Color(hex: "#332c2b").opacity(0.7) // Dark charcoal with opacity
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let errorColor = Color.red
    
    // MARK: - Modern Gradients
    static let primaryGradient = LinearGradient(
        colors: [creamWhite, softPink.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [creamWhite, warmBeige.opacity(0.2)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [creamWhite, softPink.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        colors: [softPink, warmBeige],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Modern Typography
    struct Typography {
        // Serif fonts for elegant headings
        static let largeTitle = Font.system(size: 36, weight: .bold, design: .serif)
        static let title1 = Font.system(size: 28, weight: .bold, design: .serif)
        static let title2 = Font.system(size: 24, weight: .semibold, design: .serif)
        static let title3 = Font.system(size: 20, weight: .medium, design: .serif)
        
        // Sans-serif for body text
        static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let callout = Font.system(size: 15, weight: .medium, design: .default)
        static let subheadline = Font.system(size: 14, weight: .medium, design: .default)
        static let footnote = Font.system(size: 12, weight: .regular, design: .default)
        static let caption = Font.system(size: 11, weight: .regular, design: .default)
        
        // Special fonts for survey
        static let surveyTitle = Font.custom("Didot", size: 32).weight(.bold)
        static let surveySubtitle = Font.custom("HelveticaNeue-Italic", size: 16)
        static let surveyOption = Font.custom("HelveticaNeue-Italic", size: 16)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        static let large = Shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Shadow Helper
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions
extension View {
    func appShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func appCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius)
    }
    
    func appBackground() -> some View {
        self.background(AppTheme.backgroundColor)
    }
    
    func appSurfaceBackground() -> some View {
        self.background(AppTheme.surfaceColor)
    }
}
