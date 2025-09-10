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
            skinTypes: [.normal, .dry, .sensitive],
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
            skinTypes: [.oily, .combination, .acneProne],
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
            description: "Lightweight and fast-absorbing moisturizer for daily use.",
            ingredients: ["Glycerin", "Dimethicone", "Vitamin E"],
            skinTypes: [.normal, .dry, .combination],
            rating: 4.3,
            reviewCount: 2156,
            size: "200ml",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: true,
            benefits: ["24-hour hydration", "Fast absorption", "Daily use"],
            howToUse: "Apply to clean skin morning and evening.",
            warnings: [],
            potentiallyIrritatingIngredients: ["Fragrances/Parfumes", "Parabens"]
        ),
        
        Product(
            name: "Hyaluronic Acid Moisturizer",
            brand: "The Inkey List",
            category: .moisturizer,
            price: 14.99,
            currency: "$",
            imageURL: nil,
            description: "Intensive moisturizing cream with hyaluronic acid.",
            ingredients: ["Hyaluronic Acid", "Squalane", "Ceramides"],
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.4,
            reviewCount: 743,
            size: "50ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Intensive hydration", "Strengthens skin barrier", "Suitable for sensitive skin"],
            howToUse: "Apply to clean skin 1-2 times daily.",
            warnings: [],
            potentiallyIrritatingIngredients: [],
            certifications: ["Cruelty-free", "Vegan", "Dermatologically Tested"],
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
            description: "Vitamin C serum for bright and even-toned skin.",
            ingredients: ["Vitamin C", "Vitamin E", "Ferulic Acid"],
            skinTypes: [.normal, .dry, .combination],
            rating: 4.6,
            reviewCount: 1843,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Anti-aging", "Brightness", "Even tone"],
            howToUse: "Apply to clean skin in the morning, use sunscreen.",
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
            description: "Niacinamide serum for pore reduction and oil control.",
            ingredients: ["Niacinamide", "Zinc PCA"],
            skinTypes: [.oily, .combination, .acneProne],
            rating: 4.1,
            reviewCount: 3247,
            size: "30ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Pore control", "Oil reduction", "Acne prevention"],
            howToUse: "Apply to clean skin in the evening.",
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
            description: "Lightweight and fast-absorbing sunscreen for daily use.",
            ingredients: ["Zinc Oxide", "Octinoxate", "Hyaluronic Acid"],
            skinTypes: [.normal, .dry, .sensitive],
            rating: 4.7,
            reviewCount: 1567,
            size: "48g",
            isCrueltyFree: true,
            isVegan: false,
            isRecommended: true,
            benefits: ["SPF 46", "Lightweight formula", "Suitable for sensitive skin"],
            howToUse: "Apply 15 minutes before sun exposure.",
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
            description: "Clear zinc oxide sunscreen for acne-prone skin.",
            ingredients: ["Zinc Oxide", "Helioplex Technology"],
            skinTypes: [.oily, .combination, .acneProne],
            rating: 4.0,
            reviewCount: 892,
            size: "88ml",
            isCrueltyFree: false,
            isVegan: false,
            isRecommended: false,
            benefits: ["SPF 30", "Acne-friendly", "Clear formula"],
            howToUse: "Apply 15 minutes before sun exposure.",
            warnings: ["Reapply every 2 hours"],
            potentiallyIrritatingIngredients: [],
            certifications: ["Non-comedogenic"]
        ),
        
        // Toners
        Product(
            name: "Glycolic Acid 7% Toning Solution",
            brand: "The Ordinary",
            category: .toner,
            price: 8.70,
            currency: "$",
            imageURL: nil,
            description: "Glycolic acid toner for skin renewal and brightness.",
            ingredients: ["Glycolic Acid", "Tasmanian Pepperberry"],
            skinTypes: [.normal, .combination, .oily],
            rating: 4.3,
            reviewCount: 2156,
            size: "240ml",
            isCrueltyFree: true,
            isVegan: true,
            isRecommended: true,
            benefits: ["Skin renewal", "Brightness", "Pore cleansing"],
            howToUse: "Apply with cotton pad after evening cleansing.",
            warnings: ["May cause sun sensitivity", "Use sunscreen"],
            potentiallyIrritatingIngredients: ["Glycolic Acid", "Drying Alcohols"],
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
