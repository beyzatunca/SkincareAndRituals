import Foundation
import SwiftUI

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case nameAZ = "Name A-Z"
    case nameZA = "Name Z-A"
    case priceAsc = "Price Low to High"
    case priceDesc = "Price High to Low"
    case favorites = "Favorites"
    
    var id: String { rawValue }
}

@MainActor
class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories: [ProductCategory] = []
    @Published var selectedCategory: ProductCategory = .all
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var favoriteProductIds: Set<UUID> = []
    
    // Sort and Filter properties
    @Published var selectedSortOption: SortOption = .nameAZ
    @Published var selectedBrandFilter: String = "All"
    @Published var selectedGenderFilter: String = "All"
    @Published var availableBrands: [String] = []
    @Published var availableGenders: [String] = ["All", "Men", "Women", "Unisex"]
    
    init() {
        loadFavorites()
        loadProducts()
        setupCategories()
        setupAvailableBrands()
    }
    
    // MARK: - Data Loading
    func loadProducts() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.products = Product.sampleProducts
            self.setupAvailableBrands()
            self.filterProducts()
            self.isLoading = false
        }
    }
    
    private func setupCategories() {
        categories = ProductCategory.allCases
    }
    
    // MARK: - Filtering
    func selectCategory(_ category: ProductCategory) {
        selectedCategory = category
        filterProducts()
    }
    
    func filterProducts() {
        var filtered = products
        
        // Filter by category
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search query
        if !query.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(query) ||
                product.brand.localizedCaseInsensitiveContains(query) ||
                product.description.localizedCaseInsensitiveContains(query) ||
                product.ingredients.joined().localizedCaseInsensitiveContains(query)
            }
        }
        
        // Filter by brand
        if selectedBrandFilter != "All" {
            filtered = filtered.filter { $0.brand == selectedBrandFilter }
        }
        
        // Filter by gender (for now, we'll use a simple approach)
        // In a real app, you'd have gender data in your Product model
        if selectedGenderFilter != "All" {
            // This is a placeholder - you'd implement actual gender filtering based on your data
            // For now, we'll just keep all products
        }
        
        // Sort products
        filtered = sortProducts(filtered)
        
        filteredProducts = filtered
    }
    
    func clearSearch() {
        query = ""
        filterProducts()
    }
    
    // MARK: - Computed Properties
    var hasProducts: Bool {
        !filteredProducts.isEmpty
    }
    
    var categoryCount: Int {
        filteredProducts.count
    }
    
    // MARK: - Search
    func searchProducts(_ searchText: String) {
        query = searchText
        filterProducts()
    }
    
    // MARK: - Product Management
    func getProductsByCategory(_ category: ProductCategory) -> [Product] {
        if category == .all {
            return products
        }
        return products.filter { $0.category == category }
    }
    
    func getRecommendedProducts() -> [Product] {
        return products.filter { $0.isRecommended }
    }
    
    func getProductsForSkinType(_ skinType: SkinType) -> [Product] {
        return products.filter { $0.skinTypes.contains(skinType) }
    }
    
    // MARK: - Statistics
    func getCategoryStats() -> [ProductCategory: Int] {
        var stats: [ProductCategory: Int] = [:]
        
        for category in ProductCategory.allCases {
            if category != .all {
                stats[category] = products.filter { $0.category == category }.count
            }
        }
        
        return stats
    }
    
    var totalProducts: Int {
        products.count
    }
    
    var averageRating: Double {
        guard !products.isEmpty else { return 0 }
        let totalRating = products.reduce(0) { $0 + $1.rating }
        return totalRating / Double(products.count)
    }
    
    // MARK: - Favorites Management
    func toggleFavorite(for product: Product) {
        if favoriteProductIds.contains(product.id) {
            favoriteProductIds.remove(product.id)
        } else {
            favoriteProductIds.insert(product.id)
        }
        saveFavorites()
    }
    
    func isFavorite(_ product: Product) -> Bool {
        return favoriteProductIds.contains(product.id)
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteProductIds"),
           let favorites = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteProductIds = favorites
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteProductIds) {
            UserDefaults.standard.set(data, forKey: "favoriteProductIds")
        }
    }
    
    // MARK: - Sort and Filter Functions
    private func setupAvailableBrands() {
        availableBrands = ["All"] + Array(Set(products.map { $0.brand })).sorted()
    }
    
    func selectSortOption(_ option: SortOption) {
        selectedSortOption = option
        filterProducts()
    }
    
    func selectBrandFilter(_ brand: String) {
        selectedBrandFilter = brand
        filterProducts()
    }
    
    func selectGenderFilter(_ gender: String) {
        selectedGenderFilter = gender
        filterProducts()
    }
    
    func clearFilters() {
        selectedBrandFilter = "All"
        selectedGenderFilter = "All"
        selectedSortOption = .nameAZ
        filterProducts()
    }
    
    private func sortProducts(_ products: [Product]) -> [Product] {
        switch selectedSortOption {
        case .nameAZ:
            return products.sorted { $0.name < $1.name }
        case .nameZA:
            return products.sorted { $0.name > $1.name }
        case .priceAsc:
            return products.sorted { $0.price < $1.price }
        case .priceDesc:
            return products.sorted { $0.price > $1.price }
        case .favorites:
            return products.sorted { product1, product2 in
                let isFavorite1 = favoriteProductIds.contains(product1.id)
                let isFavorite2 = favoriteProductIds.contains(product2.id)
                if isFavorite1 && !isFavorite2 {
                    return true
                } else if !isFavorite1 && isFavorite2 {
                    return false
                } else {
                    return product1.name < product2.name
                }
            }
        }
    }
}
