import Foundation

// MARK: - Survey Models
struct SurveyResponse: Codable {
    var name: String = ""
    var age: AgeRange = .age18to24
    var skinType: SkinType = .normal
    var isSensitive: Bool = false
    var skinConcerns: Set<SkinMotivation> = []
    var avoidIngredients: Set<AvoidIngredient> = []
    var isPregnantOrBreastfeeding: Bool = false
    var budget: BudgetRange = .balancedValue
}

// MARK: - Age Range
enum AgeRange: String, CaseIterable, Codable {
    case age13to17 = "13-17"
    case age18to24 = "18-24"
    case age25to34 = "25-34"
    case age35to44 = "35-44"
    case age45to54 = "45-54"
    case age55plus = "55+"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Skin Type
enum SkinType: String, CaseIterable, Codable {
    case oily = "Oily"
    case dry = "Dry"
    case combination = "Combination"
    case normal = "Normal"
    
    var displayName: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .oily:
            return "Shiny, greasy appearance with visible pores"
        case .dry:
            return "Rough, flaky texture with tight feeling"
        case .combination:
            return "Oily T-zone with dry cheeks"
        case .normal:
            return "Balanced, clear, and healthy appearance"
        }
    }
}

// MARK: - Skin Motivation
enum SkinMotivation: String, CaseIterable, Codable, Hashable {
    case acne = "Acne or pimples"
    case wrinkles = "Wrinkles and Fine lines"
    case redness = "Redness or Rosacea"
    case oiliness = "T-zone Oiliness"
    case barrierRepair = "Skin barrier repair"
    case puffyEyes = "Puffy eyes"
    case enlargedPores = "Enlarged pores"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .acne:
            return "circle.slash"
        case .wrinkles:
            return "line.diagonal"
        case .redness:
            return "flame"
        case .oiliness:
            return "drop"
        case .barrierRepair:
            return "shield"
        case .puffyEyes:
            return "eye"
        case .enlargedPores:
            return "circle.grid.2x2"
        }
    }
}

// MARK: - Avoid Ingredients
enum AvoidIngredient: String, CaseIterable, Codable, Hashable {
    case sulfates = "Sulfates (SLS, etc.)"
    case fragrances = "Fragrances / Perfumes"
    case parabens = "Parabens"
    case formaldehyde = "Formaldehyde Releasers"
    case dryingAlcohols = "Drying Alcohols"
    case comedogenics = "Comedogenics"
    case artificialColors = "Artificial Colors"
    case none = "None"
    
    var displayName: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .sulfates:
            return "Provides lather but can weaken skin barrier and cause dryness"
        case .fragrances:
            return "Adds scent but can cause allergies and irritation in sensitive skin"
        case .parabens:
            return "Preservative chemicals that may affect hormone balance long-term"
        case .formaldehyde:
            return "Provides preservation but increases allergy and irritation risk"
        case .dryingAlcohols:
            return "Quickly dissolves oil but can dry and sensitize skin"
        case .comedogenics:
            return "Provides intense moisture but can cause pore clogging and acne"
        case .artificialColors:
            return "Adds color but carries irritation and allergy risk"
        case .none:
            return "I'm tolerant to all of them"
        }
    }
}

// MARK: - Budget Range
enum BudgetRange: String, CaseIterable, Codable {
    case smartSavings = "Smart Savings"
    case balancedValue = "Balanced Value"
    case professionalInnovative = "Professional & Innovative"
    case ultimateCollection = "Ultimate Collection"
    
    var displayName: String {
        return self.rawValue
    }
    
    var priceRange: String {
        switch self {
        case .smartSavings:
            return "€19 and less"
        case .balancedValue:
            return "€20 - €49"
        case .professionalInnovative:
            return "€50 - €99"
        case .ultimateCollection:
            return "€100+"
        }
    }
    
    var description: String {
        switch self {
        case .smartSavings:
            return "Budget-friendly options that deliver results"
        case .balancedValue:
            return "Quality products at reasonable prices"
        case .professionalInnovative:
            return "Advanced formulations with cutting-edge ingredients"
        case .ultimateCollection:
            return "Premium luxury skincare with exceptional results"
        }
    }
}

// MARK: - Survey Question
struct SurveyQuestion {
    let id: Int
    let title: String
    let subtitle: String
    let type: QuestionType
}

enum QuestionType {
    case textInput
    case singleChoice
    case multipleChoice
    case budgetSelection
}
