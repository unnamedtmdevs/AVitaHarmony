//
//  AccountSettingsView.swift
//  AVitaHarmony
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var selectedGoal: FitnessGoal = .general
    @State private var selectedLevel: FitnessLevel = .beginner
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(AppConstants.Colors.cardBackground)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: saveProfile) {
                        Text("Save")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.primaryGreen)
                    }
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Basic Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Basic Information")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 12) {
                                CustomTextField(
                                    icon: "person.fill",
                                    placeholder: "Name",
                                    text: $name
                                )
                                
                                CustomTextField(
                                    icon: "envelope.fill",
                                    placeholder: "Email",
                                    text: $email,
                                    keyboardType: .emailAddress
                                )
                                
                                CustomTextField(
                                    icon: "calendar",
                                    placeholder: "Age",
                                    text: $age,
                                    keyboardType: .numberPad
                                )
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        // Physical Stats
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Physical Stats")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 12) {
                                CustomTextField(
                                    icon: "scalemass.fill",
                                    placeholder: "Weight (kg)",
                                    text: $weight,
                                    keyboardType: .decimalPad
                                )
                                
                                CustomTextField(
                                    icon: "ruler.fill",
                                    placeholder: "Height (cm)",
                                    text: $height,
                                    keyboardType: .decimalPad
                                )
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        // Fitness Goal
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Fitness Goal")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            VStack(spacing: 12) {
                                ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                    SelectionButton(
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
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Fitness Level")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            HStack(spacing: 12) {
                                ForEach(FitnessLevel.allCases, id: \.self) { level in
                                    SelectionButton(
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
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            loadCurrentProfile()
        }
    }
    
    private func loadCurrentProfile() {
        let profile = settingsViewModel.userProfile
        name = profile.name
        email = profile.email
        selectedGoal = profile.fitnessGoal
        selectedLevel = profile.fitnessLevel
        
        if let profileAge = profile.age {
            age = "\(profileAge)"
        }
        if let profileWeight = profile.weight {
            weight = "\(profileWeight)"
        }
        if let profileHeight = profile.height {
            height = "\(profileHeight)"
        }
    }
    
    private func saveProfile() {
        settingsViewModel.updateProfile(
            name: name.isEmpty ? nil : name,
            email: email.isEmpty ? nil : email,
            fitnessGoal: selectedGoal,
            fitnessLevel: selectedLevel,
            age: Int(age),
            weight: Double(weight),
            height: Double(height)
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 32, height: 32)
                .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                .cornerRadius(8)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.textPrimary)
                .keyboardType(keyboardType)
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}

struct SelectionButton: View {
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
