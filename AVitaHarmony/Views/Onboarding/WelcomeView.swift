//
//  WelcomeView.swift
//  AVitaHarmony
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentStep: OnboardingStep
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: AppConstants.UI.largeSpacing) {
                Spacer()
                
                // App Logo/Icon
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(AppConstants.Colors.primaryGreen)
                    .shadow(color: AppConstants.Colors.primaryGreen.opacity(0.5), radius: 20)
                
                // App Name
                Text("AVita Harmony")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                // Tagline
                Text("Transform Your Wellness Journey")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // Benefits
                VStack(spacing: 20) {
                    BenefitRow(
                        icon: "figure.mixed.cardio",
                        title: "Adaptive Workouts",
                        description: "Personalized routines that grow with you"
                    )
                    
                    BenefitRow(
                        icon: "brain.head.profile",
                        title: "AI Virtual Coach",
                        description: "Real-time feedback and motivation"
                    )
                    
                    BenefitRow(
                        icon: "sparkles",
                        title: "Interactive Meditation",
                        description: "Mindfulness that responds to you"
                    )
                    
                    BenefitRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Complete Tracking",
                        description: "Monitor your progress and growth"
                    )
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    withAnimation(.spring()) {
                        currentStep = .personalization
                    }
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.UI.buttonHeight)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppConstants.Colors.primaryGreen,
                                    AppConstants.Colors.primaryGreen.opacity(0.8)
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

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 50, height: 50)
                .background(AppConstants.Colors.cardBackground)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
            
            Spacer()
        }
    }
}

enum OnboardingStep {
    case welcome
    case personalization
    case appTour
    case account
    case quickStart
    case complete
}
