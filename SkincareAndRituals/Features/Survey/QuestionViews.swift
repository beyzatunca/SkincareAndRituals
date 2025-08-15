import SwiftUI

// MARK: - Name Question View
struct NameQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: geometry.size.height * 0.08, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.02)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                    )
            }
            
            // Text Field
            CustomTextField(
                placeholder: "Enter your name",
                text: $viewModel.surveyResponse.name,
                geometry: geometry
            )
            .textInputAutocapitalization(.words)
        }
    }
}

// MARK: - Age Question View
struct AgeQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: "calendar.circle.fill")
                    .font(.system(size: geometry.size.height * 0.08, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.02)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                    )
            }
            
            // Age Options
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: geometry.size.height * 0.015) {
                ForEach(AgeRange.allCases, id: \.self) { ageRange in
                    SelectionCard(isSelected: viewModel.surveyResponse.age == ageRange, geometry: geometry) {
                        Button(action: {
                            viewModel.surveyResponse.age = ageRange
                        }) {
                            Text(ageRange.displayName)
                                .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                                .foregroundColor(viewModel.surveyResponse.age == ageRange ? AppTheme.primaryColor : AppTheme.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(height: geometry.size.height * 0.06)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// MARK: - Skin Type Question View
struct SkinTypeQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: "face.smiling")
                    .font(.system(size: geometry.size.height * 0.08, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.02)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                    )
            }
            
            // Skin Type Options
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: geometry.size.height * 0.015) {
                ForEach(SkinType.allCases, id: \.self) { skinType in
                    SelectionCard(isSelected: viewModel.surveyResponse.skinType == skinType, geometry: geometry) {
                        Button(action: {
                            viewModel.surveyResponse.skinType = skinType
                        }) {
                            VStack(spacing: geometry.size.height * 0.008) {
                                Text(skinType.displayName)
                                    .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                                    .foregroundColor(viewModel.surveyResponse.skinType == skinType ? AppTheme.primaryColor : AppTheme.textPrimary)
                                
                                Text(skinType.description)
                                    .font(.system(size: geometry.size.height * 0.016))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// MARK: - Sensitivity Question View
struct SensitivityQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: geometry.size.height * 0.08, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.02)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                    )
            }
            
            // Sensitivity Options
            VStack(spacing: geometry.size.height * 0.015) {
                SelectionCard(isSelected: viewModel.surveyResponse.isSensitive, geometry: geometry) {
                    Button(action: {
                        viewModel.surveyResponse.isSensitive.toggle()
                    }) {
                        HStack {
                            Image(systemName: viewModel.surveyResponse.isSensitive ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: geometry.size.height * 0.025))
                                .foregroundColor(viewModel.surveyResponse.isSensitive ? AppTheme.primaryColor : AppTheme.textSecondary)
                            
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                                Text("Sensitive")
                                    .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Text("My skin is easily irritated by products")
                                    .font(.system(size: geometry.size.height * 0.016))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.08)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                SelectionCard(isSelected: !viewModel.surveyResponse.isSensitive, geometry: geometry) {
                    Button(action: {
                        viewModel.surveyResponse.isSensitive = false
                    }) {
                        HStack {
                            Image(systemName: !viewModel.surveyResponse.isSensitive ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: geometry.size.height * 0.025))
                                .foregroundColor(!viewModel.surveyResponse.isSensitive ? AppTheme.primaryColor : AppTheme.textSecondary)
                            
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                                Text("Not Sensitive")
                                    .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Text("My skin tolerates most products well")
                                    .font(.system(size: geometry.size.height * 0.016))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.08)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Skin Concerns Question View
struct SkinConcernsQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.02) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.008) {
                Image(systemName: "face.smiling")
                    .font(.system(size: geometry.size.height * 0.05, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.012)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.075, height: geometry.size.height * 0.075)
                    )
            }
            
            // Skin Concerns Options
            VStack(spacing: geometry.size.height * 0.008) {
                ForEach(SkinMotivation.allCases, id: \.self) { concern in
                    SkinConcernOptionCard(
                        concern: concern,
                        isSelected: viewModel.surveyResponse.skinConcerns.contains(concern),
                        geometry: geometry
                    ) {
                        if viewModel.surveyResponse.skinConcerns.contains(concern) {
                            viewModel.surveyResponse.skinConcerns.remove(concern)
                        } else {
                            viewModel.surveyResponse.skinConcerns.insert(concern)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Skin Concern Option Card
struct SkinConcernOptionCard: View {
    let concern: SkinMotivation
    let isSelected: Bool
    let geometry: GeometryProxy
    let onTap: () -> Void
    
    var body: some View {
        SelectionCard(isSelected: isSelected, geometry: geometry) {
            Button(action: onTap) {
                HStack(spacing: geometry.size.height * 0.008) {
                    VStack(alignment: .leading, spacing: geometry.size.height * 0.003) {
                        Text(concern.displayName)
                            .font(.system(size: geometry.size.height * 0.015, weight: .semibold))
                            .foregroundColor(isSelected ? AppTheme.primaryColor : AppTheme.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        

                    }
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: geometry.size.height * 0.018))
                        .foregroundColor(isSelected ? AppTheme.primaryColor : AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height * 0.06)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Avoid Ingredients Question View
struct AvoidIngredientsQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.02) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.008) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: geometry.size.height * 0.05, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.012)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.075, height: geometry.size.height * 0.075)
                    )
            }
            
            // Avoid Ingredients Options
            VStack(spacing: geometry.size.height * 0.008) {
                ForEach(AvoidIngredient.allCases, id: \.self) { ingredient in
                    SelectionCard(isSelected: viewModel.surveyResponse.avoidIngredients.contains(ingredient), geometry: geometry) {
                        Button(action: {
                            if viewModel.surveyResponse.avoidIngredients.contains(ingredient) {
                                viewModel.surveyResponse.avoidIngredients.remove(ingredient)
                            } else {
                                viewModel.surveyResponse.avoidIngredients.insert(ingredient)
                            }
                        }) {
                            HStack(spacing: geometry.size.height * 0.008) {
                                VStack(alignment: .leading, spacing: geometry.size.height * 0.003) {
                                    Text(ingredient.displayName)
                                        .font(.system(size: geometry.size.height * 0.015, weight: .semibold))
                                        .foregroundColor(viewModel.surveyResponse.avoidIngredients.contains(ingredient) ? AppTheme.primaryColor : AppTheme.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                    
                                    Text(ingredient.description)
                                        .font(.system(size: geometry.size.height * 0.012))
                                        .foregroundColor(AppTheme.textSecondary)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(systemName: viewModel.surveyResponse.avoidIngredients.contains(ingredient) ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: geometry.size.height * 0.018))
                                    .foregroundColor(viewModel.surveyResponse.avoidIngredients.contains(ingredient) ? AppTheme.primaryColor : AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.06)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

// MARK: - Pregnancy Question View
struct PregnancyQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.02) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.008) {
                Image(systemName: "heart.fill")
                    .font(.system(size: geometry.size.height * 0.05, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.012)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.075, height: geometry.size.height * 0.075)
                    )
            }
            
            // Pregnancy Options
            VStack(spacing: geometry.size.height * 0.01) {
                // Yes option
                SelectionCard(isSelected: viewModel.surveyResponse.isPregnantOrBreastfeeding == true, geometry: geometry) {
                    Button(action: {
                        viewModel.surveyResponse.isPregnantOrBreastfeeding = true
                    }) {
                        HStack(spacing: geometry.size.height * 0.01) {
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                                Text("Yes")
                                    .font(.system(size: geometry.size.height * 0.018, weight: .semibold))
                                    .foregroundColor(viewModel.surveyResponse.isPregnantOrBreastfeeding == true ? AppTheme.primaryColor : AppTheme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                
                                Text("I am currently pregnant or breastfeeding")
                                    .font(.system(size: geometry.size.height * 0.014))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: viewModel.surveyResponse.isPregnantOrBreastfeeding == true ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: geometry.size.height * 0.02))
                                .foregroundColor(viewModel.surveyResponse.isPregnantOrBreastfeeding == true ? AppTheme.primaryColor : AppTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.08)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // No option
                SelectionCard(isSelected: viewModel.surveyResponse.isPregnantOrBreastfeeding == false, geometry: geometry) {
                    Button(action: {
                        viewModel.surveyResponse.isPregnantOrBreastfeeding = false
                    }) {
                        HStack(spacing: geometry.size.height * 0.01) {
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                                Text("No")
                                    .font(.system(size: geometry.size.height * 0.018, weight: .semibold))
                                    .foregroundColor(viewModel.surveyResponse.isPregnantOrBreastfeeding == false ? AppTheme.primaryColor : AppTheme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                
                                Text("I am not currently pregnant or breastfeeding")
                                    .font(.system(size: geometry.size.height * 0.014))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: viewModel.surveyResponse.isPregnantOrBreastfeeding == false ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: geometry.size.height * 0.02))
                                .foregroundColor(viewModel.surveyResponse.isPregnantOrBreastfeeding == false ? AppTheme.primaryColor : AppTheme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.08)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Budget Question View
struct BudgetQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.03) {
            // Illustration
            VStack(spacing: geometry.size.height * 0.015) {
                Image(systemName: "eurosign.circle.fill")
                    .font(.system(size: geometry.size.height * 0.08, weight: .light))
                    .foregroundColor(AppTheme.primaryColor)
                    .padding(geometry.size.height * 0.02)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryColor.opacity(0.1))
                            .frame(width: geometry.size.height * 0.12, height: geometry.size.height * 0.12)
                    )
            }
            
            // Budget Options
            VStack(spacing: geometry.size.height * 0.015) {
                ForEach(BudgetRange.allCases, id: \.self) { budget in
                    SelectionCard(isSelected: viewModel.surveyResponse.budget == budget, geometry: geometry) {
                        Button(action: {
                            viewModel.surveyResponse.budget = budget
                        }) {
                            VStack(alignment: .leading, spacing: geometry.size.height * 0.008) {
                                HStack {
                                    VStack(alignment: .leading, spacing: geometry.size.height * 0.005) {
                                        Text(budget.displayName)
                                            .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                                            .foregroundColor(viewModel.surveyResponse.budget == budget ? AppTheme.primaryColor : AppTheme.textPrimary)
                                        
                                        Text(budget.priceRange)
                                            .font(.system(size: geometry.size.height * 0.018, weight: .medium))
                                            .foregroundColor(AppTheme.primaryColor)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: viewModel.surveyResponse.budget == budget ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: geometry.size.height * 0.025))
                                        .foregroundColor(viewModel.surveyResponse.budget == budget ? AppTheme.primaryColor : AppTheme.textSecondary)
                                }
                                
                                Text(budget.description)
                                    .font(.system(size: geometry.size.height * 0.016))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height * 0.1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}
