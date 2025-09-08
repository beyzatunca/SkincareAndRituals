import SwiftUI

struct ProductCardView: View {
    let product: Product
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Product Image Placeholder
                productImageSection
                
                // Product Info
                productInfoSection
                
                // Rating and Reviews
                ratingSection
                
                // Price
                priceSection
                
                // Badges
                badgesSection
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Product Image Section
    private var productImageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "F6F7F8"))
                .frame(height: 120)
            
            VStack(spacing: 8) {
                Image(systemName: product.category.icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "8B5CF6"))
                
                Text(product.category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
    
    // MARK: - Product Info Section
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.brand)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "8B5CF6"))
            
            Text(product.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(product.size)
                .font(.caption)
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    // MARK: - Rating Section
    private var ratingSection: some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(Color(hex: "F59E0B"))
                }
            }
            
            Text(product.ratingText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "111111"))
            
            Text("(\(product.reviewCount))")
                .font(.caption)
                .foregroundColor(Color(hex: "6B7280"))
            
            Spacer()
        }
    }
    
    // MARK: - Price Section
    private var priceSection: some View {
        HStack {
            Text(product.formattedPrice)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "111111"))
            
            Spacer()
            
            if product.isRecommended {
                Text("Önerilen")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "10B981"))
                    .clipShape(Capsule())
            }
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        HStack(spacing: 6) {
            if product.isCrueltyFree {
                badgeView(text: "Cruelty Free", color: "8B5CF6")
            }
            
            if product.isVegan {
                badgeView(text: "Vegan", color: "10B981")
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Views
    private func badgeView(text: String, color: String) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(Color(hex: color))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(hex: color).opacity(0.1))
            .clipShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    let sampleProduct = Product.sampleProducts.first!
    
    return VStack {
        ProductCardView(product: sampleProduct) {
            print("Product tapped")
        }
        
        Spacer()
    }
    .padding()
    .background(Color(hex: "F6F7F8"))
}
