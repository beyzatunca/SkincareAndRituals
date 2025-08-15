import SwiftUI

// MARK: - Product Scanner View
struct ProductScannerView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.primaryColor.opacity(0.3))
                    
                    Text("Scan Product")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Scan barcodes to get product information")
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
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
