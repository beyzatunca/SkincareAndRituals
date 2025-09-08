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
            description: "Hassas ciltler için nazik köpüklü temizleyici. Cildi temizlerken nemlendirir.",
            ingredients: ["Ceramides", "Hyaluronic Acid", "Niacinamide"],
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.5,
            reviewCount: 1247,
            size: "236ml",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: true,
            benefits: ["Temizler", "Nemlendirir", "Hassas ciltler için uygun"],
            howToUse: "Sabah ve akşam ıslak cilde uygulayın, köpürtün ve durulayın.",
            warnings: ["Gözlerle temas ettirmeyin"]
        ),
        
        Product(
            name: "Salicylic Acid Cleanser",
            brand: "The Ordinary",
            category: .cleanser,
            price: 12.90,
            currency: "$",
            imageURL: nil,
            description: "Akne eğilimli ciltler için salisilik asit içeren temizleyici.",
            ingredients: ["Salicylic Acid", "Coconut-derived Surfactants"],
            skinTypes: [.oily, .combination, .acneProne],
            rating: 4.2,
            reviewCount: 892,
            size: "150ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Gözenekleri temizler", "Akne oluşumunu azaltır", "Yağ kontrolü"],
            howToUse: "Günde 1-2 kez ıslak cilde uygulayın ve durulayın.",
            warnings: ["Güneş hassasiyeti yaratabilir", "Güneş koruyucu kullanın"]
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
            warnings: []
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
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.4,
            reviewCount: 743,
            size: "50ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Yoğun nemlendirme", "Cilt bariyerini güçlendirir", "Hassas ciltler için uygun"],
            howToUse: "Temiz cilde günde 1-2 kez uygulayın.",
            warnings: []
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
            warnings: ["Güneş hassasiyeti yaratabilir", "Güneş koruyucu kullanın"]
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
            skinTypes: [.oily, .combination, .acneProne],
            rating: 4.1,
            reviewCount: 3247,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Gözenek kontrolü", "Yağ azaltma", "Akne önleme"],
            howToUse: "Akşam temiz cilde uygulayın.",
            warnings: ["C vitamini ile birlikte kullanmayın"]
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
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.7,
            reviewCount: 1567,
            size: "48g",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: true,
            benefits: ["SPF 46", "Hafif formül", "Hassas ciltler için uygun"],
            howToUse: "Güneşe çıkmadan 15 dakika önce uygulayın.",
            warnings: ["2 saatte bir yenileyin"]
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
            skinTypes: [.oily, .combination, .acneProne],
            rating: 4.0,
            reviewCount: 892,
            size: "88ml",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: false,
            benefits: ["SPF 30", "Akne dostu", "Berrak formül"],
            howToUse: "Güneşe çıkmadan 15 dakika önce uygulayın.",
            warnings: ["2 saatte bir yenileyin"]
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
            warnings: ["Güneş hassasiyeti yaratabilir", "Güneş koruyucu kullanın"]
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
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.2,
            reviewCount: 1847,
            size: "355ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: false,
            benefits: ["Doğal formül", "Yatıştırıcı", "Gözenek sıkılaştırma"],
            howToUse: "Temizlik sonrası pamukla uygulayın.",
            warnings: []
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
            warnings: ["Güçlü formül", "Hassas ciltler için uygun değil", "Güneş koruyucu kullanın"]
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
            warnings: []
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
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.0,
            reviewCount: 1847,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Göz altı torbaları azaltır", "Koyu halkaları hafifletir", "Nemlendirir"],
            howToUse: "Sabah ve akşam göz çevresine nazikçe uygulayın.",
            warnings: ["Gözlerle temas ettirmeyin"]
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
            warnings: []
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
    @State private var showingFaceAnalysis = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Navigation Header
                    NavigationHeader(
                        title: viewModel.currentQuestion.title,
                        subtitle: viewModel.currentQuestion.subtitle,
                        progress: viewModel.progress,
                        showBackButton: viewModel.currentQuestionIndex > 0,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.previousQuestion()
                            }
                        },
                        geometry: geometry
                    )
                    .padding(.top, geometry.size.height * 0.02)
                    
                    // Question Content with ScrollView
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: geometry.size.height * 0.015) {
                            switch viewModel.currentQuestion.type {
                            case .textInput:
                                NameQuestionView(viewModel: viewModel, geometry: geometry)
                            case .singleChoice:
                                if viewModel.currentQuestion.id == 2 {
                                    AgeQuestionView(viewModel: viewModel, geometry: geometry)
                                } else {
                                    SkinTypeQuestionView(viewModel: viewModel, geometry: geometry)
                                }
                                                    case .multipleChoice:
                            if viewModel.currentQuestion.id == 4 {
                                SensitivityQuestionView(viewModel: viewModel, geometry: geometry)
                            } else if viewModel.currentQuestion.id == 5 {
                                SkinConcernsQuestionView(viewModel: viewModel, geometry: geometry)
                            } else if viewModel.currentQuestion.id == 6 {
                                AvoidIngredientsQuestionView(viewModel: viewModel, geometry: geometry)
                            } else if viewModel.currentQuestion.id == 7 {
                                PregnancyQuestionView(viewModel: viewModel, geometry: geometry)
                            } else {
                                SkinConcernsQuestionView(viewModel: viewModel, geometry: geometry)
                            }
                            case .budgetSelection:
                                BudgetQuestionView(viewModel: viewModel, geometry: geometry)
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, geometry.size.height * 0.015)
                        .padding(.bottom, geometry.size.height * 0.15) // More padding for scroll
                    }
                    .frame(maxHeight: geometry.size.height * 0.6) // Limit scroll area height
                    
                    // Bottom Button
                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(
                            viewModel.isLastQuestion ? "Complete Survey" : "Next",
                            isEnabled: viewModel.canProceed
                        ) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if viewModel.isLastQuestion {
                                    showingFaceAnalysis = true
                                } else {
                                    viewModel.nextQuestion()
                                }
                            }
                        }
                        
                        if !viewModel.isLastQuestion {
                            Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.totalQuestions)")
                                .font(.system(size: geometry.size.height * 0.015))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, geometry.size.height * 0.03)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingFaceAnalysis) {
            FaceAnalysisView()
        }
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
            SkinReportView()
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
    @Published var navigateToMainPage: Bool = false
    
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
            self.navigateToMainPage = true
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
            self.navigateToMainPage = true
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
        .fullScreenCover(isPresented: $viewModel.navigateToMainPage) {
            MainTabContainerView()
        }
    }
}

// MARK: - Main Page View
struct MainPageView: View {
    @StateObject private var viewModel = MainPageViewModel()
    
    var body: some View {
        NavigationView {
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
                
                                            ScrollView {
                                VStack(spacing: 20) {
                                    // Personalized Routine Panel
                                    RoutinePanelView()
                                    
                                    // Environmental Panels
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 16) {
                                        UVIndexPanelView(uvIndex: viewModel.uvIndex)
                                        HumidityPanelView(humidity: viewModel.humidity)
                                    }
                                    
                                    PollutionPanelView(pollutionLevel: viewModel.pollutionLevel)
                                }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Skincare & Rituals")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchEnvironmentalData()
        }
    }
}

// MARK: - Main Page View Model
final class MainPageViewModel: ObservableObject {
    @Published var uvIndex: Int = 5
    @Published var humidity: Int = 45
    @Published var pollutionLevel: Int = 25
    
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
        case 3...5: return .yellow
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
        case 51...100: return .yellow
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
                    MainPageView()
                        .tag(AppTab.home)
                    
                    ProductsViewContent()
                        .tag(AppTab.products)
                    
                    ProductScannerView()
                        .tag(AppTab.scan)
                    
                    ExploreRoutinesView()
                        .tag(AppTab.explore)
                    
                    ProfileView()
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

// MARK: - Product Detail View Content
struct ProductDetailViewContent: View {
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
                    Text("Önerilen")
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
            Text("Faydalar")
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
            Text("Kullanım Şekli")
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
                    Text("İçerikler")
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
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(product.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .font(.caption)
                            .foregroundColor(Color(hex: "374151"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "F3F4F6"))
                            .clipShape(Capsule())
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
                            Text("Uyarılar")
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
            Text("Uygun Cilt Tipleri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "111111"))
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(product.skinTypes, id: \.self) { skinType in
                    Text(skinType.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "8B5CF6"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "8B5CF6").opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    // MARK: - Badges Section
    private var badgesSection: some View {
        HStack(spacing: 12) {
            if product.isCrueltyFree {
                badgeView(text: "Cruelty Free", icon: "heart.fill", color: "8B5CF6")
            }
            
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

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Placeholder content
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.primaryColor.opacity(0.3))
                    
                    Text("Profile")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("Manage your account and preferences")
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
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


















