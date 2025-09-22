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

// MARK: - Face Analysis View
struct FaceAnalysisView: View {
    @StateObject private var viewModel = FaceAnalysisViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingSkinReport = false
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.92, blue: 0.98),
                        Color(red: 0.98, green: 0.96, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView(geometry: geometry)
                    
                    // Camera Preview
                    cameraPreviewView(geometry: geometry)
                    
                    // Tips
                    tipsView(geometry: geometry)
                    
                    // Bottom Controls
                    bottomControlsView(geometry: geometry)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.checkPermissions()
        }
        .sheet(isPresented: $viewModel.showingPhotoPicker) {
            PhotoPicker(selectedImage: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.showingConsentSheet) {
            ConsentSheet(
                image: viewModel.capturedImage,
                onConfirm: {
                    viewModel.startAnalysis()
                }
            )
        }
        .alert("Camera Access Required", isPresented: $viewModel.showingPermissionAlert) {
            Button("Settings") {
                viewModel.openSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable camera access in Settings to analyze your skin.")
        }
        .fullScreenCover(isPresented: $viewModel.showingSkinReport) {
            SkinReportView(surveyViewModel: surveyViewModel)
        }
    }
    
    // MARK: - Header View
    private func headerView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.008) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: geometry.size.height * 0.025, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                .accessibilityLabel("Back")
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, geometry.size.height * 0.02)
            
            VStack(spacing: geometry.size.height * 0.006) {
                Text("Analyze Your Skin with AI")
                    .font(.system(size: geometry.size.height * 0.028, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Get personalized skincare recommendations in seconds.")
                    .font(.system(size: geometry.size.height * 0.016))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Camera Preview View
    private func cameraPreviewView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            ZStack {
                // Camera preview container
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                if let image = viewModel.capturedImage ?? viewModel.selectedImage {
                    // Show captured or selected image
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(24)
                } else if viewModel.cameraPermissionGranted {
                    // Camera preview
                    CameraPreviewView(session: viewModel.cameraSession)
                        .cornerRadius(24)
                } else {
                    // Permission denied state
                    permissionDeniedView(geometry: geometry)
                }
                
                // Face guidance overlay
                if viewModel.capturedImage == nil && viewModel.selectedImage == nil && viewModel.cameraPermissionGranted {
                    FaceGuidanceOverlay(
                        isFaceDetected: viewModel.isFaceDetected,
                        geometry: geometry
                    )
                }
            }
            .frame(height: geometry.size.height * 0.5)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Permission Denied View
    private func permissionDeniedView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            Image(systemName: "camera.fill")
                .font(.system(size: geometry.size.height * 0.08))
                .foregroundColor(AppTheme.textSecondary)
            
            Text("Enable Camera Access")
                .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Camera access is required to analyze your skin.")
                .font(.system(size: geometry.size.height * 0.016))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Tips View
    private func tipsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.008) {
            Text("Good lighting, remove glasses, keep hair away from face.")
                .font(.system(size: geometry.size.height * 0.014))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Hold still for 2–3 seconds.")
                .font(.system(size: geometry.size.height * 0.014))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .padding(.top, geometry.size.height * 0.02)
    }
    
    // MARK: - Bottom Controls View
    private func bottomControlsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            // Camera controls
            HStack(spacing: geometry.size.width * 0.06) {
                // Left button (Upload or Retake)
                Button(action: {
                    if viewModel.capturedImage != nil || viewModel.selectedImage != nil {
                        viewModel.retakePhoto()
                    } else {
                        viewModel.showPhotoPicker()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: (viewModel.capturedImage != nil || viewModel.selectedImage != nil) ? "arrow.clockwise" : "photo.on.rectangle")
                            .font(.system(size: geometry.size.width * 0.06, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                }
                .accessibilityLabel((viewModel.capturedImage != nil || viewModel.selectedImage != nil) ? "Retake" : "Upload from Library")
                
                // Center shutter button
                Button(action: {
                    if viewModel.capturedImage != nil {
                        viewModel.confirmPhoto()
                    } else {
                        viewModel.capturePhoto()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(viewModel.capturedImage != nil ? AppTheme.primaryColor : Color(red: 0.8, green: 0.7, blue: 0.9))
                            .frame(width: geometry.size.width * 0.19, height: geometry.size.width * 0.19)
                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: viewModel.capturedImage != nil ? "checkmark" : "camera.fill")
                            .font(.system(size: geometry.size.width * 0.08, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!viewModel.cameraPermissionGranted && viewModel.capturedImage == nil)
                .accessibilityLabel(viewModel.capturedImage != nil ? "Use Photo" : "Take Photo")
                
                // Right button (Flip camera or placeholder)
                Button(action: {
                    viewModel.flipCamera()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "camera.rotate")
                            .font(.system(size: geometry.size.width * 0.06, weight: .medium))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                }
                .disabled(viewModel.capturedImage != nil)
                .accessibilityLabel("Flip Camera")
            }
            
            // Analyze button (shown when image is selected) - positioned below camera controls
            if viewModel.capturedImage != nil || viewModel.selectedImage != nil {
                Button(action: {
                    viewModel.startAnalysis()
                }) {
                    HStack(spacing: geometry.size.width * 0.02) {
                        Image(systemName: "sparkles")
                            .font(.system(size: geometry.size.width * 0.045, weight: .medium))
                        Text("Analyze")
                            .font(.system(size: geometry.size.width * 0.045, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.06)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("PrimaryColor"), Color("SecondaryColor")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(geometry.size.height * 0.03)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: viewModel.capturedImage != nil || viewModel.selectedImage != nil)
            }
        }
        .padding(.horizontal, geometry.size.width * 0.05)
        .padding(.bottom, geometry.size.height * 0.04)
    }
}

// MARK: - Face Analysis ViewModel
@MainActor
class FaceAnalysisViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var cameraPermissionGranted = false
    @Published var isFaceDetected = false
    @Published var capturedImage: UIImage?
    @Published var selectedImage: UIImage?
    @Published var showingPhotoPicker = false
    @Published var showingConsentSheet = false
    @Published var showingPermissionAlert = false
    @Published var isAnalyzing = false
    @Published var showingSkinReport = false
    
    // MARK: - Camera Properties
    let cameraSession = AVCaptureSession()
    private var videoOutput = AVCaptureVideoDataOutput()
    private var photoOutput = AVCapturePhotoOutput()
    private var currentCamera: AVCaptureDevice?
    private var isFrontCamera = true
    
    // MARK: - Face Detection
    private let faceDetectionRequest = VNDetectFaceLandmarksRequest { request, error in
        // Handle face detection results
    }
    
    override init() {
        super.init()
        setupCameraSession()
    }
    
    // MARK: - Permission Handling
    func checkPermissions() {
        #if targetEnvironment(simulator)
        // Simulator'da kamera çalışmaz, sadece photo picker kullanılabilir
        cameraPermissionGranted = false
        #else
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
            startCameraSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraPermissionGranted = granted
                    if granted {
                        self?.startCameraSession()
                    }
                }
            }
        case .denied, .restricted:
            cameraPermissionGranted = false
        @unknown default:
            cameraPermissionGranted = false
        }
        #endif
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    // MARK: - Camera Session Setup
    private func setupCameraSession() {
        #if targetEnvironment(simulator)
        // Simulator'da kamera session kurulmaz
        print("Camera session not available in simulator")
        return
        #else
        cameraSession.sessionPreset = .high
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get front camera")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if cameraSession.canAddInput(videoInput) {
                cameraSession.addInput(videoInput)
                currentCamera = videoDevice
            }
        } catch {
            print("Failed to create video input: \(error)")
        }
        
        // Add photo output
        if cameraSession.canAddOutput(photoOutput) {
            cameraSession.addOutput(photoOutput)
        }
        
        // Add video output for face detection
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))
        if cameraSession.canAddOutput(videoOutput) {
            cameraSession.addOutput(videoOutput)
        }
        #endif
    }
    
    private func startCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraSession.startRunning()
        }
    }
    
    private func stopCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.cameraSession.stopRunning()
        }
    }
    
    // MARK: - Camera Controls
    func flipCamera() {
        #if targetEnvironment(simulator)
        // Simulator'da kamera flip çalışmaz
        print("Camera flip not available in simulator")
        #else
        guard let currentInput = cameraSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .front ? .back : .front
        guard let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            cameraSession.beginConfiguration()
            cameraSession.removeInput(currentInput)
            
            if cameraSession.canAddInput(newInput) {
                cameraSession.addInput(newInput)
                currentCamera = newCamera
                isFrontCamera = newPosition == .front
            }
            
            cameraSession.commitConfiguration()
        } catch {
            print("Failed to flip camera: \(error)")
        }
        #endif
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        #if targetEnvironment(simulator)
        // Simulator'da fotoğraf çekme çalışmaz, photo picker'ı aç
        showPhotoPicker()
        #else
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
    
    func retakePhoto() {
        capturedImage = nil
        selectedImage = nil
    }
    
    func confirmPhoto() {
        showingConsentSheet = true
    }
    
    func showPhotoPicker() {
        showingPhotoPicker = true
    }
    
    // MARK: - Analysis
    func startAnalysis() {
        guard let image = capturedImage ?? selectedImage else { return }
        
        isAnalyzing = true
        
        // Simulate analysis delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isAnalyzing = false
            self?.analyzeSkin(image: image)
        }
    }
    
    private func analyzeSkin(image: UIImage) {
        // TODO: Implement actual skin analysis
        print("Analyzing skin with image: \(image.size)")
        
        // For now, just print the analysis
        print("Skin analysis completed")
        
        // Navigate to skin report after analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showingSkinReport = true
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension FaceAnalysisViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            DispatchQueue.main.async {
                self?.isFaceDetected = !(request.results?.isEmpty ?? true)
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension FaceAnalysisViewModel: AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to create image from photo data")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
        }
    }
}

// MARK: - Camera Preview View
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

// MARK: - Face Guidance Overlay
struct FaceGuidanceOverlay: View {
    let isFaceDetected: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Corner brackets
            VStack {
                HStack {
                    cornerBracket(.topLeft)
                    Spacer()
                    cornerBracket(.topRight)
                }
                Spacer()
                HStack {
                    cornerBracket(.bottomLeft)
                    Spacer()
                    cornerBracket(.bottomRight)
                }
            }
            .padding(40)
            
            // Face landmarks (simplified dots)
            if isFaceDetected {
                faceLandmarksView
            }
            
            // Alignment hint
            if !isFaceDetected {
                VStack {
                    Spacer()
                    Text("Center your face in the frame.")
                        .font(.system(size: geometry.size.height * 0.016, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                        .padding(.bottom, 60)
                }
            }
        }
    }
    
    private func cornerBracket(_ corner: UIRectCorner) -> some View {
        Path { path in
            let size: CGFloat = 30
            let thickness: CGFloat = 2
            
            switch corner {
            case .topLeft:
                path.move(to: CGPoint(x: 0, y: thickness))
                path.addLine(to: CGPoint(x: size, y: thickness))
                path.move(to: CGPoint(x: thickness, y: 0))
                path.addLine(to: CGPoint(x: thickness, y: size))
            case .topRight:
                path.move(to: CGPoint(x: -size, y: thickness))
                path.addLine(to: CGPoint(x: 0, y: thickness))
                path.move(to: CGPoint(x: -thickness, y: 0))
                path.addLine(to: CGPoint(x: -thickness, y: size))
            case .bottomLeft:
                path.move(to: CGPoint(x: 0, y: -thickness))
                path.addLine(to: CGPoint(x: size, y: -thickness))
                path.move(to: CGPoint(x: thickness, y: -size))
                path.addLine(to: CGPoint(x: thickness, y: 0))
            case .bottomRight:
                path.move(to: CGPoint(x: -size, y: -thickness))
                path.addLine(to: CGPoint(x: 0, y: -thickness))
                path.move(to: CGPoint(x: -thickness, y: -size))
                path.addLine(to: CGPoint(x: -thickness, y: 0))
            default:
                break
            }
        }
        .stroke(Color.white.opacity(0.8), lineWidth: 2)
        .frame(width: 30, height: 30)
    }
    
    private var faceLandmarksView: some View {
        // Simplified face landmarks as dots
        ZStack {
            // Forehead dots
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 2) * 20, y: -80)
            }
            
            // Eye dots
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 15 - 30, y: -40) // Left eye
                
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 15 + 30, y: -40) // Right eye
            }
            
            // Nose dots
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 10, y: CGFloat(i - 1) * 15)
            }
            
            // Mouth dots
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 2) * 15, y: 30)
            }
        }
    }
}

// MARK: - Photo Picker
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

// MARK: - Consent Sheet
struct ConsentSheet: View {
    let image: UIImage?
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var analyzeOnDevice = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your photo is used to analyze skin concerns. We don't share it with third parties.")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Toggle("Analyze on device when possible", isOn: $analyzeOnDevice)
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    onConfirm()
                    dismiss()
                }) {
                    Text("Start Analysis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppTheme.primaryColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Review & Consent")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Skin Report Color Constants
struct SkinReportColors {
    static let lowBackground = Color(hex: "E8F5E9")
    static let moderateBackground = Color(hex: "FFF9E6")
    static let highBackground = Color(hex: "FFE5E5")
    static let skinTypeBackground = Color(hex: "F5F5F5")
    
    static let lowDot = Color(hex: "4CAF50")
    static let moderateDot = Color(hex: "FFC107")
    static let highDot = Color(hex: "F44336")
    static let greyDot = Color(hex: "C8C8C8")
    
    static let descriptionText = Color(hex: "333333").opacity(0.8)
    static let white = Color.white
}

// MARK: - Severity Level Enum
enum SeverityLevel: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    
    var backgroundColor: Color {
        switch self {
        case .low: return SkinReportColors.lowBackground
        case .moderate: return SkinReportColors.moderateBackground
        case .high: return SkinReportColors.highBackground
        }
    }
    
    var dotColors: [Color] {
        switch self {
        case .low: return [SkinReportColors.lowDot, SkinReportColors.greyDot, SkinReportColors.greyDot]
        case .moderate: return [SkinReportColors.moderateDot, SkinReportColors.moderateDot, SkinReportColors.greyDot]
        case .high: return [SkinReportColors.highDot, SkinReportColors.highDot, SkinReportColors.highDot]
        }
    }
}

// MARK: - Skin Metric Model
struct SkinMetric: Identifiable {
    let id: String
    let title: String
    let description: String
    var severity: SeverityLevel?
    let isEditable: Bool
    
    init(id: String, title: String, description: String, severity: SeverityLevel? = nil, isEditable: Bool = true) {
        self.id = id
        self.title = title
        self.description = description
        self.severity = severity
        self.isEditable = isEditable
    }
}

// MARK: - User Profile Store
class UserProfileStore: ObservableObject {
    @Published var skinMetrics: [SkinMetric] = []
    @Published var skinTypeLabel: String = ""
    
    func saveSkinMetrics(_ metrics: [SkinMetric], skinType: String) {
        // TODO: Connect to real storage (Core Data, UserDefaults, API, etc.)
        self.skinMetrics = metrics
        self.skinTypeLabel = skinType
        print("Skin metrics saved to profile: \(metrics.count) metrics, skin type: \(skinType)")
    }
}

// MARK: - Severity Dots View Component
struct SeverityDotsView: View {
    let severity: SeverityLevel
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(severity.dotColors[index])
                    .frame(width: 6, height: 6)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Updated Skin Report View Model
final class SkinReportViewModel: ObservableObject {
    @Published var metrics: [SkinMetric] = []
    @Published var skinTypeLabel: String = "Combination"
    @Published var isEditing: Bool = false
    @Published var hasEditedAtLeastOne: Bool = false
    @Published var showingFeedbackSheet: Bool = false
    @Published var showingSuccessOverlay: Bool = false
    
    private let userProfileStore = UserProfileStore()
    
    init() {
        loadInitialData()
    }
    
    private func loadInitialData() {
        // Initialize with default metrics
        metrics = [
            SkinMetric(id: "skin_sensitivity", title: "Skin Sensitivity", description: "Irritation and redness are unlikely.", severity: .low),
            SkinMetric(id: "acne", title: "Acne", description: "Breakouts are minimal.", severity: .low),
            SkinMetric(id: "tzone_oiliness", title: "T-zone Oiliness", description: "Your forehead, nose, and chin have some shine.", severity: .moderate),
            SkinMetric(id: "dryness", title: "Dryness", description: "Your skin might feel slightly tight.", severity: .moderate),
            SkinMetric(id: "wrinkles", title: "Wrinkles & Fine Lines", description: "Lines and wrinkles are noticeable.", severity: .high),
            SkinMetric(id: "blackheads", title: "Blackheads", description: "Clogged pores are evident.", severity: .high),
            SkinMetric(id: "redness", title: "Redness", description: "Visible redness on cheeks or other areas.", severity: .low),
            SkinMetric(id: "under_eye_puffiness", title: "Under-Eye Puffiness", description: "Slight puffiness under the eyes.", severity: .low)
        ]
    }
    
    func updateSeverity(for id: String, to newValue: SeverityLevel) {
        if let index = metrics.firstIndex(where: { $0.id == id }) {
            let oldValue = metrics[index].severity
            metrics[index].severity = newValue
            
            // Track if at least one change was made
            if oldValue != newValue {
                hasEditedAtLeastOne = true
                // Analytics event
                print("Analytics: results_edit_changed - metric: \(id), new_value: \(newValue.rawValue)")
            }
        }
    }
    
    func acceptAutoResultsAndSave() {
        userProfileStore.saveSkinMetrics(metrics, skinType: skinTypeLabel)
        showingSuccessOverlay = true
        // Analytics event
        print("Analytics: results_feedback_satisfied")
        
        // Set home tab as default for next app launch
        UserDefaults.standard.set(AppTab.home.rawValue, forKey: "lastTab")
        
        // Navigate to main page after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showingSuccessOverlay = false
            // Navigation will be handled by SurveyViewModel
        }
    }
    
    func saveEditedResults() {
        userProfileStore.saveSkinMetrics(metrics, skinType: skinTypeLabel)
        isEditing = false
        hasEditedAtLeastOne = false
        showingSuccessOverlay = true
        // Analytics event
        print("Analytics: results_profile_completed")
        
        // Set home tab as default for next app launch
        UserDefaults.standard.set(AppTab.home.rawValue, forKey: "lastTab")
        
        // Navigate to main page after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showingSuccessOverlay = false
            // Navigation will be handled by SurveyViewModel
        }
    }
    
    func showFeedbackSheet() {
        showingFeedbackSheet = true
        // Analytics event
        print("Analytics: results_feedback_prompt_opened")
    }
    
    func handleFeedbackSatisfied() {
        showingFeedbackSheet = false
        acceptAutoResultsAndSave()
        // Navigation will be handled by SurveyViewModel
    }
    
    func handleFeedbackNotSatisfied() {
        showingFeedbackSheet = false
        isEditing = true
        // Analytics event
        print("Analytics: results_feedback_not_satisfied")
    }
    
    func deleteMetric(withId id: String) {
        metrics.removeAll { $0.id == id }
        // Analytics event
        print("Analytics: results_metric_deleted - metric: \(id)")
    }
}

// MARK: - Skin Report Card Component
struct SkinReportCard: View {
    let metric: SkinMetric
    let skinTypeValue: String?
    let isEditing: Bool
    let onSeverityChange: ((SeverityLevel) -> Void)?
    
    init(metric: SkinMetric, skinTypeValue: String? = nil, isEditing: Bool = false, onSeverityChange: ((SeverityLevel) -> Void)? = nil) {
        self.metric = metric
        self.skinTypeValue = skinTypeValue
        self.isEditing = isEditing
        self.onSeverityChange = onSeverityChange
    }
    
    private var isSkinType: Bool {
        return metric.id == "skin_type"
    }
    
    // Emoji for each skin concern
    private var titleEmoji: String {
        switch metric.title.lowercased() {
        case "skin type":
            return "🧴" // Su damlası - cilt tipini temsil eder
        case "skin sensitivity":
            return "⚠️" // Uyarı işareti - hassasiyeti temsil eder
        case "acne":
            return "🐛" // Uğur böceği - sivilceyi temsil eder
        case "t-zone oiliness":
            return "💧" // Su damlası - yağlılığı temsil eder
        case "dryness":
            return "🏜️" // Kurak toprak - kuruluğu temsil eder
        case "wrinkles & fine lines":
            return "📏" // Cetvel - kırışıklıkları temsil eder
        case "blackheads":
            return "🔲" // Kare - gözenek tıkanıklığını temsil eder
        case "redness":
            return "❤️" // Kalp - kızarıklığı temsil eder
        case "under-eye puffiness":
            return "👁️" // Göz - göz altı şişliğini temsil eder
        default:
            return "🔍" // Büyüteç - genel analiz
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row
            HStack {
                // Left: Emoji + Category title
                HStack(spacing: 8) {
                    Text(titleEmoji)
                        .font(.system(size: 18))
                    
                    Text(metric.title.uppercased())
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Right: Severity control or skin type value
                if isSkinType {
                    Text(skinTypeValue ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                } else if let severity = metric.severity {
                    if isEditing && metric.isEditable {
                        // Editable severity control
                        HStack(spacing: 8) {
                            Text(severity.rawValue)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Button(action: {
                                cycleSeverity()
                            }) {
                                HStack(spacing: 4) {
                                    SeverityDotsView(severity: severity)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 10))
                                        .foregroundColor(.black.opacity(0.6))
                                }
                            }
                            .accessibilityLabel("\(metric.title), severity \(severity.rawValue), adjustable")
                        }
                    } else {
                        // Read-only severity display
                        HStack(spacing: 8) {
                            Text(severity.rawValue)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                            
                            SeverityDotsView(severity: severity)
                        }
                    }
                }
            }
            
            // Description text
            Text(metric.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(SkinReportColors.descriptionText)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSkinType ? SkinReportColors.skinTypeBackground : (metric.severity?.backgroundColor ?? SkinReportColors.skinTypeBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func cycleSeverity() {
        guard let currentSeverity = metric.severity else { return }
        
        let allSeverities = SeverityLevel.allCases
        if let currentIndex = allSeverities.firstIndex(of: currentSeverity) {
            let nextIndex = (currentIndex + 1) % allSeverities.count
            let newSeverity = allSeverities[nextIndex]
            onSeverityChange?(newSeverity)
        }
    }
}

// MARK: - Feedback Sheet View
struct FeedbackSheetView: View {
    let onSatisfied: () -> Void
    let onNotSatisfied: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("About Results")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top, 16)
                
                // Message
                Text("Sometimes it's not possible to determine the analysis completely accurately from just one photo :) If you're not satisfied, would you like to make adjustments to the analysis results and complete your profile?")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    // Primary button - Not Satisfied
                    PrimaryButton("Not Satisfied") {
                        dismiss()
                        onNotSatisfied()
                    }
                    
                    // Secondary button - Satisfied
                    SecondaryButton(title: "Satisfied", action: {
                        dismiss()
                        onSatisfied()
                    })
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(AppTheme.backgroundColor)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Success Overlay View
struct SuccessOverlayView: View {
    @State private var showFireworks = false
    
    var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Success text
                Text("Profile saved successfully!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Firework animation
                if showFireworks {
                    FireworkAnimationView()
                        .frame(width: 200, height: 200)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                showFireworks = true
            }
        }
    }
}

// MARK: - Firework Animation View
struct FireworkAnimationView: View {
    @State private var particles: [FireworkParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createFireworks()
        }
    }
    
    private func createFireworks() {
        // Create multiple firework bursts
        for _ in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.5)) {
                createFireworkBurst()
            }
        }
    }
    
    private func createFireworkBurst() {
        let center = CGPoint(x: 100, y: 100)
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
        
        for i in 0..<20 {
            let angle = Double(i) * (2 * .pi / 20)
            let distance = Double.random(in: 30...80)
            let endX = center.x + cos(angle) * distance
            let endY = center.y + sin(angle) * distance
            
            let particle = FireworkParticle(
                id: UUID(),
                position: center,
                endPosition: CGPoint(x: endX, y: endY),
                color: colors.randomElement() ?? .red,
                size: Double.random(in: 3...8)
            )
            
            particles.append(particle)
            
            // Animate particle
            withAnimation(.easeOut(duration: 1.5)) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].position = particle.endPosition
                    particles[index].opacity = 0
                }
            }
        }
    }
}

// MARK: - Firework Particle Model
struct FireworkParticle: Identifiable {
    let id: UUID
    var position: CGPoint
    let endPosition: CGPoint
    let color: Color
    let size: Double
    var opacity: Double = 1.0
}

// MARK: - Skin Report View
struct SkinReportView: View {
    @StateObject private var viewModel = SkinReportViewModel()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        ZStack {
            // Pastel gradient background
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
                // Header
                HStack {
                    Text("Your Skin Report")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundColor(SkinReportColors.white)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(SkinReportColors.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Content cards
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 12) {
                        // Skin Type Card (non-editable)
                        SkinReportCard(
                            metric: SkinMetric(
                                id: "skin_type",
                                title: "Skin Type",
                                description: "Your skin is both oily and dry in different areas.",
                                isEditable: false
                            ),
                            skinTypeValue: viewModel.skinTypeLabel,
                            isEditing: false
                        )
                        
                        // Editable metrics
                        ForEach(viewModel.metrics) { metric in
                            SkinReportCard(
                                metric: metric,
                                isEditing: viewModel.isEditing,
                                onSeverityChange: { newSeverity in
                                    viewModel.updateSeverity(for: metric.id, to: newSeverity)
                                }
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if viewModel.isEditing && metric.isEditable {
                                    Button(role: .destructive) {
                                        viewModel.deleteMetric(withId: metric.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Extra padding for bottom button
                }
                
                // Bottom sticky button
                VStack(spacing: 0) {
                    // Action button
                    PrimaryButton(
                        viewModel.isEditing ? "Complete Profile" : "Are you satisfied with the results?",
                        isEnabled: true
                    ) {
                        if viewModel.isEditing {
                            viewModel.saveEditedResults()
                            // Navigate to main app after saving
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                surveyViewModel.navigateToMainPage = true
                            }
                        } else {
                            viewModel.showFeedbackSheet()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.9, green: 0.85, blue: 0.95), // Lavender
                                    Color(red: 0.95, green: 0.9, blue: 0.85)  // Peach-pink
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
                )
            }
        }
        .sheet(isPresented: $viewModel.showingFeedbackSheet) {
            FeedbackSheetView(
                onSatisfied: {
                    viewModel.handleFeedbackSatisfied()
                    // Navigate to main app after feedback
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        surveyViewModel.navigateToMainPage = true
                    }
                },
                onNotSatisfied: {
                    viewModel.handleFeedbackNotSatisfied()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .overlay(
            Group {
                if viewModel.showingSuccessOverlay {
                    SuccessOverlayView()
                        .transition(.opacity)
                }
            }
        )
        .animation(.easeInOut(duration: 0.3), value: viewModel.showingSuccessOverlay)
        .fullScreenCover(isPresented: $surveyViewModel.navigateToMainPage) {
            MainTabContainerView(surveyViewModel: surveyViewModel)
        }
    }
}

// MARK: - Routine Step Model
struct RoutineStep: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var isCompleted: Bool
    
    static let morningSteps = [
        RoutineStep(name: "Cleanser", icon: "drop.fill", isCompleted: true),
        RoutineStep(name: "Serum", icon: "eyedropper", isCompleted: true),
        RoutineStep(name: "Moisturizer", icon: "leaf.fill", isCompleted: true),
        RoutineStep(name: "SPF", icon: "sun.max.fill", isCompleted: true)
    ]
    
    static let eveningSteps = [
        RoutineStep(name: "Cleanser", icon: "drop.fill", isCompleted: false),
        RoutineStep(name: "Serum", icon: "eyedropper", isCompleted: false),
        RoutineStep(name: "Moisturizer", icon: "leaf.fill", isCompleted: false),
        RoutineStep(name: "Night Cream", icon: "moon.fill", isCompleted: false)
    ]
}

// MARK: - Routine Checkpoint View
struct RoutineCheckpointView: View {
    @ObservedObject var routineTracker: RoutineTrackerViewModel
    @State private var selectedTab: RoutineCheckpoint.RoutineType = .morning
    @State private var routineSteps: [RoutineStep] = RoutineStep.morningSteps
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection
            
            // Main Content
            mainContentSection
            
            // Bottom Section
            bottomSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Routine")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                // Progress dots
                HStack(spacing: 6) {
                    ForEach(0..<2) { index in
                        Circle()
                            .fill(index == 0 ? Color(hex: "10B981") : Color(hex: "E5E7EB"))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            // Tab Selector
            HStack(spacing: 0) {
                ForEach(RoutineCheckpoint.RoutineType.allCases, id: \.self) { routineType in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = routineType
                            routineSteps = routineType == .morning ? RoutineStep.morningSteps : RoutineStep.eveningSteps
                        }
                    }) {
                        Text(routineType.rawValue.replacingOccurrences(of: " Routine", with: ""))
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedTab == routineType ? Color(hex: "1F2937") : Color(hex: "6B7280"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedTab == routineType ? Color(hex: "D1FAE5") : Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "F3F4F6"))
            )
        }
    }
    
    // MARK: - Main Content Section
    private var mainContentSection: some View {
        HStack(spacing: 20) {
            // Left Side - Routine Steps
            VStack(alignment: .leading, spacing: 12) {
                ForEach(routineSteps) { step in
                    routineStepRow(step: step)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Right Side - Progress Circle
            progressCircleView
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Routine Step Row
    private func routineStepRow(step: RoutineStep) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                if let index = routineSteps.firstIndex(where: { $0.id == step.id }) {
                    routineSteps[index].isCompleted.toggle()
                }
            }
        }) {
            HStack(spacing: 12) {
                // Icon with checkmark
            ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(step.isCompleted ? Color(hex: "D1FAE5") : Color(hex: "F3F4F6"))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: step.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(step.isCompleted ? Color(hex: "10B981") : Color(hex: "9CA3AF"))
                    
                    if step.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "10B981"))
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: 12, y: -12)
                    }
                }
                
                Text(step.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(step.isCompleted ? Color(hex: "10B981") : Color(hex: "374151"))
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Progress Circle View
    private var progressCircleView: some View {
        let completedCount = routineSteps.filter { $0.isCompleted }.count
        let totalCount = routineSteps.count
        let progress = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0.0
        
        return ZStack {
            // Background circle
            Circle()
                .stroke(Color(hex: "E5E7EB"), lineWidth: 8)
                .frame(width: 80, height: 80)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color(hex: "10B981"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
            
            // Progress text
            VStack(spacing: 2) {
                Text("\(completedCount)/\(totalCount)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "1F2937"))
                
                Text("steps")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
            }
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            // Bottom navigation buttons
            HStack(spacing: 12) {
                compactBottomButton(title: "Spotify", icon: "music.note", gradientColors: [Color(hex: "1DB954"), Color(hex: "1ED760")])
                compactBottomButton(title: "Radio", icon: "radio", gradientColors: [Color(hex: "8B5CF6"), Color(hex: "A855F7")])
                compactBottomButton(title: "Daily news", icon: "newspaper", gradientColors: [Color(hex: "3B82F6"), Color(hex: "60A5FA")])
                compactBottomButton(title: "Mindfulness", icon: "brain.head.profile", gradientColors: [Color(hex: "6366F1"), Color(hex: "818CF8")])
            }
        }
    }
    
    // MARK: - Compact Bottom Button with Internal Text
    private func compactBottomButton(title: String, icon: String, gradientColors: [Color]) -> some View {
        Button(action: {
            // Handle button action
        }) {
            VStack(spacing: 4) {
                // Icon container
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(
                            color: gradientColors.first?.opacity(0.3) ?? Color.clear,
                            radius: 6,
                            x: 0,
                            y: 3
                        )
                    
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Text inside the button area
                Text(title)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 60)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
    
    // MARK: - Modern Bottom Button (Legacy)
    private func modernBottomButton(title: String, icon: String, gradientColors: [Color]) -> some View {
        Button(action: {
            // Handle button action
        }) {
            VStack(spacing: 6) {
                // Icon with subtle shadow
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 28, height: 28)
                        .blur(radius: 1)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Title with better typography
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: 24) // Fixed height for text
            }
            .frame(maxWidth: .infinity, minHeight: 80) // Fixed minimum height
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: gradientColors.first?.opacity(0.3) ?? Color.clear,
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
    
    // MARK: - Legacy Bottom Button (kept for compatibility)
    private func bottomButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {
            // Handle button action
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Main Page View
struct MainPageView: View {
    @StateObject private var viewModel = MainPageViewModel()
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Transparent blur background
                Rectangle()
                    .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Greeting Header
                    greetingHeader
                
                                            ScrollView {
                                VStack(spacing: 20) {
                                    // Add Routine Panel - Only show for new users
                                    if surveyViewModel.isNewUser {
                                    RoutinePanelView()
                                    }
                            
                                    // Today's Routine Panel - Show for both new and existing users
                                    RoutineCheckpointView(routineTracker: viewModel.routineTracker)
                                    
                                    // Environmental Panels - Show for both new and existing users
                                    HStack(spacing: 16) {
                                        UVIndexPanelView(uvIndex: viewModel.uvIndex)
                                            .frame(maxWidth: .infinity)
                                        
                                        HumidityPanelView(humidity: viewModel.humidity)
                                            .frame(maxWidth: .infinity)
                                    }
                                    
                                    PollutionPanelView(pollutionLevel: viewModel.pollutionLevel)
                                }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Skincare & Rituals")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchEnvironmentalData()
        }
    }
    
    // MARK: - Greeting Header
    private var greetingHeader: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(getGreetingMessage())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "2D3748"))
                    
                    Text("Ready for your skincare routine?")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "6B7280"))
                }
                
                Spacer()
                
                // Decorative icon
                Image(systemName: getGreetingIcon())
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "8B5CF6"))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.3))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
        .background(
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .blur(radius: 1)
        )
    }
    
    // MARK: - Helper Functions
    private func getGreetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning, Beyza"
        case 12..<17:
            return "Good Afternoon, Beyza"
        case 17..<22:
            return "Good Evening, Beyza"
        default:
            return "Good Night, Beyza"
        }
    }
    
    private func getGreetingIcon() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "sun.max.fill"
        case 12..<17:
            return "sun.max"
        case 17..<22:
            return "sunset.fill"
        default:
            return "moon.stars.fill"
        }
    }
}

// MARK: - Routine Checkpoint Model
struct RoutineCheckpoint: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let routineType: RoutineType
    var isCompleted: Bool
    
    enum RoutineType: String, CaseIterable, Codable {
        case morning = "Morning Routine"
        case evening = "Evening Routine"
        
        var icon: String {
            switch self {
            case .morning:
                return "sun.max.fill"
            case .evening:
                return "moon.stars.fill"
            }
        }
        
        var color: String {
            switch self {
            case .morning:
                return "F59E0B"
            case .evening:
                return "8B5CF6"
            }
        }
    }
}

// MARK: - Routine Tracker View Model
final class RoutineTrackerViewModel: ObservableObject {
    @Published var todayCheckpoints: [RoutineCheckpoint] = []
    
    private let userDefaults = UserDefaults.standard
    private let checkpointsKey = "routine_checkpoints"
    
    init() {
        loadTodayCheckpoints()
    }
    
    func toggleRoutine(_ routineType: RoutineCheckpoint.RoutineType) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = todayCheckpoints.firstIndex(where: { 
            Calendar.current.isDate($0.date, inSameDayAs: today) && $0.routineType == routineType 
        }) {
            todayCheckpoints[index].isCompleted.toggle()
        } else {
            let newCheckpoint = RoutineCheckpoint(
                date: today,
                routineType: routineType,
                isCompleted: true
            )
            todayCheckpoints.append(newCheckpoint)
        }
        
        saveCheckpoints()
    }
    
    func isRoutineCompleted(_ routineType: RoutineCheckpoint.RoutineType) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return todayCheckpoints.contains { 
            Calendar.current.isDate($0.date, inSameDayAs: today) && 
            $0.routineType == routineType && 
            $0.isCompleted 
        }
    }
    
    private func loadTodayCheckpoints() {
        if let data = userDefaults.data(forKey: checkpointsKey),
           let checkpoints = try? JSONDecoder().decode([RoutineCheckpoint].self, from: data) {
            let today = Calendar.current.startOfDay(for: Date())
            todayCheckpoints = checkpoints.filter { 
                Calendar.current.isDate($0.date, inSameDayAs: today) 
            }
        }
    }
    
    private func saveCheckpoints() {
        if let data = try? JSONEncoder().encode(todayCheckpoints) {
            userDefaults.set(data, forKey: checkpointsKey)
        }
    }
}

// MARK: - Main Page View Model
final class MainPageViewModel: ObservableObject {
    @Published var uvIndex: Int = 5
    @Published var humidity: Int = 45
    @Published var pollutionLevel: Int = 25
    @Published var routineTracker = RoutineTrackerViewModel()
    
    func fetchEnvironmentalData() {
        // TODO: Implement real API calls
        // For now, using mock data
        uvIndex = Int.random(in: 1...10)
        humidity = Int.random(in: 20...80)
        pollutionLevel = Int.random(in: 10...100)
    }
}

// MARK: - Routine Panel View
struct RoutinePanelView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Description text first
            Text("AI skin analysis results & your concerns will be used to prepare a personalized skincare routine just for you.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 16) {
                // Add Routine button
                Button("Add Routine") {
                    // TODO: Navigate to routine creation
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppTheme.primaryGradient)
                .cornerRadius(20)
                
                Spacer()
                
                // Skincare products illustration
                ZStack {
                    // Background circle
                    Circle()
                        .fill(AppTheme.primaryColor.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    // Multiple skincare product icons
                    VStack(spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 16))
                                .foregroundColor(AppTheme.primaryColor)
                            
                            Image(systemName: "circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(AppTheme.secondaryColor)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "square.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.primaryColor.opacity(0.7))
                            
                            Image(systemName: "triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.secondaryColor.opacity(0.7))
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.surfaceColor)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - UV Index Panel View
struct UVIndexPanelView: View {
    let uvIndex: Int
    
    private var uvLevel: String {
        switch uvIndex {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...7: return "High"
        case 8...10: return "Very High"
        default: return "Extreme"
        }
    }
    
    private var uvColor: Color {
        switch uvIndex {
        case 0...2: return .green
        case 3...5: return Color(hex: "CA8A04") // Daha da koyu sarı
        case 6...7: return .orange
        case 8...10: return .red
        default: return .purple
        }
    }
    
    private var uvDescription: String {
        switch uvIndex {
        case 0...2: return "Low UV – Minimal risk today, but SPF still recommended."
        case 3...5: return "Moderate UV – Wear sunscreen and limit sun exposure."
        case 6...7: return "High UV – Wear sunscreen and limit sun exposure."
        case 8...10: return "Very High UV – Wear sunscreen and limit sun exposure."
        default: return "Extreme UV – Avoid sun exposure, wear protective clothing."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 16))
                    .foregroundColor(uvColor)
                
                Text("UV Index")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            Text("\(uvIndex)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(uvColor)
            
            Text(uvDescription)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(3)
        }
        .padding(16)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(uvColor.opacity(0.1))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .accessibilityLabel("UV Index \(uvIndex), \(uvLevel) level. \(uvDescription)")
    }
}

// MARK: - Humidity Panel View
struct HumidityPanelView: View {
    let humidity: Int
    
    private var humidityDescription: String {
        if humidity < 30 {
            return "Low humidity – Skin may feel dry, moisturize regularly."
        } else if humidity > 70 {
            return "High humidity – May cause excess oil or shine."
        } else {
            return "Moderate humidity – Balanced skin condition."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                
                Text("Humidity")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            Text("\(humidity)%")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.blue)
            
            Text(humidityDescription)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(3)
        }
        .padding(16)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.1))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .accessibilityLabel("Humidity \(humidity)%. \(humidityDescription)")
    }
}

// MARK: - Pollution Panel View
struct PollutionPanelView: View {
    let pollutionLevel: Int
    
    private var pollutionCategory: String {
        switch pollutionLevel {
        case 0...50: return "Good"
        case 51...100: return "Moderate"
        case 101...150: return "Unhealthy for Sensitive Groups"
        case 151...200: return "Unhealthy"
        case 201...300: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
    
    private var pollutionColor: Color {
        switch pollutionLevel {
        case 0...50: return .green
        case 51...100: return Color(hex: "CA8A04") // Daha da koyu sarı
        case 101...150: return .orange
        case 151...200: return .red
        case 201...300: return .purple
        default: return .brown
        }
    }
    
    private var pollutionDescription: String {
        switch pollutionLevel {
        case 0...50: return "Low pollution – Minimal impact on skin."
        case 51...100: return "Moderate pollution – May irritate skin, cleanse thoroughly."
        case 101...150: return "High pollution – May irritate skin, cleanse thoroughly."
        case 151...200: return "Very high pollution – May irritate skin, cleanse thoroughly."
        case 201...300: return "Extreme pollution – May irritate skin, cleanse thoroughly."
        default: return "Hazardous pollution – May irritate skin, cleanse thoroughly."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 16))
                    .foregroundColor(pollutionColor)
                
                Text("Pollution Level")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            HStack {
                Text("\(pollutionLevel)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(pollutionColor)
                
                Text(pollutionCategory)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(pollutionColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(pollutionColor.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(pollutionDescription)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(pollutionColor.opacity(0.1))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .accessibilityLabel("Pollution Level \(pollutionLevel), \(pollutionCategory). \(pollutionDescription)")
    }
}

// MARK: - App Tab Enum
enum AppTab: String, CaseIterable {
    case home = "home"
    case products = "products"
    case scan = "scan"
    case explore = "explore"
    case profile = "profile"
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .products: return "Products"
        case .scan: return "Scan product"
        case .explore: return "Explore routines"
        case .profile: return "Profile"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .products: return "drop.fill" // Placeholder for iconProduct
        case .scan: return "viewfinder" // Placeholder for iconScan
        case .explore: return "sparkles"
        case .profile: return "person.crop.circle"
        }
    }
    
    var activeIconName: String {
        switch self {
        case .home: return "house.fill"
        case .products: return "drop.fill" // Placeholder for iconProduct
        case .scan: return "viewfinder" // Placeholder for iconScan
        case .explore: return "sparkles"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

// MARK: - App Tab Bar View
struct AppTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Add spacing between buttons (except for the last one)
                    if tab != AppTab.allCases.last {
                        Spacer()
                            .frame(width: geometry.size.width * 0.05) // 5% of screen width
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "DDE5E1"))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .frame(height: 80) // Fixed height for the bar
    }
}

// MARK: - Tab Button Component
struct TabButton: View {
    let tab: AppTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(isSelected ? Color(hex: "0B0B0B") : Color(hex: "C9CECB"))
                        .frame(width: 48, height: 48)
                    
                    // Icon
                    Image(systemName: isSelected ? tab.activeIconName : tab.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(isSelected ? 1.0 : 0.75)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Main Tab Container View
struct MainTabContainerView: View {
    @AppStorage("lastTab") private var lastSelectedTab: String = AppTab.home.rawValue
    @State private var selectedTab: AppTab = .home
    @ObservedObject var surveyViewModel: SurveyViewModel
    
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
                    MainPageView(surveyViewModel: surveyViewModel)
                        .tag(AppTab.home)
                    
                    ProductsViewContent()
                        .tag(AppTab.products)
                    
                    ProductScannerView()
                        .tag(AppTab.scan)
                    
                    ExploreRoutinesView()
                        .tag(AppTab.explore)
                    
                    ProfileViewContent()
                        .tag(AppTab.profile)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                Spacer(minLength: 0)
                
                // Bottom tab bar with matching background
                ZStack {
                    // Background matching the main page
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.9, green: 0.85, blue: 0.95), // Lavender
                            Color(red: 0.95, green: 0.9, blue: 0.85)  // Peach-pink
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 100)
                    
                    AppTabBar(selectedTab: $selectedTab)
                }
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

// MARK: - Products View Content
struct ProductsViewContent: View {
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
            ProductDetailViewContent(product: product)
        }
        .onAppear {
            print("✅ ProductsViewContent appeared, items=\(viewModel.filteredProducts.count)")
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
                        Text(category.rawValue)
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
                        ProductCardViewContent(product: product) {
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

// MARK: - Product Card View Content
struct ProductCardViewContent: View {
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
                
                // Spacer to ensure consistent height
                Spacer(minLength: 0)
            }
            .frame(height: 320) // Fixed height for all cards
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
                Text("Recommended")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
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

// MARK: - Product Detail View Content
struct ProductDetailViewContent: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var showingIngredients = false
    @State private var showingWarnings = false
    
    var body: some View {
        NavigationStack {
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
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
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

// MARK: - Explore Routines View
struct ExploreRoutinesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.primaryColor.opacity(0.3))
                    
                    Text("Explore Routines")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Discover new skincare routines and tips")
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
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Profile View Content
struct ProfileViewContent: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingActionSheet = false
    @State private var showingCalendar = false
    @State private var currentDate = Date()
    @State private var showingSkinProfile = false // Added for skin profile
    @State private var showingRoutinePreferences = false // Added for routine preferences
    @State private var showingMyScans = false // Added for my scans
    @State private var showingFaceScans = false // Added for face scans
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 0) {
                        // Profile Header
                        profileHeaderSection
                        
                        // Scans & Diary Card
                        scansAndDiaryCard
                        
                        // Profile Sections
                        profileSectionsView
                        
                        // Log Out Button
                        logOutButton
                        
                        // Extra content to ensure scrolling
            VStack(spacing: 20) {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 200)
                            
                            Text("Scroll Test Area")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 200)
                        }
                    }
                    .frame(minHeight: geometry.size.height + 500)
                }
                .background(Color(hex: "F8F8F8"))
                .clipped()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .alert("Log Out", isPresented: $viewModel.showingLogOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                viewModel.logOut()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .onChange(of: viewModel.selectedAction) { action in
            if let action = action {
                handleAction(action)
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarView(currentDate: $currentDate)
        }
        .sheet(isPresented: $showingSkinProfile) {
            SkinProfileView()
        }
        .sheet(isPresented: $showingRoutinePreferences) {
            RoutinePreferencesView()
        }
        .sheet(isPresented: $showingMyScans) {
            MyScansView()
        }
        .sheet(isPresented: $showingFaceScans) {
            FaceScansView()
        }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
                VStack(spacing: 16) {
            // Avatar with edit button
            ZStack {
                Circle()
                    .fill(Color(hex: "E5E7EB"))
                    .frame(width: 80, height: 80)
                
                Text("😊")
                    .font(.system(size: 40))
                
                // Edit button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle edit profile
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color(hex: "8B5CF6"))
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(width: 80, height: 80)
            }
            
            // User name
            Text(viewModel.userProfile.name)
                        .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "111111"))
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Scans & Diary Card
    private var scansAndDiaryCard: some View {
        Button(action: {
            showingCalendar = true
        }) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "6B7280"))
                
                Text("Scans & Diary - \(currentDate.formatted(.dateTime.month(.wide))))")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
    
    // MARK: - Profile Sections View
    private var profileSectionsView: some View {
        VStack(spacing: 32) {
            ForEach(ProfileSection.allCases) { section in
                profileSectionView(section: section)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
    
    // MARK: - Profile Section View
    private func profileSectionView(section: ProfileSection) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            Text(section.rawValue)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
                .padding(.horizontal, 4)
            
            // Section Items
            VStack(spacing: 0) {
                ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                    profileMenuItemView(item: item, isLast: index == section.items.count - 1)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Profile Menu Item View
    private func profileMenuItemView(item: ProfileMenuItem, isLast: Bool) -> some View {
        Button(action: {
            viewModel.handleAction(item.action)
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "6B7280"))
                    .frame(width: 24, height: 24)
                
                // Title
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                // Badge
                if let badge = item.badge {
                    Text(badge)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "8B5CF6"))
                        .clipShape(Capsule())
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6B7280"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            // Divider
            VStack {
                Spacer()
                if !isLast {
                    Rectangle()
                        .fill(Color(hex: "E5E7EB"))
                        .frame(height: 1)
                        .padding(.leading, 60)
                }
            }
        )
    }
    
    
    
    // MARK: - Log Out Button
    private var logOutButton: some View {
        Button(action: {
            viewModel.handleAction(.logOut)
        }) {
            Text("Log Out")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "111111"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "E5E7EB"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
        .padding(.top, 40)
        .padding(.bottom, 60)
    }
    
    // MARK: - Action Handling
    private func handleAction(_ action: ProfileAction) {
        switch action {
        case .mySkinProfile:
            // Navigate to skin profile
            showingSkinProfile = true
        case .routinePreferences:
            // Navigate to routine preferences
            showingRoutinePreferences = true
        case .routineForYou:
            // Navigate to routine for you
            print("Navigate to Routine for You")
        case .myShelf:
            // Navigate to my scans
            showingMyScans = true
        case .faceScans:
            // Navigate to face scans
            showingFaceScans = true
        case .subscriptionManagement:
            // Navigate to subscription management
            print("Navigate to Subscription Management")
        case .frequentlyAskedQuestions:
            // Show FAQ
            print("Show FAQ")
        case .appSettings:
            // Open app settings
            print("Open App Settings")
        case .contactUs:
            // Open contact us
            print("Open Contact Us")
        case .privacyPolicy:
            // Show privacy policy
            print("Show Privacy Policy")
        case .moneyBackPolicy:
            // Show money back policy
            print("Show Money Back Policy")
        case .termsOfUse:
            // Show terms of use
            print("Show Terms of Use")
        case .logOut:
            // Handle logout
            print("Handle Logout")
        }
    }
}

// MARK: - Profile Models
// MARK: - Profile Menu Item
struct ProfileMenuItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let action: ProfileAction
    let badge: String?
    
    init(title: String, icon: String, action: ProfileAction, badge: String? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
        self.badge = badge
    }
}

// MARK: - Profile Action
enum ProfileAction: String, CaseIterable {
    case mySkinProfile = "My Skin Profile"
    case routinePreferences = "Routine Preferences"
    case routineForYou = "Routine for you"
    case myShelf = "My Scans"
    case faceScans = "Face Scans"
    case subscriptionManagement = "Subscription Management"
    case frequentlyAskedQuestions = "Frequently Asked Questions"
    case appSettings = "App Settings"
    case contactUs = "Contact us"
    case privacyPolicy = "Privacy policy"
    case moneyBackPolicy = "Money-back Policy"
    case termsOfUse = "Terms of Use"
    case logOut = "Log Out"
    
    var icon: String {
        switch self {
        case .mySkinProfile: return "face.smiling"
        case .routinePreferences: return "slider.horizontal.3"
        case .routineForYou: return "sparkles"
        case .myShelf: return "books.vertical"
        case .faceScans: return "viewfinder"
        case .subscriptionManagement: return "person.crop.circle.badge.checkmark"
        case .frequentlyAskedQuestions: return "questionmark.circle"
        case .appSettings: return "gearshape"
        case .contactUs: return "bubble.left.and.bubble.right"
        case .privacyPolicy: return "hand.raised"
        case .moneyBackPolicy: return "dollarsign.circle"
        case .termsOfUse: return "doc.text"
        case .logOut: return "rectangle.portrait.and.arrow.right"
        }
    }
}


// MARK: - Profile Section
enum ProfileSection: String, CaseIterable, Identifiable {
    case personal = "PERSONAL"
    case needHelp = "NEED HELP?"
    case legal = "LEGAL"
    
    var id: String { rawValue }
    
    var items: [ProfileMenuItem] {
        switch self {
        case .personal:
            return [
                ProfileMenuItem(title: "My Skin Profile", icon: ProfileAction.mySkinProfile.icon, action: .mySkinProfile),
                ProfileMenuItem(title: "Routine Preferences", icon: ProfileAction.routinePreferences.icon, action: .routinePreferences),
                ProfileMenuItem(title: "Routine for you", icon: ProfileAction.routineForYou.icon, action: .routineForYou),
                ProfileMenuItem(title: "My Scans", icon: ProfileAction.myShelf.icon, action: .myShelf),
                ProfileMenuItem(title: "Face Scans (2)", icon: ProfileAction.faceScans.icon, action: .faceScans, badge: "2"),
                ProfileMenuItem(title: "Subscription Management", icon: ProfileAction.subscriptionManagement.icon, action: .subscriptionManagement)
            ]
        case .needHelp:
            return [
                ProfileMenuItem(title: "Frequently Asked Questions", icon: ProfileAction.frequentlyAskedQuestions.icon, action: .frequentlyAskedQuestions),
                ProfileMenuItem(title: "App Settings", icon: ProfileAction.appSettings.icon, action: .appSettings),
                ProfileMenuItem(title: "Contact us", icon: ProfileAction.contactUs.icon, action: .contactUs)
            ]
        case .legal:
            return [
                ProfileMenuItem(title: "Privacy policy", icon: ProfileAction.privacyPolicy.icon, action: .privacyPolicy),
                ProfileMenuItem(title: "Money-back Policy", icon: ProfileAction.moneyBackPolicy.icon, action: .moneyBackPolicy),
                ProfileMenuItem(title: "Terms of Use", icon: ProfileAction.termsOfUse.icon, action: .termsOfUse)
            ]
        }
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String
    var avatar: String?
    var joinDate: Date
    var subscriptionStatus: SubscriptionStatus
    var faceScansCount: Int
    var preferences: UserPreferences
    
    init(name: String = "Sunshine", avatar: String? = nil, joinDate: Date = Date(), subscriptionStatus: SubscriptionStatus = .free, faceScansCount: Int = 2, preferences: UserPreferences = UserPreferences()) {
        self.name = name
        self.avatar = avatar
        self.joinDate = joinDate
        self.subscriptionStatus = subscriptionStatus
        self.faceScansCount = faceScansCount
        self.preferences = preferences
    }
}

// MARK: - Subscription Status
enum SubscriptionStatus: String, CaseIterable, Codable {
    case free = "Free"
    case premium = "Premium"
    case pro = "Pro"
    
    var displayName: String {
        switch self {
        case .free: return "Free Plan"
        case .premium: return "Premium Plan"
        case .pro: return "Pro Plan"
        }
    }
    
    var color: String {
        switch self {
        case .free: return "6B7280"
        case .premium: return "8B5CF6"
        case .pro: return "F59E0B"
        }
    }
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    var notifications: Bool
    var darkMode: Bool
    var language: String
    var units: String
    
    init(notifications: Bool = true, darkMode: Bool = false, language: String = "English", units: String = "Metric") {
        self.notifications = notifications
        self.darkMode = darkMode
        self.language = language
        self.units = units
    }
}

// MARK: - Profile ViewModel
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var showingLogOutAlert = false
    @Published var selectedAction: ProfileAction?
    
    init() {
        self.userProfile = UserProfile()
    }
    
    // MARK: - Actions
    func handleAction(_ action: ProfileAction) {
        selectedAction = action
        
        switch action {
        case .logOut:
            showingLogOutAlert = true
        case .contactUs:
            openContactUs()
        case .appSettings:
            openAppSettings()
        default:
            // Handle other actions
            print("Selected action: \(action.rawValue)")
        }
    }
    
    
    private func openContactUs() {
        if let url = URL(string: "mailto:support@skincareandrituals.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func logOut() {
        // Handle logout logic
        print("User logged out")
    }
    
    // MARK: - Computed Properties
    var formattedJoinDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: userProfile.joinDate)
    }
    
    var subscriptionDisplayText: String {
        return userProfile.subscriptionStatus.displayName
    }
}

// MARK: - Skin Diary Models
struct SkinDiaryEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var photoData: Data?
    var skinCondition: SkinCondition
    var notes: String
    var mood: DiaryMood
    
    init(date: Date, photoData: Data? = nil, skinCondition: SkinCondition = .normal, notes: String = "", mood: DiaryMood = .neutral) {
        self.date = date
        self.photoData = photoData
        self.skinCondition = skinCondition
        self.notes = notes
        self.mood = mood
    }
}

enum SkinCondition: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case normal = "Normal"
    case poor = "Poor"
    case bad = "Bad"
    
    var emoji: String {
        switch self {
        case .excellent: return "🌟"
        case .good: return "😊"
        case .normal: return "😐"
        case .poor: return "😔"
        case .bad: return "😞"
        }
    }
    
    var color: String {
        switch self {
        case .excellent: return "4CAF50"
        case .good: return "8BC34A"
        case .normal: return "FFC107"
        case .poor: return "FF9800"
        case .bad: return "F44336"
        }
    }
}

enum DiaryMood: String, CaseIterable, Codable {
    case happy = "Happy"
    case neutral = "Neutral"
    case stressed = "Stressed"
    case tired = "Tired"
    case energetic = "Energetic"
    
    var emoji: String {
        switch self {
        case .happy: return "😄"
        case .neutral: return "😐"
        case .stressed: return "😰"
        case .tired: return "😴"
        case .energetic: return "⚡"
        }
    }
}

// MARK: - Diary ViewModel
@MainActor
class DiaryViewModel: ObservableObject {
    @Published var entries: [Date: SkinDiaryEntry] = [:]
    @Published var selectedDate: Date?
    @Published var showingPhotoPicker = false
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "SkinDiaryEntries"
    
    init() {
        loadEntries()
    }
    
    func getEntry(for date: Date) -> SkinDiaryEntry? {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        return entries[normalizedDate]
    }
    
    func saveEntry(_ entry: SkinDiaryEntry) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: entry.date)
        entries[normalizedDate] = entry
        saveEntries()
    }
    
    func createOrUpdateEntry(for date: Date, photoData: Data? = nil, skinCondition: SkinCondition = .normal, notes: String = "", mood: DiaryMood = .neutral) {
        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)
        
        if let existingEntry = entries[normalizedDate] {
            var updatedEntry = existingEntry
            if let photoData = photoData {
                updatedEntry.photoData = photoData
            }
            updatedEntry.skinCondition = skinCondition
            updatedEntry.notes = notes
            updatedEntry.mood = mood
            entries[normalizedDate] = updatedEntry
        } else {
            let newEntry = SkinDiaryEntry(date: normalizedDate, photoData: photoData, skinCondition: skinCondition, notes: notes, mood: mood)
            entries[normalizedDate] = newEntry
        }
        saveEntries()
    }
    
    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            userDefaults.set(data, forKey: entriesKey)
        } catch {
            print("Failed to save diary entries: \(error)")
        }
    }
    
    private func loadEntries() {
        guard let data = userDefaults.data(forKey: entriesKey) else { return }
        do {
            entries = try JSONDecoder().decode([Date: SkinDiaryEntry].self, from: data)
        } catch {
            print("Failed to load diary entries: \(error)")
        }
    }
}

// MARK: - Calendar View
struct CalendarView: View {
    @Binding var currentDate: Date
    @Environment(\.dismiss) private var dismiss
    @StateObject private var diaryViewModel = DiaryViewModel()
    @State private var selectedDay: Date?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    // Header
                    calendarHeader
                    
                    // Calendar Grid
                    calendarGrid
                    
                    // Navigation Controls
                    calendarNavigation
                    
                    // Skin Diary Panel
                    if let selectedDay = selectedDay {
                        skinDiaryPanel(for: selectedDay)
                    }
                    
                    // Extra space for better scrolling
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("Scans & Diary")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
            }
        }
    }
    
    // MARK: - Calendar Header
    private var calendarHeader: some View {
        VStack(spacing: 16) {
            // Month and Year
            Text(dateFormatter.string(from: currentDate))
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "111111"))
            
            // Day headers
            HStack(spacing: 0) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(calendarDays, id: \.self) { date in
                calendarDayView(for: date)
            }
        }
    }
    
    // MARK: - Calendar Day View
    private func calendarDayView(for date: Date) -> some View {
        let day = calendar.component(.day, from: date)
        let isCurrentMonth = calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDay ?? Date.distantPast)
        let hasEntry = diaryViewModel.getEntry(for: date) != nil
        
        return Text("\(day)")
            .font(.system(size: 16, weight: isToday ? .bold : .medium))
            .foregroundColor(isCurrentMonth ? Color(hex: "111111") : Color(hex: "9CA3AF"))
            .frame(width: 40, height: 40)
                .background(
                Circle()
                    .fill(isToday ? Color(hex: "3B82F6") : 
                          isSelected ? Color(hex: "8B5CF6") : 
                          hasEntry ? Color(hex: "E5E7EB") : Color.clear)
            )
            .foregroundColor(isToday || isSelected ? .white : (isCurrentMonth ? Color(hex: "111111") : Color(hex: "9CA3AF")))
            .overlay(
                // Diary entry indicator
                hasEntry ? 
                Circle()
                    .fill(Color(hex: "8B5CF6"))
                    .frame(width: 6, height: 6)
                    .offset(x: 12, y: 12) : nil
            )
            .onTapGesture {
                selectedDay = date
            }
    }
    
    // MARK: - Calendar Navigation
    private var calendarNavigation: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                    Text(monthFormatter.string(from: calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate))
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color(hex: "6B7280"))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }
            }) {
                HStack(spacing: 4) {
                    Text(monthFormatter.string(from: calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate))
                        .font(.system(size: 14, weight: .medium))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color(hex: "6B7280"))
            }
        }
        .padding(.top, 24)
    }
    
    // MARK: - Calendar Days
    private var calendarDays: [Date] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentDate)?.start ?? currentDate
        let endOfMonth = calendar.dateInterval(of: .month, for: currentDate)?.end ?? currentDate
        
        let startOfCalendar = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        let endOfCalendar = calendar.dateInterval(of: .weekOfYear, for: endOfMonth)?.end ?? endOfMonth
        
        var days: [Date] = []
        var currentDate = startOfCalendar
        
        while currentDate < endOfCalendar {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return days
    }
    
    // MARK: - Skin Diary Panel
    private func skinDiaryPanel(for date: Date) -> some View {
        let entry = diaryViewModel.getEntry(for: date)
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE, MMMM d"
        
        return VStack(spacing: 16) {
            // Header
            HStack {
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "111111"))
                
                Spacer()
                
                Button(action: {
                    selectedDay = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .padding(.top, 20)
            
            // Diary Content
            if let entry = entry {
                existingDiaryEntry(entry)
            } else {
                newDiaryEntry(for: date)
            }
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        )
        .padding(.top, 20)
    }
    
    // MARK: - Existing Diary Entry
    private func existingDiaryEntry(_ entry: SkinDiaryEntry) -> some View {
        VStack(spacing: 16) {
            // Photo Section
            if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Skin Condition & Mood
            HStack(spacing: 20) {
                // Skin Condition
                VStack(alignment: .leading, spacing: 4) {
                    Text("Skin Condition")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    HStack(spacing: 8) {
                        Text(entry.skinCondition.emoji)
                            .font(.system(size: 20))
                        Text(entry.skinCondition.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: entry.skinCondition.color))
                    }
                }
                
                Spacer()
                
                // Mood
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Mood")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    HStack(spacing: 8) {
                        Text(entry.mood.emoji)
                            .font(.system(size: 20))
                        Text(entry.mood.rawValue)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "111111"))
                    }
                }
            }
            
            // Notes
            if !entry.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "6B7280"))
                    
                    Text(entry.notes)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "111111"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // Edit Button
            Button(action: {
                // TODO: Implement edit functionality
            }) {
                Text("Edit Entry")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "8B5CF6"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "8B5CF6"), lineWidth: 1)
                    )
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - New Diary Entry
    private func newDiaryEntry(for date: Date) -> some View {
        @State var skinCondition: SkinCondition = .normal
        @State var mood: DiaryMood = .neutral
        @State var notes: String = ""
        @State var selectedImage: UIImage?
        
        return VStack(spacing: 16) {
            // Add Photo Section
            Button(action: {
                diaryViewModel.showingPhotoPicker = true
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "8B5CF6"))
                    
                    Text("Add Photo")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "8B5CF6"))
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "8B5CF6"), lineWidth: 2)
                )
            }
            
            // Skin Condition Selector
            VStack(alignment: .leading, spacing: 8) {
                Text("How is your skin today?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                HStack(spacing: 12) {
                    ForEach(SkinCondition.allCases, id: \.self) { condition in
                        Button(action: {
                            skinCondition = condition
                        }) {
                            VStack(spacing: 4) {
                                Text(condition.emoji)
                                    .font(.system(size: 24))
                                
                                Text(condition.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            .frame(width: 50)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(skinCondition == condition ? Color(hex: condition.color).opacity(0.1) : Color.clear)
                            )
                        }
                    }
                }
            }
            
            // Mood Selector
            VStack(alignment: .leading, spacing: 8) {
                Text("How are you feeling?")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                HStack(spacing: 12) {
                    ForEach(DiaryMood.allCases, id: \.self) { moodOption in
                        Button(action: {
                            mood = moodOption
                        }) {
                            VStack(spacing: 4) {
                                Text(moodOption.emoji)
                                    .font(.system(size: 24))
                                
                                Text(moodOption.rawValue)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color(hex: "6B7280"))
                            }
                            .frame(width: 50)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(mood == moodOption ? Color(hex: "8B5CF6").opacity(0.1) : Color.clear)
                            )
                        }
                    }
                }
            }
            
            // Notes Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Notes (Optional)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "111111"))
                
                TextField("How did your skin feel today?", text: $notes, axis: .vertical)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "F3F4F6"))
                    )
                    .lineLimit(3...6)
            }
            
            // Save Button
            Button(action: {
                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                diaryViewModel.createOrUpdateEntry(for: date, photoData: imageData, skinCondition: skinCondition, notes: notes, mood: mood)
                selectedDay = nil
            }) {
                Text("Save Entry")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "8B5CF6"))
                    )
            }
        }
        .padding(.bottom, 20)
        .sheet(isPresented: $diaryViewModel.showingPhotoPicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Skin Profile View
struct SkinProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var showingSaveAlert = false
    
    // Survey data from UserDefaults
    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var skinType: String = ""
    @State private var skinSensitivity: String = ""
    @State private var skinConcerns: [String] = []
    
    // Available options (matching survey options)
    private let genderOptions = ["Female", "Male", "Prefer not to say"]
    private let ageOptions = ["13-17", "18-24", "25-34", "35-44", "45-54", "55+"]
    private let skinTypeOptions = ["Oily", "Dry", "Combination", "Normal"]
    private let sensitivityOptions = ["Sensitive", "Not sensitive"]
    private let concernOptions = ["Acne or pimples", "Wrinkles and Fine lines", "Redness or Rosacea", "T-zone Oiliness", "Skin barrier repair", "Puffy eyes", "Enlarged pores"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Header
                    profileHeader
                    
                    // Profile Information
                    profileInformationSection
                    
                    // Close Button
                    closeButton
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("My Skin Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveProfile()
                        } else {
                            isEditing = true
                        }
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
            }
        }
        .onAppear {
            loadProfileData()
        }
        .alert("Profile Updated", isPresented: $showingSaveAlert) {
            Button("OK") {
                isEditing = false
            }
        } message: {
            Text("Your skin profile has been updated successfully.")
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Icon
            Circle()
                .fill(Color(hex: "8B5CF6"))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                )
            
            Text("Skin Profile")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "111111"))
            
            Text("Your personalized skin information")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "6B7280"))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Profile Information Section
    private var profileInformationSection: some View {
        VStack(spacing: 20) {
            // Name
            profileField(title: "Name", value: $name, isEditable: isEditing)
            
            // Gender
            profileField(title: "Gender", value: $gender, isEditable: isEditing, options: genderOptions)
            
            // Age
            profileField(title: "Age", value: $age, isEditable: isEditing, options: ageOptions)
            
            // Skin Type
            profileField(title: "Skin Type", value: $skinType, isEditable: isEditing, options: skinTypeOptions)
            
            // Skin Sensitivity
            profileField(title: "Skin Sensitivity", value: $skinSensitivity, isEditable: isEditing, options: sensitivityOptions)
            
            // Skin Concerns
            skinConcernsSection
        }
    }
    
    // MARK: - Profile Field
    private func profileField(title: String, value: Binding<String>, isEditable: Bool, options: [String]? = nil, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            if isEditable {
                if let options = options {
                    Menu {
                        ForEach(options, id: \.self) { option in
                            Button(option) {
                                value.wrappedValue = option
                            }
                        }
                    } label: {
                        HStack {
                            Text(value.wrappedValue.isEmpty ? "Select \(title)" : value.wrappedValue)
                                .foregroundColor(value.wrappedValue.isEmpty ? Color(hex: "9CA3AF") : Color(hex: "111111"))
                Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                        )
                    }
                } else {
                    TextField("Enter \(title.lowercased())", text: value)
                        .keyboardType(keyboardType)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                        )
                }
            } else {
                Text(value.wrappedValue.isEmpty ? "Not specified" : value.wrappedValue)
                    .font(.system(size: 16))
                    .foregroundColor(value.wrappedValue.isEmpty ? Color(hex: "9CA3AF") : Color(hex: "111111"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "F3F4F6"))
                    )
            }
        }
    }
    
    // MARK: - Skin Concerns Section
    private var skinConcernsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Skin Concerns")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            if isEditing {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(concernOptions, id: \.self) { concern in
                        Button(action: {
                            toggleConcern(concern)
                        }) {
                            HStack {
                                Text(concern)
                                    .font(.system(size: 14))
                                    .foregroundColor(skinConcerns.contains(concern) ? .white : Color(hex: "6B7280"))
                                
                                Spacer()
                                
                                Image(systemName: skinConcerns.contains(concern) ? "checkmark" : "plus")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(skinConcerns.contains(concern) ? .white : Color(hex: "6B7280"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(skinConcerns.contains(concern) ? Color(hex: "8B5CF6") : Color.white)
                                    .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                        }
                    }
                }
            } else {
                if skinConcerns.isEmpty {
                    Text("No concerns specified")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "9CA3AF"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "F3F4F6"))
                        )
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(skinConcerns, id: \.self) { concern in
                            Text(concern)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: "8B5CF6"))
                                )
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Close Button
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Close")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "8B5CF6"))
                )
            }
            .padding(.top, 20)
    }
    
    // MARK: - Helper Functions
    private func toggleConcern(_ concern: String) {
        if skinConcerns.contains(concern) {
            skinConcerns.removeAll { $0 == concern }
        } else {
            skinConcerns.append(concern)
        }
    }
    
    private func loadProfileData() {
        // Load survey data from UserDefaults, with survey-appropriate fallback data
        name = UserDefaults.standard.string(forKey: "survey_name") ?? "User"
        gender = UserDefaults.standard.string(forKey: "survey_gender") ?? "Not specified"
        age = UserDefaults.standard.string(forKey: "survey_age") ?? "18-24"
        skinType = UserDefaults.standard.string(forKey: "survey_skin_type") ?? "Normal"
        skinSensitivity = UserDefaults.standard.string(forKey: "survey_skin_sensitivity") ?? "Not sensitive"
        
        // Load skin concerns with survey-appropriate fallback data
        if let concernsData = UserDefaults.standard.data(forKey: "survey_skin_concerns"),
           let concerns = try? JSONDecoder().decode([String].self, from: concernsData) {
            skinConcerns = concerns
        } else {
            // Survey-appropriate skin concerns (from SkinMotivation enum)
            skinConcerns = ["Acne or pimples", "T-zone Oiliness"]
        }
    }
    
    private func saveProfile() {
        // Save updated data to UserDefaults
        UserDefaults.standard.set(name, forKey: "survey_name")
        UserDefaults.standard.set(gender, forKey: "survey_gender")
        UserDefaults.standard.set(age, forKey: "survey_age")
        UserDefaults.standard.set(skinType, forKey: "survey_skin_type")
        UserDefaults.standard.set(skinSensitivity, forKey: "survey_skin_sensitivity")
        
        // Save skin concerns
        if let concernsData = try? JSONEncoder().encode(skinConcerns) {
            UserDefaults.standard.set(concernsData, forKey: "survey_skin_concerns")
        }
        
        showingSaveAlert = true
    }
}

// MARK: - Routine Preferences View
struct RoutinePreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var showingSaveAlert = false
    
    // Survey data from UserDefaults
    @State private var budget: String = ""
    @State private var isPregnantOrBreastfeeding: Bool = false
    @State private var avoidIngredients: [String] = []
    
    // Available options
    private let budgetOptions = ["Smart Savings", "Balanced Value", "Professional & Innovative", "Ultimate Collection"]
    private let ingredientOptions = ["Sulfates (SLS, etc.)", "Fragrances / Perfumes", "Parabens", "Formaldehyde Releasers", "Drying Alcohols", "Comedogenics", "Artificial Colors", "None"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Header
                    routinePreferencesHeader
                    
                    // Routine Preferences Information
                    routinePreferencesInformationSection
                    
                    // Close Button
                    closeButton
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("Routine Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            savePreferences()
                        } else {
                            isEditing = true
                        }
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
            }
        }
        .onAppear {
            loadPreferencesData()
        }
        .alert("Preferences Updated", isPresented: $showingSaveAlert) {
            Button("OK") {
                isEditing = false
            }
        } message: {
            Text("Your routine preferences have been updated successfully.")
        }
    }
    
    // MARK: - Header
    private var routinePreferencesHeader: some View {
        VStack(spacing: 16) {
            // Profile Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "8B5CF6").opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "8B5CF6"))
            }
            
            VStack(spacing: 8) {
                Text("Routine Preferences")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Text("Customize your skincare routine preferences")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "6B7280"))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Routine Preferences Information Section
    private var routinePreferencesInformationSection: some View {
        VStack(spacing: 20) {
            // Budget
            routinePreferencesField(title: "Budget", value: $budget, isEditable: isEditing, options: budgetOptions)
            
            // Pregnancy Status
            pregnancyStatusField
            
            // Avoid Ingredients
            avoidIngredientsSection
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
    
    // MARK: - Pregnancy Status Field
    private var pregnancyStatusField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pregnancy Status")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            if isEditing {
                Toggle("Currently pregnant or breastfeeding", isOn: $isPregnantOrBreastfeeding)
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "8B5CF6")))
                    .font(.system(size: 16))
            } else {
                HStack {
                    Text(isPregnantOrBreastfeeding ? "Currently pregnant or breastfeeding" : "Not pregnant or breastfeeding")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "111111"))
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color(hex: "F3F4F6"))
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Avoid Ingredients Section
    private var avoidIngredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients to Avoid")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            if isEditing {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(ingredientOptions, id: \.self) { ingredient in
                        Button(action: {
                            toggleIngredient(ingredient)
                        }) {
                            HStack {
                                Text(ingredient)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(avoidIngredients.contains(ingredient) ? .white : Color(hex: "8B5CF6"))
                                
                                Spacer()
                                
                                if avoidIngredients.contains(ingredient) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(avoidIngredients.contains(ingredient) ? Color(hex: "8B5CF6") : Color(hex: "8B5CF6").opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                }
            } else {
                if avoidIngredients.isEmpty {
                    Text("No ingredients selected")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "9CA3AF"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(hex: "F3F4F6"))
                        .cornerRadius(8)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(avoidIngredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(hex: "8B5CF6"))
                                .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Close Button
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Close")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(hex: "8B5CF6"))
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Helper Functions
    private func routinePreferencesField(title: String, value: Binding<String>, isEditable: Bool, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "6B7280"))
            
            if isEditable {
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            value.wrappedValue = option
                        }
                    }
                } label: {
                    HStack {
                        Text(value.wrappedValue.isEmpty ? "Select \(title)" : value.wrappedValue)
                            .foregroundColor(value.wrappedValue.isEmpty ? Color(hex: "9CA3AF") : Color(hex: "111111"))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "D1D5DB"), lineWidth: 1)
                    )
                }
            } else {
                Text(value.wrappedValue.isEmpty ? "Not specified" : value.wrappedValue)
                    .font(.system(size: 16))
                    .foregroundColor(value.wrappedValue.isEmpty ? Color(hex: "9CA3AF") : Color(hex: "111111"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color(hex: "F3F4F6"))
                    .cornerRadius(8)
            }
        }
    }
    
    private func toggleIngredient(_ ingredient: String) {
        if avoidIngredients.contains(ingredient) {
            avoidIngredients.removeAll { $0 == ingredient }
        } else {
            avoidIngredients.append(ingredient)
        }
    }
    
    private func loadPreferencesData() {
        // Load survey data from UserDefaults
        budget = UserDefaults.standard.string(forKey: "survey_budget") ?? "Balanced Value"
        isPregnantOrBreastfeeding = UserDefaults.standard.bool(forKey: "survey_pregnancy_status")
        
        // Load avoid ingredients
        if let ingredientsData = UserDefaults.standard.data(forKey: "survey_avoid_ingredients"),
           let ingredients = try? JSONDecoder().decode([String].self, from: ingredientsData) {
            avoidIngredients = ingredients
        } else {
            // Default ingredients to avoid
            avoidIngredients = ["Sulfates (SLS, etc.)", "Parabens"]
        }
    }
    
    private func savePreferences() {
        // Save updated data to UserDefaults
        UserDefaults.standard.set(budget, forKey: "survey_budget")
        UserDefaults.standard.set(isPregnantOrBreastfeeding, forKey: "survey_pregnancy_status")
        
        // Save avoid ingredients
        if let ingredientsData = try? JSONEncoder().encode(avoidIngredients) {
            UserDefaults.standard.set(ingredientsData, forKey: "survey_avoid_ingredients")
        }
        
        showingSaveAlert = true
    }
}

// MARK: - Scan Data Models
struct ProductScan: Identifiable, Codable {
    let id = UUID()
    let productId: String
    let productName: String
    let productBrand: String
    let productImage: String
    let scanDate: Date
    let productCategory: String
    let productPrice: String
    let productRating: Double
    let productDescription: String
    let ingredients: [String]
    let skinTypeCompatibility: [String]
    let flaggedIngredients: [String]
    
    init(productId: String, productName: String, productBrand: String, productImage: String, scanDate: Date, productCategory: String, productPrice: String, productRating: Double, productDescription: String, ingredients: [String], skinTypeCompatibility: [String], flaggedIngredients: [String]) {
        self.productId = productId
        self.productName = productName
        self.productBrand = productBrand
        self.productImage = productImage
        self.scanDate = scanDate
        self.productCategory = productCategory
        self.productPrice = productPrice
        self.productRating = productRating
        self.productDescription = productDescription
        self.ingredients = ingredients
        self.skinTypeCompatibility = skinTypeCompatibility
        self.flaggedIngredients = flaggedIngredients
    }
}

@MainActor
class ScanHistoryViewModel: ObservableObject {
    @Published var scans: [ProductScan] = []
    
    private let userDefaults = UserDefaults.standard
    private let scansKey = "ProductScans"
    
    init() {
        loadScans()
    }
    
    func addScan(_ scan: ProductScan) {
        scans.append(scan)
        saveScans()
    }
    
    func removeScan(_ scan: ProductScan) {
        scans.removeAll { $0.id == scan.id }
        saveScans()
    }
    
    func clearAllScans() {
        scans.removeAll()
        saveScans()
    }
    
    private func saveScans() {
        do {
            let data = try JSONEncoder().encode(scans)
            userDefaults.set(data, forKey: scansKey)
        } catch {
            print("Failed to save scans: \(error)")
        }
    }
    
    private func loadScans() {
        guard let data = userDefaults.data(forKey: scansKey) else { return }
        do {
            scans = try JSONDecoder().decode([ProductScan].self, from: data)
        } catch {
            print("Failed to load scans: \(error)")
        }
    }
}

// MARK: - My Scans View
struct MyScansView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scanViewModel = ScanHistoryViewModel()
    @State private var showingClearAlert = false
    @State private var selectedScan: ProductScan?
    @State private var showingProductDetail = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if scanViewModel.scans.isEmpty {
                    emptyStateView
                } else {
                    scansListView
                }
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("My Scans")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
                
                if !scanViewModel.scans.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            showingClearAlert = true
                        }
                        .foregroundColor(Color(hex: "8B5CF6"))
                    }
                }
            })
        }
        .onAppear {
            addDummyScansIfNeeded()
        }
        .alert("Clear All Scans", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                scanViewModel.clearAllScans()
            }
        } message: {
            Text("Are you sure you want to clear all your scan history? This action cannot be undone.")
        }
        .sheet(isPresented: $showingProductDetail) {
            if let selectedScan = selectedScan {
                ProductDetailViewContent(product: convertScanToProduct(selectedScan))
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color(hex: "8B5CF6").opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 48))
                    .foregroundColor(Color(hex: "8B5CF6"))
            }
            
            VStack(spacing: 12) {
                Text("No Scans Yet")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "1F2937"))
                
                Text("Start scanning products to see them here. Your scan history will help you track the products you've analyzed.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "6B7280"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
    
    private var scansListView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 16) {
                ForEach(scanViewModel.scans.sorted(by: { $0.scanDate > $1.scanDate })) { scan in
                    scanCardView(scan)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func scanCardView(_ scan: ProductScan) -> some View {
        Button(action: {
            selectedScan = scan
            showingProductDetail = true
        }) {
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: scan.productImage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(hex: "E5E7EB"))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(Color(hex: "9CA3AF"))
                        )
                }
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(scan.productBrand)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "8B5CF6"))
                        
                        Spacer()
                        
                        Text(scan.productPrice)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "1F2937"))
                    }
                    
                    Text(scan.productName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "1F2937"))
                        .lineLimit(2)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "F59E0B"))
                            
                            Text(String(format: "%.1f", scan.productRating))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "6B7280"))
                        }
                        
                        Spacer()
                        
                        Text(scan.scanDate.formatted(.dateTime.day().month().year()))
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "9CA3AF"))
                    }
                    
                    if !scan.flaggedIngredients.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "EF4444"))
                            
                            Text("\(scan.flaggedIngredients.count) flagged ingredient\(scan.flaggedIngredients.count == 1 ? "" : "s")")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color(hex: "EF4444"))
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func addDummyScansIfNeeded() {
        if scanViewModel.scans.isEmpty {
            let dummyScans = [
                ProductScan(
                    productId: "1",
                    productName: "Hyaluronic Acid Serum",
                    productBrand: "The Ordinary",
                    productImage: "https://example.com/serum1.jpg",
                    scanDate: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                    productCategory: "Serum",
                    productPrice: "$12.90",
                    productRating: 4.5,
                    productDescription: "A hydrating serum with hyaluronic acid for plump, hydrated skin.",
                    ingredients: ["Hyaluronic Acid", "Water", "Glycerin"],
                    skinTypeCompatibility: ["Dry", "Normal", "Combination"],
                    flaggedIngredients: ["Parabens"]
                ),
                ProductScan(
                    productId: "2",
                    productName: "Vitamin C Brightening Cream",
                    productBrand: "CeraVe",
                    productImage: "https://example.com/cream1.jpg",
                    scanDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                    productCategory: "Moisturizer",
                    productPrice: "$18.50",
                    productRating: 4.2,
                    productDescription: "Brightening moisturizer with vitamin C and ceramides.",
                    ingredients: ["Vitamin C", "Ceramides", "Niacinamide"],
                    skinTypeCompatibility: ["Normal", "Combination", "Oily"],
                    flaggedIngredients: []
                ),
                ProductScan(
                    productId: "3",
                    productName: "Gentle Foaming Cleanser",
                    productBrand: "Cetaphil",
                    productImage: "https://example.com/cleanser1.jpg",
                    scanDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                    productCategory: "Cleanser",
                    productPrice: "$9.99",
                    productRating: 4.7,
                    productDescription: "Gentle foaming cleanser for sensitive skin.",
                    ingredients: ["Water", "Glycerin", "Sodium Lauryl Sulfate"],
                    skinTypeCompatibility: ["Sensitive", "Normal"],
                    flaggedIngredients: ["Sodium Lauryl Sulfate"]
                )
            ]
            
            for scan in dummyScans {
                scanViewModel.addScan(scan)
            }
        }
    }
    
    private func convertScanToProduct(_ scan: ProductScan) -> Product {
        // Extract price from string (remove $ and convert to Double)
        let priceString = scan.productPrice.replacingOccurrences(of: "$", with: "")
        let price = Double(priceString) ?? 0.0
        
        print("🔍 Converting scan to product: \(scan.productName)")
        
        return Product(
            name: scan.productName,
            brand: scan.productBrand,
            category: ProductCategory(rawValue: scan.productCategory) ?? .cleanser,
            price: price,
            currency: "$",
            imageURL: scan.productImage,
            description: scan.productDescription,
            ingredients: scan.ingredients,
            skinTypes: scan.skinTypeCompatibility.compactMap { SkinType(rawValue: $0) },
            rating: scan.productRating,
            reviewCount: Int.random(in: 50...500),
            size: "50ml",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: scan.productRating >= 4.0,
            benefits: ["Hydrating", "Gentle"],
            howToUse: "Apply to clean skin morning and evening",
            warnings: scan.flaggedIngredients,
            potentiallyIrritatingIngredients: scan.flaggedIngredients,
            certifications: ["Dermatologically Tested"]
        )
    }
}

// MARK: - Face Scan Model
struct FaceScan: Identifiable, Codable {
    let id = UUID()
    let imageData: Data?
    let scanDate: Date
    let scanTime: Date
    let analysisResults: [String]
    let skinCondition: String
    let recommendations: [String]
    
    init(imageData: Data?, scanDate: Date, scanTime: Date, analysisResults: [String] = [], skinCondition: String = "Normal", recommendations: [String] = []) {
        self.imageData = imageData
        self.scanDate = scanDate
        self.scanTime = scanTime
        self.analysisResults = analysisResults
        self.skinCondition = skinCondition
        self.recommendations = recommendations
    }
}

// MARK: - Face Scans ViewModel
@MainActor
class FaceScansViewModel: ObservableObject {
    @Published var faceScans: [FaceScan] = []
    @Published var selectedDate: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let faceScansKey = "FaceScans"
    
    init() {
        loadFaceScans()
    }
    
    func addFaceScan(_ scan: FaceScan) {
        faceScans.append(scan)
        saveFaceScans()
    }
    
    func removeFaceScan(_ scan: FaceScan) {
        faceScans.removeAll { $0.id == scan.id }
        saveFaceScans()
    }
    
    func clearAllFaceScans() {
        faceScans.removeAll()
        saveFaceScans()
    }
    
    func getFaceScansForDate(_ date: Date) -> [FaceScan] {
        let calendar = Calendar.current
        return faceScans.filter { scan in
            calendar.isDate(scan.scanDate, inSameDayAs: date)
        }
    }
    
    func getFaceScansForMonth(_ date: Date) -> [FaceScan] {
        let calendar = Calendar.current
        return faceScans.filter { scan in
            calendar.isDate(scan.scanDate, equalTo: date, toGranularity: .month)
        }
    }
    
    private func saveFaceScans() {
        do {
            let data = try JSONEncoder().encode(faceScans)
            userDefaults.set(data, forKey: faceScansKey)
        } catch {
            print("Failed to save face scans: \(error)")
        }
    }
    
    private func loadFaceScans() {
        guard let data = userDefaults.data(forKey: faceScansKey) else { return }
        do {
            faceScans = try JSONDecoder().decode([FaceScan].self, from: data)
        } catch {
            print("Failed to load face scans: \(error)")
        }
    }
}

// MARK: - Face Scans View
struct FaceScansView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var faceScansViewModel = FaceScansViewModel()
    @State private var showingClearAlert = false
    @State private var selectedScan: FaceScan?
    @State private var showingScanDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Date Selector
                dateSelectorView
                
                // Face Scans List
                if faceScansViewModel.getFaceScansForDate(faceScansViewModel.selectedDate).isEmpty {
                    emptyStateView
                } else {
                    faceScansListView
                }
            }
            .background(Color(hex: "F8F8F8"))
            .navigationTitle("Face Scans")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                }
                
                if !faceScansViewModel.faceScans.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear All") {
                            showingClearAlert = true
                        }
                        .foregroundColor(Color(hex: "8B5CF6"))
                    }
                }
            })
        }
        .onAppear {
            addDummyFaceScansIfNeeded()
        }
        .alert("Clear All Face Scans", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                faceScansViewModel.clearAllFaceScans()
            }
        } message: {
            Text("Are you sure you want to clear all your face scan history? This action cannot be undone.")
        }
        .sheet(isPresented: $showingScanDetail) {
            if let selectedScan = selectedScan {
                FaceScanDetailView(faceScan: selectedScan)
            }
        }
    }
    
    private var dateSelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    dateButton(for: date)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private func dateButton(for date: Date) -> some View {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let isSelected = calendar.isDate(date, inSameDayAs: faceScansViewModel.selectedDate)
        let hasScans = !faceScansViewModel.getFaceScansForDate(date).isEmpty
        
        return Button(action: {
            faceScansViewModel.selectedDate = date
        }) {
            VStack(spacing: 4) {
                Text("\(day)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                
                if hasScans {
                    Circle()
                        .fill(Color(hex: "8B5CF6"))
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 40, height: 50)
            .background(
                Circle()
                    .fill(isSelected ? Color(hex: "8B5CF6") : Color.clear)
            )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "viewfinder")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "8B5CF6"))
            
            Text("No Scans for This Date")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Select a different date to view your face scans, or start scanning your face to track your skin's progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var faceScansListView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 12) {
                ForEach(faceScansViewModel.getFaceScansForDate(faceScansViewModel.selectedDate)) { scan in
                    faceScanCardView(scan)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private func faceScanCardView(_ scan: FaceScan) -> some View {
        Button(action: {
            selectedScan = scan
            showingScanDetail = true
        }) {
            HStack(spacing: 16) {
                // Face Image
                if let imageData = scan.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
                
                // Scan Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatDate(scan.scanDate))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(formatTime(scan.scanTime))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Navigation Arrow
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getDaysInMonth() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let range = calendar.range(of: .day, in: .month, for: now)!
        let days = range.compactMap { day -> Date? in
            var components = calendar.dateComponents([.year, .month], from: now)
            components.day = day
            return calendar.date(from: components)
        }
        return days
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func addDummyFaceScansIfNeeded() {
        if faceScansViewModel.faceScans.isEmpty {
            let calendar = Calendar.current
            let now = Date()
            
            // Create realistic face scan images
            let realisticFaceImage1 = createRealisticFaceImage(style: "natural", name: "Morning")
            let realisticFaceImage2 = createRealisticFaceImage(style: "glowing", name: "Evening")
            let realisticFaceImage3 = createRealisticFaceImage(style: "fresh", name: "Afternoon")
            let realisticFaceImage4 = createRealisticFaceImage(style: "relaxed", name: "Night")
            let realisticFaceImage5 = createRealisticFaceImage(style: "weekend", name: "Weekend")
            let realisticFaceImage6 = createRealisticFaceImage(style: "holiday", name: "Holiday")
            let realisticFaceImage7 = createRealisticFaceImage(style: "special", name: "Special")
            let realisticFaceImage8 = createRealisticFaceImage(style: "routine", name: "Routine")
            
            // Create dummy face scans for different dates and times
            let dummyScans = [
                // Today's scans
                FaceScan(
                    imageData: realisticFaceImage1,
                    scanDate: now,
                    scanTime: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
                    analysisResults: ["Hydration: Good", "Texture: Smooth", "Tone: Even", "Pores: Normal"],
                    skinCondition: "Normal",
                    recommendations: ["Continue current routine", "Add vitamin C serum", "Use SPF daily"]
                ),
                FaceScan(
                    imageData: realisticFaceImage2,
                    scanDate: now,
                    scanTime: calendar.date(byAdding: .hour, value: -6, to: now) ?? now,
                    analysisResults: ["Hydration: Excellent", "Texture: Very Smooth", "Tone: Even", "Pores: Minimized"],
                    skinCondition: "Excellent",
                    recommendations: ["Maintain current routine", "Consider adding retinol", "Keep hydrated"]
                ),
                
                // Yesterday
                FaceScan(
                    imageData: realisticFaceImage3,
                    scanDate: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -1, to: now) ?? now,
                    analysisResults: ["Hydration: Good", "Texture: Smooth", "Tone: Slightly Uneven", "Pores: Visible"],
                    skinCondition: "Good",
                    recommendations: ["Increase hydration", "Use gentle exfoliant", "Apply moisturizer"]
                ),
                
                // 2 days ago
                FaceScan(
                    imageData: realisticFaceImage4,
                    scanDate: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -3, to: now) ?? now,
                    analysisResults: ["Hydration: Fair", "Texture: Rough", "Tone: Uneven", "Pores: Enlarged"],
                    skinCondition: "Needs Attention",
                    recommendations: ["Increase water intake", "Use hydrating mask", "Avoid harsh products"]
                ),
                
                // 3 days ago
                FaceScan(
                    imageData: realisticFaceImage5,
                    scanDate: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -4, to: now) ?? now,
                    analysisResults: ["Hydration: Excellent", "Texture: Very Smooth", "Tone: Even", "Pores: Minimized"],
                    skinCondition: "Excellent",
                    recommendations: ["Maintain current routine", "Consider adding retinol", "Keep consistent"]
                ),
                
                // 5 days ago
                FaceScan(
                    imageData: realisticFaceImage6,
                    scanDate: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
                    analysisResults: ["Hydration: Good", "Texture: Smooth", "Tone: Even", "Pores: Normal"],
                    skinCondition: "Normal",
                    recommendations: ["Continue current routine", "Add vitamin C serum", "Use gentle cleanser"]
                ),
                
                // 7 days ago
                FaceScan(
                    imageData: realisticFaceImage7,
                    scanDate: calendar.date(byAdding: .day, value: -7, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -1, to: now) ?? now,
                    analysisResults: ["Hydration: Fair", "Texture: Rough", "Tone: Uneven", "Pores: Enlarged"],
                    skinCondition: "Needs Attention",
                    recommendations: ["Increase hydration", "Use gentle exfoliant", "Apply night cream"]
                ),
                
                // 10 days ago
                FaceScan(
                    imageData: realisticFaceImage8,
                    scanDate: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                    scanTime: calendar.date(byAdding: .hour, value: -3, to: now) ?? now,
                    analysisResults: ["Hydration: Good", "Texture: Smooth", "Tone: Even", "Pores: Normal"],
                    skinCondition: "Normal",
                    recommendations: ["Continue current routine", "Add vitamin C serum", "Use SPF daily"]
                )
            ]
            
            for scan in dummyScans {
                faceScansViewModel.addFaceScan(scan)
            }
        }
    }
    
    private func createRealisticFaceImage(style: String, name: String) -> Data? {
        let size = CGSize(width: 300, height: 300)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let cgContext = context.cgContext
            
            // Background - soft gradient based on style
            let backgroundColor: UIColor
            switch style {
            case "natural":
                backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0)
            case "glowing":
                backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.95, alpha: 1.0)
            case "fresh":
                backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.96, alpha: 1.0)
            case "relaxed":
                backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.97, alpha: 1.0)
            case "weekend":
                backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
            case "holiday":
                backgroundColor = UIColor(red: 0.99, green: 0.98, blue: 0.96, alpha: 1.0)
            case "special":
                backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 0.98, alpha: 1.0)
            case "routine":
                backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.96, alpha: 1.0)
            default:
                backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0)
            }
            
            backgroundColor.setFill()
            cgContext.fill(CGRect(origin: .zero, size: size))
            
            // Face outline - more realistic oval
            let faceRect = CGRect(x: 75, y: 60, width: 150, height: 180)
            let facePath = UIBezierPath(ovalIn: faceRect)
            
            // Realistic skin tone with subtle variations
            let skinTone: UIColor
            switch style {
            case "natural", "routine":
                skinTone = UIColor(red: 0.96, green: 0.92, blue: 0.88, alpha: 1.0)
            case "glowing", "special":
                skinTone = UIColor(red: 0.98, green: 0.94, blue: 0.90, alpha: 1.0)
            case "fresh", "holiday":
                skinTone = UIColor(red: 0.97, green: 0.93, blue: 0.89, alpha: 1.0)
            case "relaxed", "weekend":
                skinTone = UIColor(red: 0.95, green: 0.91, blue: 0.87, alpha: 1.0)
            default:
                skinTone = UIColor(red: 0.96, green: 0.92, blue: 0.88, alpha: 1.0)
            }
            
            skinTone.setFill()
            facePath.fill()
            
            // Subtle face contour
            UIColor(red: 0.94, green: 0.90, blue: 0.86, alpha: 0.3).setStroke()
            facePath.lineWidth = 1
            facePath.stroke()
            
            // Hair - more realistic
            let hairRect = CGRect(x: 70, y: 50, width: 160, height: 40)
            let hairPath = UIBezierPath(ovalIn: hairRect)
            
            let hairColor: UIColor
            switch style {
            case "natural", "routine":
                hairColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.9)
            case "glowing", "special":
                hairColor = UIColor(red: 0.7, green: 0.5, blue: 0.3, alpha: 0.9)
            case "fresh", "holiday":
                hairColor = UIColor(red: 0.65, green: 0.45, blue: 0.25, alpha: 0.9)
            case "relaxed", "weekend":
                hairColor = UIColor(red: 0.55, green: 0.35, blue: 0.15, alpha: 0.9)
            default:
                hairColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.9)
            }
            
            hairColor.setFill()
            hairPath.fill()
            
            // Eyes - more detailed
            let leftEyeRect = CGRect(x: 105, y: 110, width: 20, height: 12)
            let rightEyeRect = CGRect(x: 175, y: 110, width: 20, height: 12)
            let leftEyePath = UIBezierPath(ovalIn: leftEyeRect)
            let rightEyePath = UIBezierPath(ovalIn: rightEyeRect)
            
            UIColor.white.setFill()
            leftEyePath.fill()
            rightEyePath.fill()
            
            // Eye pupils - blue eyes like in the photo
            let leftPupilRect = CGRect(x: 110, y: 113, width: 10, height: 6)
            let rightPupilRect = CGRect(x: 180, y: 113, width: 10, height: 6)
            UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).setFill()
            cgContext.fill(leftPupilRect)
            cgContext.fill(rightPupilRect)
            
            // Eyebrows - more natural
            let leftEyebrowPath = UIBezierPath()
            leftEyebrowPath.move(to: CGPoint(x: 100, y: 100))
            leftEyebrowPath.addQuadCurve(to: CGPoint(x: 120, y: 98), controlPoint: CGPoint(x: 110, y: 95))
            
            let rightEyebrowPath = UIBezierPath()
            rightEyebrowPath.move(to: CGPoint(x: 180, y: 98))
            rightEyebrowPath.addQuadCurve(to: CGPoint(x: 200, y: 100), controlPoint: CGPoint(x: 190, y: 95))
            
            hairColor.withAlphaComponent(0.8).setStroke()
            leftEyebrowPath.lineWidth = 3
            rightEyebrowPath.lineWidth = 3
            leftEyebrowPath.stroke()
            rightEyebrowPath.stroke()
            
            // Nose - more subtle
            let nosePath = UIBezierPath()
            nosePath.move(to: CGPoint(x: 150, y: 130))
            nosePath.addQuadCurve(to: CGPoint(x: 145, y: 160), controlPoint: CGPoint(x: 142, y: 145))
            nosePath.addQuadCurve(to: CGPoint(x: 155, y: 160), controlPoint: CGPoint(x: 158, y: 145))
            nosePath.addQuadCurve(to: CGPoint(x: 150, y: 130), controlPoint: CGPoint(x: 150, y: 145))
            nosePath.close()
            
            UIColor(red: 0.94, green: 0.90, blue: 0.86, alpha: 0.4).setFill()
            nosePath.fill()
            UIColor(red: 0.92, green: 0.88, blue: 0.84, alpha: 0.6).setStroke()
            nosePath.lineWidth = 1
            nosePath.stroke()
            
            // Mouth - natural pink
            let mouthRect = CGRect(x: 130, y: 180, width: 40, height: 16)
            let mouthPath = UIBezierPath(ovalIn: mouthRect)
            UIColor(red: 0.9, green: 0.6, blue: 0.6, alpha: 1.0).setFill()
            mouthPath.fill()
            
            // Cheeks - subtle blush
            let leftCheekRect = CGRect(x: 90, y: 140, width: 25, height: 20)
            let rightCheekRect = CGRect(x: 185, y: 140, width: 25, height: 20)
            let leftCheekPath = UIBezierPath(ovalIn: leftCheekRect)
            let rightCheekPath = UIBezierPath(ovalIn: rightCheekRect)
            
            UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.3).setFill()
            leftCheekPath.fill()
            rightCheekPath.fill()
            
            // Add subtle glow effect for certain styles
            if style == "glowing" || style == "special" {
                let glowRect = CGRect(x: 80, y: 55, width: 140, height: 190)
                let glowPath = UIBezierPath(ovalIn: glowRect)
                UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 0.2).setFill()
                glowPath.fill()
            }
            
            // Add name tag with better styling
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.white
            ]
            let textSize = name.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width - 12) / 2,
                y: size.height - 35,
                width: textSize.width + 12,
                height: textSize.height + 6
            )
            
            // Text background with rounded corners
            let textBgPath = UIBezierPath(roundedRect: textRect, cornerRadius: 6)
            UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8).setFill()
            textBgPath.fill()
            
            // Text
            let textDrawRect = CGRect(
                x: textRect.origin.x + 6,
                y: textRect.origin.y + 3,
                width: textSize.width,
                height: textSize.height
            )
            name.draw(in: textDrawRect, withAttributes: attributes)
        }
        
        return image.pngData()
    }
    
    private func createDummyFaceImage(color: UIColor, name: String) -> Data? {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let cgContext = context.cgContext
            
            // Background gradient
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: [color.withAlphaComponent(0.1).cgColor, color.withAlphaComponent(0.3).cgColor] as CFArray,
                                    locations: [0.0, 1.0])!
            cgContext.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
            
            // Face outline (oval shape)
            let faceRect = CGRect(x: 50, y: 40, width: 100, height: 120)
            let facePath = UIBezierPath(ovalIn: faceRect)
            
            // Face skin color (light beige)
            UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.0).setFill()
            facePath.fill()
            
            // Face border
            color.setStroke()
            facePath.lineWidth = 2
            facePath.stroke()
            
            // Hair
            let hairRect = CGRect(x: 45, y: 35, width: 110, height: 30)
            let hairPath = UIBezierPath(ovalIn: hairRect)
            color.withAlphaComponent(0.8).setFill()
            hairPath.fill()
            
            // Eyes
            let leftEyeRect = CGRect(x: 65, y: 75, width: 12, height: 8)
            let rightEyeRect = CGRect(x: 123, y: 75, width: 12, height: 8)
            let leftEyePath = UIBezierPath(ovalIn: leftEyeRect)
            let rightEyePath = UIBezierPath(ovalIn: rightEyeRect)
            
            UIColor.white.setFill()
            leftEyePath.fill()
            rightEyePath.fill()
            
            // Eye pupils
            let leftPupilRect = CGRect(x: 68, y: 77, width: 6, height: 4)
            let rightPupilRect = CGRect(x: 126, y: 77, width: 6, height: 4)
            UIColor.black.setFill()
            context.fill(leftPupilRect)
            context.fill(rightPupilRect)
            
            // Eyebrows
            let leftEyebrowPath = UIBezierPath()
            leftEyebrowPath.move(to: CGPoint(x: 60, y: 70))
            leftEyebrowPath.addQuadCurve(to: CGPoint(x: 75, y: 68), controlPoint: CGPoint(x: 67, y: 65))
            
            let rightEyebrowPath = UIBezierPath()
            rightEyebrowPath.move(to: CGPoint(x: 125, y: 68))
            rightEyebrowPath.addQuadCurve(to: CGPoint(x: 140, y: 70), controlPoint: CGPoint(x: 133, y: 65))
            
            color.withAlphaComponent(0.7).setStroke()
            leftEyebrowPath.lineWidth = 2
            rightEyebrowPath.lineWidth = 2
            leftEyebrowPath.stroke()
            rightEyebrowPath.stroke()
            
            // Nose
            let nosePath = UIBezierPath()
            nosePath.move(to: CGPoint(x: 100, y: 90))
            nosePath.addQuadCurve(to: CGPoint(x: 95, y: 110), controlPoint: CGPoint(x: 92, y: 100))
            nosePath.addQuadCurve(to: CGPoint(x: 105, y: 110), controlPoint: CGPoint(x: 108, y: 100))
            nosePath.addQuadCurve(to: CGPoint(x: 100, y: 90), controlPoint: CGPoint(x: 100, y: 100))
            nosePath.close()
            
            color.withAlphaComponent(0.3).setFill()
            nosePath.fill()
            color.withAlphaComponent(0.6).setStroke()
            nosePath.lineWidth = 1
            nosePath.stroke()
            
            // Mouth
            let mouthRect = CGRect(x: 85, y: 125, width: 30, height: 12)
            let mouthPath = UIBezierPath(ovalIn: mouthRect)
            UIColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0).setFill()
            mouthPath.fill()
            
            // Cheeks (subtle blush)
            let leftCheekRect = CGRect(x: 55, y: 100, width: 15, height: 10)
            let rightCheekRect = CGRect(x: 130, y: 100, width: 15, height: 10)
            let leftCheekPath = UIBezierPath(ovalIn: leftCheekRect)
            let rightCheekPath = UIBezierPath(ovalIn: rightCheekRect)
            
            UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 0.3).setFill()
            leftCheekPath.fill()
            rightCheekPath.fill()
            
            // Add name text with background
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let textSize = name.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width - 8) / 2,
                y: size.height - 30,
                width: textSize.width + 8,
                height: textSize.height + 4
            )
            
            // Text background
            let textBgPath = UIBezierPath(roundedRect: textRect, cornerRadius: 4)
            color.setFill()
            textBgPath.fill()
            
            // Text
            let textDrawRect = CGRect(
                x: textRect.origin.x + 4,
                y: textRect.origin.y + 2,
                width: textSize.width,
                height: textSize.height
            )
            name.draw(in: textDrawRect, withAttributes: attributes)
        }
        
        return image.pngData()
    }
}

// MARK: - Face Scan Detail View
struct FaceScanDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let faceScan: FaceScan
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        // Face Image
                    if let imageData = faceScan.imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    // Scan Information
                    VStack(alignment: .leading, spacing: 16) {
                        // Date and Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Scan Details")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text("Date:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(formatDate(faceScan.scanDate))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Time:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(formatTime(faceScan.scanTime))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Analysis Results
                        if !faceScan.analysisResults.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Analysis Results")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ForEach(faceScan.analysisResults, id: \.self) { result in
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color(hex: "8B5CF6"))
                                        Text(result)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Recommendations
                        if !faceScan.recommendations.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recommendations")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ForEach(faceScan.recommendations, id: \.self) { recommendation in
                                    HStack {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundColor(.orange)
                                        Text(recommendation)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 16)
                }
                .background(Color(hex: "F8F8F8"))
                
                // Floating Close Button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.6))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 16)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Face Scan Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "8B5CF6"))
                    .font(.system(size: 16, weight: .medium))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "8B5CF6"))
                    }
                }
            })
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}