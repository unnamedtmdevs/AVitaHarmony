//
//  SettingsView.swift
//  AVitaHarmony
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var showAccountSettings = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    .padding(.top, 20)
                    
                    // Profile Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profile")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        VStack(spacing: 12) {
                            ProfileInfoRow(
                                icon: "person.fill",
                                label: "Name",
                                value: settingsViewModel.userProfile.name
                            )
                            
                            if !settingsViewModel.userProfile.email.isEmpty {
                                ProfileInfoRow(
                                    icon: "envelope.fill",
                                    label: "Email",
                                    value: settingsViewModel.userProfile.email
                                )
                            }
                            
                            ProfileInfoRow(
                                icon: "target",
                                label: "Goal",
                                value: settingsViewModel.userProfile.fitnessGoal.rawValue
                            )
                            
                            ProfileInfoRow(
                                icon: "chart.bar.fill",
                                label: "Level",
                                value: settingsViewModel.userProfile.fitnessLevel.rawValue
                            )
                            
                            if let bmi = settingsViewModel.getBMI() {
                                ProfileInfoRow(
                                    icon: "heart.fill",
                                    label: "BMI",
                                    value: String(format: "%.1f (%@)", bmi, settingsViewModel.getBMICategory())
                                )
                            }
                        }
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        Button(action: {
                            showAccountSettings = true
                        }) {
                            Text("Edit Profile")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppConstants.Colors.primaryGreen)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppConstants.Colors.cardBackground)
                                .cornerRadius(AppConstants.UI.cornerRadius)
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Preferences")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        VStack(spacing: 0) {
                            SettingsToggleRow(
                                icon: "bell.fill",
                                label: "Notifications",
                                isOn: $settingsViewModel.notificationsEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsToggleRow(
                                icon: "speaker.wave.2.fill",
                                label: "Sound Effects",
                                isOn: $settingsViewModel.soundEnabled
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsToggleRow(
                                icon: "hand.tap.fill",
                                label: "Haptic Feedback",
                                isOn: $settingsViewModel.hapticsEnabled
                            )
                        }
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Workout Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Workout Settings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Preferred Duration")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppConstants.Colors.textPrimary)
                                Spacer()
                                Text("\(settingsViewModel.userProfile.preferredWorkoutDuration) min")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppConstants.Colors.primaryGreen)
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(settingsViewModel.userProfile.preferredWorkoutDuration) },
                                    set: { settingsViewModel.updateWorkoutPreferences(duration: Int($0)) }
                                ),
                                in: 15...60,
                                step: 5
                            )
                            .accentColor(AppConstants.Colors.primaryGreen)
                        }
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Meditation Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Meditation Settings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Preferred Duration")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppConstants.Colors.textPrimary)
                                Spacer()
                                Text("\(settingsViewModel.userProfile.preferredMeditationDuration) min")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppConstants.Colors.primaryOrange)
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(settingsViewModel.userProfile.preferredMeditationDuration) },
                                    set: { settingsViewModel.updateMeditationPreferences(duration: Int($0)) }
                                ),
                                in: 5...30,
                                step: 5
                            )
                            .accentColor(AppConstants.Colors.primaryOrange)
                        }
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        VStack(spacing: 0) {
                            SettingsRow(icon: "info.circle.fill", label: "Version", value: "1.0.0")
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(icon: "doc.text.fill", label: "Terms of Service", value: "")
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            SettingsRow(icon: "lock.fill", label: "Privacy Policy", value: "")
                        }
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Danger Zone
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(AppConstants.Colors.primaryRed)
                                Text("Delete Account Data")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppConstants.Colors.primaryRed)
                                Spacer()
                            }
                            .padding()
                            .background(AppConstants.Colors.cardBackground)
                            .cornerRadius(AppConstants.UI.cornerRadius)
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
        }
        .sheet(isPresented: $showAccountSettings) {
            AccountSettingsView()
                .environmentObject(settingsViewModel)
        }
        .alert("Delete Account Data", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                settingsViewModel.deleteAccount()
            }
        } message: {
            Text("This will reset all your data and preferences. This action cannot be undone.")
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 32, height: 32)
                .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textPrimary)
            }
            
            Spacer()
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 32, height: 32)
                .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                .cornerRadius(8)
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: AppConstants.Colors.primaryGreen))
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 32, height: 32)
                .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                .cornerRadius(8)
            
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.textPrimary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(AppConstants.Colors.textSecondary)
        }
    }
}
