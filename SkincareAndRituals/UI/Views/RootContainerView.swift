import SwiftUI

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
                    MainPageView()
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
            // Restore last selected tab
            if let tab = AppTab(rawValue: lastSelectedTab) {
                selectedTab = tab
            }
        }
        .onChange(of: selectedTab) { newValue in
            // Save selected tab
            lastSelectedTab = newValue.rawValue
        }
    }
}
