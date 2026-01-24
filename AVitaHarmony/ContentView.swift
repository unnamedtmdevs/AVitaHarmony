//
//  ContentView.swift
//  AVitaHarmony
//
//  Created by Simon Bakhanets on 24.01.2026.
//

import SwiftUI

struct ContentView: View {
    @Binding var hasCompletedOnboarding: Bool
    @StateObject private var fitnessViewModel = FitnessViewModel()
    @StateObject private var meditationViewModel = MeditationViewModel()
    @StateObject private var settingsViewModel: SettingsViewModel
    
    @State private var selectedTab = 0
    @State private var showOnboarding = true
    
    init(hasCompletedOnboarding: Binding<Bool>) {
        self._hasCompletedOnboarding = hasCompletedOnboarding
        
        // Load or create user profile
        let loadedProfile = SettingsViewModel(profile: UserProfile()).loadProfile()
        self._settingsViewModel = StateObject(wrappedValue: SettingsViewModel(profile: loadedProfile))
    }
    
    var body: some View {
        ZStack {
            if hasCompletedOnboarding {
                mainAppView
            } else {
                onboardingView
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            setupViewModels()
        }
    }
    
    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(fitnessViewModel)
                .environmentObject(meditationViewModel)
                .environmentObject(settingsViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            DashboardView()
                .environmentObject(fitnessViewModel)
                .environmentObject(meditationViewModel)
                .environmentObject(settingsViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            SettingsView()
                .environmentObject(settingsViewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(AppConstants.Colors.primaryGreen)
    }
    
    private var onboardingView: some View {
        OnboardingContainerView(hasCompletedOnboarding: $hasCompletedOnboarding)
            .environmentObject(settingsViewModel)
    }
    
    private func setupViewModels() {
        if hasCompletedOnboarding {
            fitnessViewModel.loadWorkouts(for: settingsViewModel.userProfile)
            fitnessViewModel.loadWorkoutHistory()
            
            meditationViewModel.loadSessions(for: settingsViewModel.userProfile)
            meditationViewModel.loadMeditationHistory()
        }
    }
}

struct OnboardingContainerView: View {
    @Binding var hasCompletedOnboarding: Bool
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var currentStep: OnboardingStep = .welcome
    @State private var userProfile = UserProfile()
    
    var body: some View {
        ZStack {
            switch currentStep {
            case .welcome:
                WelcomeView(currentStep: $currentStep)
            case .personalization:
                PersonalizationView(currentStep: $currentStep, userProfile: $userProfile)
            case .appTour:
                AppTourView(currentStep: $currentStep)
            case .account:
                AccountSetupView(currentStep: $currentStep, userProfile: $userProfile)
            case .quickStart:
                QuickStartView(currentStep: $currentStep)
            case .complete:
                Color.clear
                    .onAppear {
                        completeOnboarding()
                    }
            }
        }
        .transition(.slide)
    }
    
    private func completeOnboarding() {
        settingsViewModel.userProfile = userProfile
        settingsViewModel.saveProfile()
        hasCompletedOnboarding = true
    }
}

struct AccountSetupView: View {
    @Binding var currentStep: OnboardingStep
    @Binding var userProfile: UserProfile
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isGuest: Bool = false
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Text("Create Your Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text("Join AVita Harmony to save your progress")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                VStack(spacing: 16) {
                    TextField("Name", text: $name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                    
                    TextField("Email", text: $email)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        saveAccount(isGuest: false)
                    }) {
                        Text("Create Account")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppConstants.UI.buttonHeight)
                            .background(AppConstants.Colors.primaryGreen)
                            .cornerRadius(AppConstants.UI.cornerRadius)
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                    .opacity(name.isEmpty || email.isEmpty ? 0.5 : 1.0)
                    
                    Button(action: {
                        saveAccount(isGuest: true)
                    }) {
                        Text("Continue as Guest")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppConstants.Colors.textSecondary)
                    }
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.bottom, AppConstants.UI.largeSpacing)
            }
        }
    }
    
    private func saveAccount(isGuest: Bool) {
        if isGuest {
            userProfile.name = "Guest"
            userProfile.email = ""
            userProfile.isGuest = true
        } else {
            userProfile.name = name
            userProfile.email = email
            userProfile.isGuest = false
        }
        
        withAnimation(.spring()) {
            currentStep = .quickStart
        }
    }
}

struct QuickStartView: View {
    @Binding var currentStep: OnboardingStep
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppConstants.Colors.primaryGreen)
                
                Text("You're All Set!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text("Ready to start your wellness journey?")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        currentStep = .complete
                    }
                }) {
                    Text("Let's Begin!")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.UI.buttonHeight)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppConstants.Colors.primaryGreen,
                                    AppConstants.Colors.primaryOrange
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.bottom, AppConstants.UI.largeSpacing)
            }
        }
    }
}

#Preview {
    ContentView(hasCompletedOnboarding: .constant(false))
}
