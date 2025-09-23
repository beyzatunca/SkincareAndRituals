import Foundation
import SwiftUI

@MainActor
class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories: [ProductCategory] = []
    @Published var selectedCategory: ProductCategory = .all
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    @Published var favoriteProductIds: Set<UUID> = []
    
    init() {
        loadFavorites()
        loadProducts()
        setupCategories()
    }
    
    // MARK: - Data Loading
    func loadProducts() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.products = Product.sampleProducts
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
}
