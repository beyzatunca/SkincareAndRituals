import SwiftUI


// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Root Container View
struct RootContainerView: View {
    @AppStorage("lastTab") private var lastSelectedTab: String = AppTab.home.rawValue
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.9, green: 0.85, blue: 0.95), // Lavender
                    Color(red: 0.95, green: 0.9, blue: 0.85)  // Peach-pink
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content area
                TabView(selection: $selectedTab) {
                    SkincareAndRitualsMainView()
                        .tag(AppTab.home)
                    
                    ProductsView()
                        .tag(AppTab.products)
                    
                    ProductScannerView()
                        .tag(AppTab.scan)
                    
                    ExploreRoutinesView()
                        .tag(AppTab.explore)
                    
                    ProfileView()
                        .tag(AppTab.profile)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                Spacer(minLength: 0)
                
                // Bottom tab bar
                AppTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            // Always start with home tab (Skincare & Rituals)
            selectedTab = .home
            lastSelectedTab = AppTab.home.rawValue
        }
        .onChange(of: selectedTab) { newValue in
            // Save selected tab
            lastSelectedTab = newValue.rawValue
        }
    }
}
