//
//  AppTourView.swift
//  AVitaHarmony
//

import SwiftUI

struct AppTourView: View {
    @Binding var currentStep: OnboardingStep
    @State private var currentPage = 0
    
    private let tourPages: [TourPage] = [
        TourPage(
            icon: "figure.run",
            title: "Adaptive Fitness",
            description: "Your workouts adapt based on your performance. The better you do, the more challenging they become. We grow with you!",
            color: AppConstants.Colors.primaryGreen
        ),
        TourPage(
            icon: "person.fill.checkmark",
            title: "Virtual Coach",
            description: "Get real-time feedback and motivation during your workouts. Your AI coach is always there to encourage you!",
            color: AppConstants.Colors.primaryOrange
        ),
        TourPage(
            icon: "brain.head.profile",
            title: "Interactive Meditation",
            description: "Experience meditation that responds to you. Interactive breathing exercises and guided visualizations.",
            color: AppConstants.Colors.primaryGreen
        ),
        TourPage(
            icon: "chart.bar.fill",
            title: "Track Everything",
            description: "Monitor your workouts, meditation sessions, and overall wellness. See your progress over time!",
            color: AppConstants.Colors.primaryRed
        )
    ]
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            currentStep = .account
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppConstants.Colors.textSecondary)
                    }
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.top, 20)
                
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<tourPages.count, id: \.self) { index in
                        TourPageView(page: tourPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<tourPages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppConstants.Colors.primaryGreen : AppConstants.Colors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 24)
                
                // Next/Get Started Button
                Button(action: {
                    if currentPage < tourPages.count - 1 {
                        withAnimation(.spring()) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.spring()) {
                            currentStep = .account
                        }
                    }
                }) {
                    Text(currentPage < tourPages.count - 1 ? "Next" : "Get Started")
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
}

struct TourPageView: View {
    let page: TourPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                Image(systemName: page.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(page.color)
            }
            
            // Title
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(AppConstants.Colors.textPrimary)
                .multilineTextAlignment(.center)
            
            // Description
            Text(page.description)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(AppConstants.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct TourPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}
