import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var showingIngredients = false
    @State private var showingWarnings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Product Header
                    productHeaderSection
                    
                    // Product Image
                    productImageSection
                    
                    // Product Info
                    productInfoSection
                    
                    // Rating and Reviews
                    ratingSection
                    
                    // Benefits
                    benefitsSection
                    
                    // How to Use
                    howToUseSection
                    
                    // Ingredients
                    ingredientsSection
                    
                    // Warnings
                    warningsSection
                    
                    // Skin Types
                    skinTypesSection
                    
                    // Potentially Irritating Ingredients
                    potentiallyIrritatingIngredientsSection
                    
                    // Certifications & Claims
                    certificationsSection
                    
                    // Badges
                    badgesSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Product Header Section
    private var productHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.brand)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "8B5CF6"))
            
            Text(product.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "111111"))
            
            Text(product.size)
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    // MARK: - Product Image Section
    private var productImageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "F6F7F8"))
                .frame(height: 200)
            
            VStack(spacing: 16) {
                Image(systemName: product.category.icon)
                    .font(.system(size: 64))
                    .foregroundColor(Color(hex: "8B5CF6"))
                
                Text(product.category.rawValue)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
    
    // MARK: - Product Info Section
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(product.formattedPrice)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                if product.isRecommended {
                    Text("Recommended")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "10B981"))
                        .clipShape(Capsule())
                }
            }
            
            Text(product.description)
                .font(.body)
                .foregroundColor(Color(hex: "374151"))
                .lineSpacing(4)
        }
    }
    
    // MARK: - Rating Section
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                            .font(.title3)
                            .foregroundColor(Color(hex: "F59E0B"))
                    }
                }
                
                Text(product.ratingText)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
            }
            
            Text(product.reviewText)
                .font(.subheadline)
                .foregroundColor(Color(hex: "6B7280"))
        }
    }
    
    // MARK: - Benefits Section
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Benefits")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(product.benefits, id: \.self) { benefit in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "10B981"))
                            .font(.caption)
                        
                        Text(benefit)
                            .font(.caption)
                            .foregroundColor(Color(hex: "374151"))
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - How to Use Section
    private var howToUseSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Use")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            Text(product.howToUse)
                .font(.body)
                .foregroundColor(Color(hex: "374151"))
                .lineSpacing(4)
        }
    }
    
    // MARK: - Ingredients Section
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                showingIngredients.toggle()
            }) {
                HStack {
                    Text("Ingredients")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "111111"))
                    
                    Spacer()
                    
                    Image(systemName: showingIngredients ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(hex: "6B7280"))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showingIngredients {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(product.ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "374151"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "F3F4F6"))
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Warnings Section
    private var warningsSection: some View {
        Group {
            if !product.warnings.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        showingWarnings.toggle()
                    }) {
                        HStack {
                            Text("Warnings")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "EF4444"))
                            
                            Spacer()
                            
                            Image(systemName: showingWarnings ? "chevron.up" : "chevron.down")
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showingWarnings {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(product.warnings, id: \.self) { warning in
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(Color(hex: "EF4444"))
                                        .font(.caption)
                                    
                                    Text(warning)
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "374151"))
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Skin Types Section
    private var skinTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Suitable Skin Types")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(product.skinTypes, id: \.self) { skinType in
                    HStack {
                        Text(skinType.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "8B5CF6"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(hex: "8B5CF6").opacity(0.1))
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Potentially Irritating Ingredients Section
    private var potentiallyIrritatingIngredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Potentially Irritating Ingredients")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            if product.potentiallyIrritatingIngredients.isEmpty {
                Text("No potentially irritating ingredients detected")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "10B981"))
                    .padding(.vertical, 8)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(product.potentiallyIrritatingIngredients, id: \.self) { ingredient in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "EF4444"))
                            
                            Text(ingredient)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "EF4444"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "EF4444").opacity(0.1))
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Certifications & Claims Section
    private var certificationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Certifications & Claims")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            if product.certifications.isEmpty {
                Text("No certifications available")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "6B7280"))
                    .padding(.vertical, 8)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(product.certifications, id: \.self) { certification in
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(Color(hex: "10B981"))
                            
                            Text(certification)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(hex: "10B981"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "10B981").opacity(0.1))
                                .clipShape(Capsule())
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        HStack(spacing: 12) {
            if product.isVegan {
                badgeView(text: "Vegan", icon: "leaf.fill", color: "10B981")
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Views
    private func badgeView(text: String, icon: String, color: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(Color(hex: color))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: color).opacity(0.1))
        .clipShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    guard let sampleProduct = Product.sampleProducts.first else {
        return VStack {
            Text("No sample products available")
        }
    }
    
    return ProductDetailView(product: sampleProduct)
}
