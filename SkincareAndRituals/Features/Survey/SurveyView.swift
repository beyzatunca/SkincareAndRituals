import SwiftUI
import AVFoundation

// MARK: - Product Category
enum ProductCategory: String, CaseIterable, Identifiable, Codable, Hashable {
    case cleanser = "Cleanser"
    case moisturizer = "Moisturizer"
    case serum = "Serum"
    case sunscreen = "Sunscreen"
    case toner = "Toner"
    case exfoliant = "Exfoliant"
    case mask = "Mask"
    case eyeCare = "Eye Care"
    case lipCare = "Lip Care"
    case all = "All"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .cleanser: return "drop.fill"
        case .moisturizer: return "leaf.fill"
        case .serum: return "eyedropper"
        case .sunscreen: return "sun.max.fill"
        case .toner: return "sparkles"
        case .exfoliant: return "circle.grid.3x3.fill"
        case .mask: return "face.smiling"
        case .eyeCare: return "eye.fill"
        case .lipCare: return "heart.fill"
        case .all: return "square.grid.2x2.fill"
        }
    }
}


// MARK: - Product
struct Product: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let brand: String
    let category: ProductCategory
    let price: Double
    let currency: String
    let imageURL: String?
    let description: String
    let ingredients: [String]
    let skinTypes: [SkinType]
    let rating: Double
    let reviewCount: Int
    let size: String
    let isCrueltyFree: Bool
    let isVegan: Bool
    let isRecommended: Bool
    let benefits: [String]
    let howToUse: String
    let warnings: [String]
    let potentiallyIrritatingIngredients: [String]
    let certifications: [String]
    
    // Computed properties
    var formattedPrice: String {
        return "\(currency) \(String(format: "%.2f", price))"
    }
    
    var ratingText: String {
        return String(format: "%.1f", rating)
    }
    
    var reviewText: String {
        return "\(reviewCount) reviews"
    }
}

// MARK: - Sample Data
extension Product {
    static let sampleProducts: [Product] = [
        // Cleansers
        Product(
            name: "Gentle Foaming Cleanser",
            brand: "CeraVe",
            category: .cleanser,
            price: 15.99,
            currency: "$",
            imageURL: nil,
            description: "Gentle foaming cleanser for sensitive skin. Moisturizes while cleansing the skin.",
            ingredients: ["Ceramides", "Hyaluronic Acid", "Niacinamide"],
            skinTypes: [.normal, .dry],
            rating: 4.5,
            reviewCount: 1247,
            size: "236ml",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: true,
            benefits: ["Cleanses", "Moisturizes", "Suitable for sensitive skin"],
            howToUse: "Apply to wet skin morning and evening, lather and rinse.",
            warnings: ["Avoid contact with eyes"],
            potentiallyIrritatingIngredients: ["Sulfates", "Fragrances/Parfumes", "Parabens"],
            certifications: ["Cruelty-free", "Dermatologically Tested", "Hypoallergenic"]
        ),
        
        Product(
            name: "Salicylic Acid Cleanser",
            brand: "The Ordinary",
            category: .cleanser,
            price: 12.90,
            currency: "$",
            imageURL: nil,
            description: "Salicylic acid cleanser for acne-prone skin.",
            ingredients: ["Salicylic Acid", "Coconut-derived Surfactants"],
            skinTypes: [.oily, .combination],
            rating: 4.2,
            reviewCount: 892,
            size: "150ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Cleanses pores", "Reduces acne formation", "Oil control"],
            howToUse: "Apply to wet skin 1-2 times daily and rinse.",
            warnings: ["May cause sun sensitivity", "Use sunscreen"],
            potentiallyIrritatingIngredients: ["Salicylic Acid", "Drying Alcohols"],
            certifications: ["Cruelty-free", "Vegan", "Non-comedogenic"]
        ),
        
        // Moisturizers
        Product(
            name: "Daily Moisturizing Lotion",
            brand: "Cetaphil",
            category: .moisturizer,
            price: 18.50,
            currency: "$",
            imageURL: nil,
            description: "Günlük kullanım için hafif ve hızlı emilen nemlendirici.",
            ingredients: ["Glycerin", "Dimethicone", "Vitamin E"],
            skinTypes: [.normal, .dry, .combination],
            rating: 4.3,
            reviewCount: 2156,
            size: "200ml",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: true,
            benefits: ["24 saat nemlendirme", "Hızlı emilim", "Günlük kullanım"],
            howToUse: "Temiz cilde sabah ve akşam uygulayın.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Dermatologically Tested", "Hypoallergenic"]
        ),
        
        Product(
            name: "Hyaluronic Acid Moisturizer",
            brand: "The Inkey List",
            category: .moisturizer,
            price: 14.99,
            currency: "$",
            imageURL: nil,
            description: "Hyaluronik asit ile yoğun nemlendirme sağlayan krem.",
            ingredients: ["Hyaluronic Acid", "Squalane", "Ceramides"],
            skinTypes: [.normal, .dry],
            rating: 4.4,
            reviewCount: 743,
            size: "50ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Intensive hydration", "Strengthens skin barrier", "Suitable for sensitive skin"],
            howToUse: "Temiz cilde günde 1-2 kez uygulayın.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Dermatologically Tested", "Hypoallergenic"]
        ),
        
        // Serums
        Product(
            name: "Vitamin C Serum",
            brand: "Paula's Choice",
            category: .serum,
            price: 36.00,
            currency: "$",
            imageURL: nil,
            description: "C vitamini ile parlak ve eşit tonlu cilt için serum.",
            ingredients: ["Vitamin C", "Vitamin E", "Ferulic Acid"],
            skinTypes: [.normal, .dry, .combination],
            rating: 4.6,
            reviewCount: 1843,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Anti-aging", "Parlaklık", "Eşit ton"],
            howToUse: "Sabah temiz cilde uygulayın, güneş koruyucu kullanın.",
            warnings: ["May cause sun sensitivity", "Use sunscreen"],
            potentiallyIrritatingIngredients: ["Vitamin C", "Drying Alcohols"],
            certifications: ["Cruelty-free", "Vegan", "Dermatologically Tested"]
        ),
        
        Product(
            name: "Niacinamide 10% + Zinc 1%",
            brand: "The Ordinary",
            category: .serum,
            price: 8.90,
            currency: "$",
            imageURL: nil,
            description: "Gözenekleri küçültmek ve yağ kontrolü için niacinamide serumu.",
            ingredients: ["Niacinamide", "Zinc PCA"],
            skinTypes: [.oily, .combination],
            rating: 4.1,
            reviewCount: 3247,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Gözenek kontrolü", "Yağ azaltma", "Akne önleme"],
            howToUse: "Akşam temiz cilde uygulayın.",
            warnings: ["Do not use with vitamin C"],
            potentiallyIrritatingIngredients: ["Niacinamide"],
            certifications: ["Cruelty-free", "Vegan", "Non-comedogenic"]
        ),
        
        // Sunscreens
        Product(
            name: "Ultra Light Daily UV Defense",
            brand: "EltaMD",
            category: .sunscreen,
            price: 32.00,
            currency: "$",
            imageURL: nil,
            description: "Günlük kullanım için hafif ve hızlı emilen güneş koruyucu.",
            ingredients: ["Zinc Oxide", "Octinoxate", "Hyaluronic Acid"],
            skinTypes: [.normal, .dry],
            rating: 4.7,
            reviewCount: 1567,
            size: "48g",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: true,
            benefits: ["SPF 46", "Lightweight formula", "Suitable for sensitive skin"],
            howToUse: "Güneşe çıkmadan 15 dakika önce uygulayın.",
            warnings: ["Reapply every 2 hours"],
            potentiallyIrritatingIngredients: ["Chemical Sunscreens"],
            certifications: ["Cruelty-free", "Dermatologically Tested", "Hypoallergenic"]
        ),
        
        Product(
            name: "Clear Zinc Sunscreen",
            brand: "Neutrogena",
            category: .sunscreen,
            price: 11.99,
            currency: "$",
            imageURL: nil,
            description: "Akne eğilimli ciltler için berrak çinko oksit güneş koruyucu.",
            ingredients: ["Zinc Oxide", "Helioplex Technology"],
            skinTypes: [.oily, .combination],
            rating: 4.0,
            reviewCount: 892,
            size: "88ml",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: false,
            benefits: ["SPF 30", "Akne dostu", "Berrak formül"],
            howToUse: "Güneşe çıkmadan 15 dakika önce uygulayın.",
            warnings: ["Reapply every 2 hours"],
            potentiallyIrritatingIngredients: ["Chemical Sunscreens"],
            certifications: ["Cruelty-free", "Dermatologically Tested", "Hypoallergenic"]
        ),
        
        // Toners
        Product(
            name: "Glycolic Acid 7% Toning Solution",
            brand: "The Ordinary",
            category: .toner,
            price: 8.70,
            currency: "$",
            imageURL: nil,
            description: "Cilt yenileme ve parlaklık için glikolik asit toniği.",
            ingredients: ["Glycolic Acid", "Tasmanian Pepperberry"],
            skinTypes: [.normal, .combination, .oily],
            rating: 4.3,
            reviewCount: 2156,
            size: "240ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Cilt yenileme", "Parlaklık", "Gözenek temizliği"],
            howToUse: "Akşam temizlik sonrası pamukla uygulayın.",
            warnings: ["May cause sun sensitivity", "Use sunscreen"],
            potentiallyIrritatingIngredients: ["Vitamin C", "Drying Alcohols"],
            certifications: ["Cruelty-free", "Vegan", "Dermatologically Tested"]
        ),
        
        Product(
            name: "Rose Petal Witch Hazel Toner",
            brand: "Thayers",
            category: .toner,
            price: 9.95,
            currency: "$",
            imageURL: nil,
            description: "Gül yaprağı ve cadı fındığı ile doğal tonik.",
            ingredients: ["Witch Hazel", "Rose Petal", "Aloe Vera"],
            skinTypes: [.normal, .dry],
            rating: 4.2,
            reviewCount: 1847,
            size: "355ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: false,
            benefits: ["Doğal formül", "Yatıştırıcı", "Gözenek sıkılaştırma"],
            howToUse: "Temizlik sonrası pamukla uygulayın.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Dermatologically Tested", "Hypoallergenic"]
        ),
        
        // Exfoliants
        Product(
            name: "AHA 30% + BHA 2% Peeling Solution",
            brand: "The Ordinary",
            category: .exfoliant,
            price: 7.20,
            currency: "$",
            imageURL: nil,
            description: "Güçlü AHA ve BHA karışımı ile derin peeling çözeltisi.",
            ingredients: ["Glycolic Acid", "Salicylic Acid", "Tasmanian Pepperberry"],
            skinTypes: [.normal, .oily, .combination],
            rating: 4.4,
            reviewCount: 3247,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Derin temizlik", "Cilt yenileme", "Gözenek temizliği"],
            howToUse: "Haftada 1-2 kez, 10 dakika bekletip durulayın.",
            warnings: ["Strong formula", "Not suitable for sensitive skin", "Use sunscreen"],
            potentiallyIrritatingIngredients: ["Glycolic Acid", "Drying Alcohols"],
            certifications: ["Cruelty-free", "Vegan", "Dermatologically Tested"]
        ),
        
        // Masks
        Product(
            name: "Hydrating Face Mask",
            brand: "The Body Shop",
            category: .mask,
            price: 22.00,
            currency: "$",
            imageURL: nil,
            description: "Yoğun nemlendirme için krem mask.",
            ingredients: ["Hyaluronic Acid", "Shea Butter", "Vitamin E"],
            skinTypes: [.normal, .dry],
            rating: 4.1,
            reviewCount: 567,
            size: "75ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: false,
            benefits: ["Yoğun nemlendirme", "Yatıştırıcı", "Cilt yumuşatma"],
            howToUse: "Haftada 1-2 kez 10-15 dakika bekletip durulayın.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Dermatologically Tested", "Hypoallergenic"]
        ),
        
        // Eye Care
        Product(
            name: "Caffeine Solution 5% + EGCG",
            brand: "The Ordinary",
            category: .eyeCare,
            price: 6.70,
            currency: "$",
            imageURL: nil,
            description: "Göz altı torbaları ve koyu halkalar için kafein serumu.",
            ingredients: ["Caffeine", "EGCG", "Hyaluronic Acid"],
            skinTypes: [.normal, .dry],
            rating: 4.0,
            reviewCount: 1847,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Reduces under-eye bags", "Lightens dark circles", "Moisturizes"],
            howToUse: "Sabah ve akşam göz çevresine nazikçe uygulayın.",
            warnings: ["Avoid contact with eyes"],
            potentiallyIrritatingIngredients: ["Fragrances/Parfumes"],
            certifications: ["Cruelty-free", "Vegan", "Hypoallergenic"]
        ),
        
        // Lip Care
        Product(
            name: "Laneige Lip Sleeping Mask",
            brand: "Laneige",
            category: .lipCare,
            price: 20.00,
            currency: "$",
            imageURL: nil,
            description: "Gece kullanımı için yoğun dudak bakım maskesi.",
            ingredients: ["Berry Mix Complex", "Vitamin C", "Hyaluronic Acid"],
            skinTypes: [.normal, .dry],
            rating: 4.5,
            reviewCount: 2156,
            size: "20g",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: true,
            benefits: ["Yoğun nemlendirme", "Dudak yumuşatma", "Gece bakımı"],
            howToUse: "Gece yatmadan önce dudaklara uygulayın.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Dermatologically Tested", "Hypoallergenic"]
        )
    ]
}

// MARK: - Products ViewModel
@MainActor
class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories: [ProductCategory] = []
    @Published var selectedCategory: ProductCategory = .all
    @Published var query: String = ""
    @Published var isLoading: Bool = false
    
    init() {
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
}
import PhotosUI
import Vision

struct SurveyView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Modern Background
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Modern Header with Progress
                    ModernSurveyHeader(
                        title: viewModel.currentQuestion.title,
                        subtitle: viewModel.currentQuestion.subtitle,
                        progress: viewModel.progress,
                        currentQuestion: viewModel.currentQuestionIndex + 1,
                        totalQuestions: viewModel.totalQuestions,
                        showBackButton: viewModel.currentQuestionIndex > 0,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.previousQuestion()
                            }
                        },
                        geometry: geometry
                    )
                    
                    // Question Content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Modern Question Card
                            ModernQuestionCard(
                                viewModel: viewModel,
                                geometry: geometry
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                    
                    // Modern Bottom Button
                    ModernBottomButton(
                        title: viewModel.isLastQuestion ? "Complete Survey" : "Continue",
                        isEnabled: viewModel.canProceed,
                        isLastQuestion: viewModel.isLastQuestion
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if viewModel.isLastQuestion {
                                viewModel.completeSurvey()
                            } else {
                                viewModel.nextQuestion()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Modern Survey Components

struct ModernSurveyHeader: View {
    let title: String
    let subtitle: String
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
    let showBackButton: Bool
    let onBack: () -> Void
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 20) {
            // Top Navigation
            HStack {
                if showBackButton {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppTheme.creamWhite)
                                    .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                } else {
                    Spacer()
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
                
                // Progress Indicator
                HStack(spacing: 4) {
                    ForEach(0..<totalQuestions, id: \.self) { index in
                        Circle()
                            .fill(index < currentQuestion ? AppTheme.softPink : AppTheme.softPink.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                
                Spacer()
                
                // Close button placeholder
                Spacer()
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Title and Subtitle
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTheme.Typography.surveyTitle)
                    .foregroundColor(AppTheme.darkCharcoal)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(subtitle)
                    .font(AppTheme.Typography.surveySubtitle)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 10)
    }
}

struct ModernQuestionCard: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 0) {
            // Question Content
            VStack(spacing: 24) {
                switch viewModel.currentQuestion.type {
                case .textInput:
                    ModernNameQuestionView(viewModel: viewModel, geometry: geometry)
                case .singleChoice:
                    if viewModel.currentQuestion.id == 2 {
                        ModernAgeQuestionView(viewModel: viewModel, geometry: geometry)
                    } else {
                        ModernSkinTypeQuestionView(viewModel: viewModel, geometry: geometry)
                    }
                case .multipleChoice:
                    if viewModel.currentQuestion.id == 4 {
                        ModernSensitivityQuestionView(viewModel: viewModel, geometry: geometry)
                    } else if viewModel.currentQuestion.id == 5 {
                        ModernSkinConcernsQuestionView(viewModel: viewModel, geometry: geometry)
                    } else if viewModel.currentQuestion.id == 6 {
                        ModernAvoidIngredientsQuestionView(viewModel: viewModel, geometry: geometry)
                    } else if viewModel.currentQuestion.id == 7 {
                        ModernPregnancyQuestionView(viewModel: viewModel, geometry: geometry)
                    } else {
                        ModernSkinConcernsQuestionView(viewModel: viewModel, geometry: geometry)
                    }
                case .budgetSelection:
                    ModernBudgetQuestionView(viewModel: viewModel, geometry: geometry)
                }
            }
            .padding(24)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.cardGradient)
                .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
        )
    }
}

struct ModernBottomButton: View {
    let title: String
    let isEnabled: Bool
    let isLastQuestion: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(.white)
                
                if !isLastQuestion {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isEnabled ? AppTheme.softPink : AppTheme.darkCharcoal.opacity(0.3))
            )
        }
        .disabled(!isEnabled)
        .scaleEffect(isEnabled ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

#Preview {
    SurveyView(viewModel: SurveyViewModel())
}
