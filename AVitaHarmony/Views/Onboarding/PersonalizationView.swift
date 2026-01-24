//
//  PersonalizationView.swift
//  AVitaHarmony
//

import SwiftUI

struct PersonalizationView: View {
    @Binding var currentStep: OnboardingStep
    @Binding var userProfile: UserProfile
    
    @State private var selectedGoal: FitnessGoal = .general
    @State private var selectedLevel: FitnessLevel = .beginner
    @State private var age: String = ""
    @State private var workoutDuration: Double = 30
    @State private var meditationDuration: Double = 10
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Personalize Your Experience")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                    
                    Text("Help us customize your journey")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Fitness Goal
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What's your primary goal?")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 12) {
                                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                    GoalButton(
                                        title: goal.rawValue,
                                        isSelected: selectedGoal == goal
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedGoal = goal
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        // Fitness Level
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What's your fitness level?")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            HStack(spacing: 12) {
                                ForEach(FitnessLevel.allCases, id: \.self) { level in
                                    LevelButton(
                                        title: level.rawValue,
                                        isSelected: selectedLevel == level
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedLevel = level
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        // Workout Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferred workout duration")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("\(Int(workoutDuration)) minutes")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppConstants.Colors.primaryGreen)
                                    Spacer()
                                }
                                
                                Slider(value: $workoutDuration, in: 15...60, step: 5)
                                    .accentColor(AppConstants.Colors.primaryGreen)
                            }
                            .padding()
                            .background(AppConstants.Colors.cardBackground)
                            .cornerRadius(AppConstants.UI.cornerRadius)
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        // Meditation Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferred meditation duration")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("\(Int(meditationDuration)) minutes")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppConstants.Colors.primaryGreen)
                                    Spacer()
                                }
                                
                                Slider(value: $meditationDuration, in: 5...30, step: 5)
                                    .accentColor(AppConstants.Colors.primaryGreen)
                            }
                            .padding()
                            .background(AppConstants.Colors.cardBackground)
                            .cornerRadius(AppConstants.UI.cornerRadius)
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical)
                }
                
                // Continue Button
                Button(action: {
                    savePreferences()
                    withAnimation(.spring()) {
                        currentStep = .appTour
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.UI.buttonHeight)
                        .background(AppConstants.Colors.primaryGreen)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.bottom, AppConstants.UI.largeSpacing)
            }
        }
    }
    
    private func savePreferences() {
        userProfile.fitnessGoal = selectedGoal
        userProfile.fitnessLevel = selectedLevel
        userProfile.preferredWorkoutDuration = Int(workoutDuration)
        userProfile.preferredMeditationDuration = Int(meditationDuration)
        
        if !age.isEmpty, let ageValue = Int(age) {
            userProfile.age = ageValue
        }
    }
}

struct GoalButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppConstants.Colors.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                isSelected ?
                AppConstants.Colors.primaryGreen :
                AppConstants.Colors.cardBackground
            )
            .cornerRadius(AppConstants.UI.cornerRadius)
        }
    }
}

struct LevelButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : AppConstants.Colors.textPrimary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected ?
                    AppConstants.Colors.primaryGreen :
                    AppConstants.Colors.cardBackground
                )
                .cornerRadius(AppConstants.UI.cornerRadius)
        }
    }
}
