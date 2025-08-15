import SwiftUI

// MARK: - Products View
struct ProductsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.primaryColor.opacity(0.3))
                    
                    Text("Products")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Discover and manage your skincare products")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppTheme.surfaceColor)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
