import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showingProductDetail: Product?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Products")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "111111"))
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // Category Selection Bar
                categorySelectionBar(geometry: geometry)
                
                // Search Bar
                searchBar(geometry: geometry)
                
                // Products Grid
                productsGrid(geometry: geometry)
            }
            .background(Color(hex: "F6F7F8"))
        }
        .sheet(item: $showingProductDetail) { product in
            ProductDetailView(product: product)
        }
        .onAppear {
            print("✅ ProductsView appeared, items=\(viewModel.filteredProducts.count)")
        }
    }
    
    // MARK: - Category Selection Bar
    private func categorySelectionBar(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        viewModel.selectCategory(category)
                    }) {
                        Text(category)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : Color(hex: "111111"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedCategory == category ? 
                                    Color(hex: "111111") : Color(hex: "E8E8E8")
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
    
    // MARK: - Search Bar
    private func searchBar(geometry: GeometryProxy) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "6B7280"))
                .font(.subheadline)
            
            TextField("Search products…", text: $viewModel.query)
                .font(.subheadline)
                .foregroundColor(Color(hex: "111111"))
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.query.isEmpty {
                Button(action: {
                    viewModel.clearSearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "6B7280"))
                        .font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Products Grid
    private func productsGrid(geometry: GeometryProxy) -> some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.filteredProducts.isEmpty {
                emptyStateView(geometry: geometry)
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 168), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(viewModel.filteredProducts) { product in
                        ProductCardView(product: product) {
                            showingProductDetail = product
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .refreshable {
            viewModel.loadProducts()
        }
    }
    
    // MARK: - Empty State
    private func emptyStateView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "6B7280").opacity(0.5))
            
            Text("No products found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            Text("Try adjusting your search or category filter")
                .font(.body)
                .foregroundColor(Color(hex: "6B7280"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview("iPhone SE") {
    ProductsView()
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro Max") {
    ProductsView()
        .previewDevice("iPhone 15 Pro Max")
}
