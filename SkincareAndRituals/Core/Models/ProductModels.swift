import Foundation

// MARK: - Product Category
enum ProductCategory: String, CaseIterable, Identifiable {
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
    
    var description: String {
        switch self {
        case .cleanser: return "Temizleyici ürünler"
        case .moisturizer: return "Nemlendirici ürünler"
        case .serum: return "Serum ve konsantreler"
        case .sunscreen: return "Güneş koruyucuları"
        case .toner: return "Tonik ve dengeleyiciler"
        case .exfoliant: return "Peeling ürünleri"
        case .mask: return "Maskeler"
        case .eyeCare: return "Göz bakım ürünleri"
        case .lipCare: return "Dudak bakım ürünleri"
        case .all: return "Tüm ürünler"
        }
    }
}

// MARK: - Skin Type
enum SkinType: String, CaseIterable {
    case normal = "Normal"
    case dry = "Dry"
    case oily = "Oily"
    case combination = "Combination"
    case sensitive = "Sensitive"
    case acneProne = "Acne Prone"
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
