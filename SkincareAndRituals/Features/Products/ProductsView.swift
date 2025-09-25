import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var showingProductDetail: Product?
    @State private var showingSortOptions = false
    @State private var showingFilterOptions = false
    
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
                
                // Sort and Filter Buttons
                sortAndFilterButtons(geometry: geometry)
                
                // Products Grid
                productsGrid(geometry: geometry)
            }
            .background(Color(hex: "F6F7F8"))
        }
        .sheet(item: $showingProductDetail, onDismiss: {
            // Reset product detail state when dismissed
            showingProductDetail = nil
        }) { product in
            ProductDetailView(product: product)
        }
        .sheet(isPresented: $showingSortOptions) {
            sortOptionsSheet()
        }
        .sheet(isPresented: $showingFilterOptions) {
            filterOptionsSheet()
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
    
    // MARK: - Sort and Filter Buttons
    private func sortAndFilterButtons(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            // Sort Button
            Button(action: {
                showingSortOptions = true
            }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.subheadline)
                    Text("Sort")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(Color(hex: "111111"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Divider
            Rectangle()
                .fill(Color(hex: "E8E8E8"))
                .frame(width: 1, height: 20)
            
            // Filter Button
            Button(action: {
                showingFilterOptions = true
            }) {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.subheadline)
                    Text("Filter")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(Color(hex: "111111"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - Sort Options Sheet
    private func sortOptionsSheet() -> some View {
        NavigationView {
            VStack(spacing: 0) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: {
                        viewModel.selectSortOption(option)
                        showingSortOptions = false
                    }) {
                        HStack {
                            Text(option.rawValue)
                                .font(.body)
                                .foregroundColor(Color(hex: "111111"))
                            
                            Spacer()
                            
                            if viewModel.selectedSortOption == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(hex: "111111"))
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if option != SortOption.allCases.last {
                        Divider()
                            .padding(.leading, 20)
                    }
                }
                
                Spacer()
            }
            .background(Color(hex: "F6F7F8"))
            .navigationTitle("Sort Products")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                showingSortOptions = false
            })
        }
    }
    
    // MARK: - Filter Options Sheet
    private func filterOptionsSheet() -> some View {
        NavigationView {
            VStack(spacing: 0) {
                // Brand Filter
                VStack(alignment: .leading, spacing: 12) {
                    Text("Brand")
                        .font(.headline)
                        .foregroundColor(Color(hex: "111111"))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.availableBrands, id: \.self) { brand in
                                Button(action: {
                                    viewModel.selectBrandFilter(brand)
                                }) {
                                    Text(brand)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(viewModel.selectedBrandFilter == brand ? .white : Color(hex: "111111"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewModel.selectedBrandFilter == brand ? 
                                                Color(hex: "111111") : Color(hex: "E8E8E8")
                                        )
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Gender Filter
                VStack(alignment: .leading, spacing: 12) {
                    Text("Gender")
                        .font(.headline)
                        .foregroundColor(Color(hex: "111111"))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.availableGenders, id: \.self) { gender in
                                Button(action: {
                                    viewModel.selectGenderFilter(gender)
                                }) {
                                    Text(gender)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(viewModel.selectedGenderFilter == gender ? .white : Color(hex: "111111"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewModel.selectedGenderFilter == gender ? 
                                                Color(hex: "111111") : Color(hex: "E8E8E8")
                                        )
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
                
                // Clear Filters Button
                Button(action: {
                    viewModel.clearFilters()
                    showingFilterOptions = false
                }) {
                    Text("Clear All Filters")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "111111"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color(hex: "F6F7F8"))
            .navigationTitle("Filter Products")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                showingFilterOptions = false
            })
        }
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
