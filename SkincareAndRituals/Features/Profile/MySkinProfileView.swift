import SwiftUI

struct MySkinProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var surveyViewModel = SurveyViewModel()
    @State private var userProfile: UserProfile
    @State private var showingSkinTypePicker = false
    @State private var showingGenderPicker = false
    @State private var showingSensitivityPicker = false
    @State private var showingAgePicker = false
    @State private var showingConcernsPicker = false
    
    init() {
        // Load survey data from SurveyViewModel
        let surveyResponse = SurveyResponse()
        let savedName = UserDefaults.standard.string(forKey: "survey_name") ?? "User"
        let savedGender = UserDefaults.standard.string(forKey: "survey_gender") ?? "Prefer not to say"
        let savedAge = UserDefaults.standard.string(forKey: "survey_age") ?? "18-24"
        let savedSkinType = UserDefaults.standard.string(forKey: "survey_skin_type") ?? "Normal"
        let savedSensitivity = UserDefaults.standard.string(forKey: "survey_skin_sensitivity") ?? "Not sensitive"
        
        // Convert old "Low"/"High" values to new format
        let updatedSensitivity: String
        switch savedSensitivity {
        case "Low":
            updatedSensitivity = "Not sensitive"
        case "High":
            updatedSensitivity = "Sensitive"
        default:
            updatedSensitivity = savedSensitivity
        }
        
        _userProfile = State(initialValue: UserProfile(
            name: savedName,
            gender: savedGender,
            ageRange: savedAge,
            skinType: savedSkinType,
            skinSensitivity: updatedSensitivity,
            skinConcerns: UserDefaults.standard.string(forKey: "survey_skin_concerns") ?? "Acne or pimples"
        ))
    }
    
    // Skin Type options - only 4 as requested
    private let skinTypeOptions = ["Oily", "Dry", "Combination", "Normal"]
    
    // Gender options - only 3 as requested
    private let genderOptions = ["Female", "Male", "Prefer not to say"]
    
    // Skin Sensitivity options - 2 as requested
    private let sensitivityOptions = ["Sensitive", "Not sensitive"]
    
    // Age options
    private let ageOptions = ["13-17", "18-24", "25-34", "35-44", "45-54", "55+"]
    
    // Skin Concerns options
    private let skinConcernsOptions = ["Acne or pimples", "Wrinkles and Fine lines", "Redness or Rosacea", "T-zone Oiliness", "Skin barrier repair", "Puffy eyes", "Enlarged pores"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with Close and Save buttons
                    HStack {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "8B5CF6"))
                        
                        Spacer()
                        
                        Text("My Skin Profile")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveProfile()
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "8B5CF6"))
                    }
                    .padding(.horizontal)

                    // Profile Icon Section
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color(hex: "8B5CF6"))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Skin Profile")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Your personalized skin information")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    // Form Fields
                    VStack(spacing: 20) {
                        formField(title: "Name", value: $userProfile.name)
                        
                        // Gender with dropdown
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gender")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            Button(action: {
                                showingGenderPicker = true
                            }) {
                                HStack {
                                    Text(userProfile.gender)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Age with dropdown
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Age")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            Button(action: {
                                showingAgePicker = true
                            }) {
                                HStack {
                                    Text(userProfile.ageRange)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Skin Type with dropdown
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Skin Type")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            Button(action: {
                                showingSkinTypePicker = true
                            }) {
                                HStack {
                                    Text(userProfile.skinType)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Skin Sensitivity with dropdown
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Skin Sensitivity")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            Button(action: {
                                showingSensitivityPicker = true
                            }) {
                                HStack {
                                    Text(userProfile.skinSensitivity)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                        
                        // Skin Concerns with tags
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Skin Concerns")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 4)
                            
                            Button(action: {
                                showingConcernsPicker = true
                            }) {
                                HStack {
                                    Text(userProfile.skinConcerns)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
        .confirmationDialog("Select Skin Type", isPresented: $showingSkinTypePicker) {
            ForEach(skinTypeOptions, id: \.self) { option in
                Button(option) {
                    userProfile.skinType = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Select Gender", isPresented: $showingGenderPicker) {
            ForEach(genderOptions, id: \.self) { option in
                Button(option) {
                    userProfile.gender = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Select Skin Sensitivity", isPresented: $showingSensitivityPicker) {
            ForEach(sensitivityOptions, id: \.self) { option in
                Button(option) {
                    userProfile.skinSensitivity = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Select Age", isPresented: $showingAgePicker) {
            ForEach(ageOptions, id: \.self) { option in
                Button(option) {
                    userProfile.ageRange = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .confirmationDialog("Select Skin Concerns", isPresented: $showingConcernsPicker) {
            ForEach(skinConcernsOptions, id: \.self) { option in
                Button(option) {
                    userProfile.skinConcerns = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func saveProfile() {
        // Save profile data to UserDefaults
        UserDefaults.standard.set(userProfile.name, forKey: "survey_name")
        UserDefaults.standard.set(userProfile.gender, forKey: "survey_gender")
        UserDefaults.standard.set(userProfile.ageRange, forKey: "survey_age")
        UserDefaults.standard.set(userProfile.skinType, forKey: "survey_skin_type")
        UserDefaults.standard.set(userProfile.skinSensitivity, forKey: "survey_skin_sensitivity")
        UserDefaults.standard.set(userProfile.skinConcerns, forKey: "survey_skin_concerns")
        
        print("Profile saved successfully!")
    }
    
    private func formField(title: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
            
            TextField("", text: value)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    MySkinProfileView()
}
