import Foundation
import SwiftUI

@MainActor
class SurveyViewModel: ObservableObject {
    @Published var surveyResponse = SurveyResponse()
    @Published var currentQuestionIndex = 0
    @Published var isOnboardingComplete = false
    @Published var isNewUser = true // Flag to control user flow
    @Published var navigateToMainPage = false // Flag to navigate to main app after face analysis
    @Published var showFaceAnalysis = false // Flag to show face analysis after survey completion
    
    init() {
        // Check if user has completed onboarding before
        checkUserStatus()
    }
    
    private func checkUserStatus() {
        let userDefaults = UserDefaults.standard
        let hasCompletedOnboarding = userDefaults.bool(forKey: "has_completed_onboarding")
        isNewUser = !hasCompletedOnboarding
        
        // For testing purposes, you can set this to true to test new user flow
        isNewUser = true // Set to true for testing with new user flow
    }
    
    // Survey questions
    private let questions: [SurveyQuestion] = [
        SurveyQuestion(id: 1, title: "What's your name?", subtitle: "Let's personalize your skincare journey", type: .textInput),
        SurveyQuestion(id: 2, title: "How old are you?", subtitle: "Age helps us recommend age-appropriate products", type: .singleChoice),
        SurveyQuestion(id: 3, title: "What's your skin type?", subtitle: "Understanding your skin type is key to effective care", type: .singleChoice),
        SurveyQuestion(id: 4, title: "Is your skin sensitive?", subtitle: "This helps us avoid irritating ingredients", type: .multipleChoice),
        SurveyQuestion(id: 5, title: "What are your main skin concerns?", subtitle: "Select all that apply to help us recommend the right products for you", type: .multipleChoice),
        SurveyQuestion(id: 6, title: "Which ingredients do you want to avoid?", subtitle: "Select ingredients you'd prefer to stay away from", type: .multipleChoice),
        SurveyQuestion(id: 7, title: "Are you currently pregnant or breastfeeding?", subtitle: "This helps us avoid ingredients that may not be safe during pregnancy or breastfeeding", type: .multipleChoice),
        SurveyQuestion(id: 8, title: "What's your budget?", subtitle: "Choose your budget for everyday skincare products", type: .budgetSelection)
    ]
    
    var currentQuestion: SurveyQuestion {
        questions[currentQuestionIndex]
    }
    
    var totalQuestions: Int {
        questions.count
    }
    
    var progress: Double {
        Double(currentQuestionIndex + 1) / Double(totalQuestions)
    }
    
    var canProceed: Bool {
        switch currentQuestion.type {
        case .textInput:
            return !surveyResponse.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .singleChoice:
            if currentQuestion.id == 2 { // Age question
                return surveyResponse.age != nil
            } else if currentQuestion.id == 3 { // Skin type question
                return surveyResponse.skinType != nil
            } else {
                return true
            }
        case .multipleChoice:
            if currentQuestion.id == 4 { // Sensitivity question
                return true // Always can proceed
            } else if currentQuestion.id == 5 { // Skin concerns question
                return !surveyResponse.skinConcerns.isEmpty
            } else if currentQuestion.id == 6 { // Avoid ingredients question
                return !surveyResponse.avoidIngredients.isEmpty
            } else if currentQuestion.id == 7 { // Pregnancy question
                return true // Always can proceed
            } else {
                return true
            }
        case .budgetSelection:
            return surveyResponse.budget != nil
        }
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == totalQuestions - 1
    }
    
    func nextQuestion() {
        if currentQuestionIndex < totalQuestions - 1 {
            currentQuestionIndex += 1
        } else {
            // Survey completed
            completeSurvey()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func completeSurvey() {
        // Here you would typically send the survey response to your backend
        print("Survey completed: \(surveyResponse)")
        
        // Save survey data to UserDefaults for My Skin Profile
        saveSurveyDataToUserDefaults()
        
        // Show face analysis for new users before marking onboarding as completed
        if isNewUser {
            print("🔴 Setting showFaceAnalysis = true")
            showFaceAnalysis = true
            // Don't set isNewUser = false here, let completeFaceAnalysis() handle it
        } else {
            print("🔴 Setting isOnboardingComplete = true")
            // Navigate directly to main app for existing users
            isOnboardingComplete = true
        }
        
        // Mark onboarding as completed in UserDefaults but keep isNewUser true until face analysis is done
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "has_completed_onboarding")
    }
    
    func completeFaceAnalysis() {
        // Face analysis completed, navigate to main app
        print("🔴 Face analysis completed, navigating to main app")
        print("🔴 Before: showFaceAnalysis = \(showFaceAnalysis), isOnboardingComplete = \(isOnboardingComplete), isNewUser = \(isNewUser)")
        
        // Set all flags at once to prevent navigation conflicts
        showFaceAnalysis = false
        isOnboardingComplete = true
        isNewUser = false
        
        print("🔴 After: showFaceAnalysis = \(showFaceAnalysis), isOnboardingComplete = \(isOnboardingComplete), isNewUser = \(isNewUser)")
    }
    
    func goBackToSurvey() {
        // Go back to the last question of the survey
        print("🔴 Going back to survey from face analysis")
        print("🔴 Before: showFaceAnalysis = \(showFaceAnalysis), currentQuestionIndex = \(currentQuestionIndex)")
        showFaceAnalysis = false
        // Set current question to the last question (index 7 for question 8)
        currentQuestionIndex = totalQuestions - 1
        print("🔴 After: showFaceAnalysis = \(showFaceAnalysis), currentQuestionIndex = \(currentQuestionIndex), totalQuestions = \(totalQuestions)")
    }
    
    private func saveSurveyDataToUserDefaults() {
        let userDefaults = UserDefaults.standard
        
        // Save basic info
        userDefaults.set(surveyResponse.name, forKey: "survey_name")
        
        // Save age if selected
        if let age = surveyResponse.age {
            userDefaults.set(age.rawValue, forKey: "survey_age")
        }
        
        // Save skin type if selected
        if let skinType = surveyResponse.skinType {
            userDefaults.set(skinType.rawValue, forKey: "survey_skin_type")
        }
        
        userDefaults.set(surveyResponse.isSensitive ? "Sensitive" : "Not sensitive", forKey: "survey_skin_sensitivity")
        
        // Save skin concerns as JSON
        let concernsArray = Array(surveyResponse.skinConcerns).map { $0.rawValue }
        if let concernsData = try? JSONEncoder().encode(concernsArray) {
            userDefaults.set(concernsData, forKey: "survey_skin_concerns")
        }
        
        // Save avoid ingredients as JSON
        let avoidIngredientsArray = Array(surveyResponse.avoidIngredients).map { $0.rawValue }
        if let avoidIngredientsData = try? JSONEncoder().encode(avoidIngredientsArray) {
            userDefaults.set(avoidIngredientsData, forKey: "survey_avoid_ingredients")
        }
        
        // Save budget if selected
        if let budget = surveyResponse.budget {
            userDefaults.set(budget.rawValue, forKey: "survey_budget")
        }
        
        // Save pregnancy status
        userDefaults.set(surveyResponse.isPregnantOrBreastfeeding, forKey: "survey_pregnancy_status")
        
        print("Survey data saved to UserDefaults")
    }
    
    func startSurvey() {
        isOnboardingComplete = true
        currentQuestionIndex = 0
        surveyResponse = SurveyResponse()
    }
    
    func resetSurvey() {
        currentQuestionIndex = 0
        surveyResponse = SurveyResponse()
    }
}
