//
//  MeditationView.swift
//  AVitaHarmony
//

import SwiftUI

struct MeditationView: View {
    let session: MeditationSession
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var meditationViewModel: MeditationViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var showCompletion = false
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            if !meditationViewModel.isSessionActive {
                // Pre-meditation view
                sessionPreview
            } else {
                // Active meditation view
                activeSessionView
            }
            
            if showCompletion {
                completionOverlay
            }
        }
    }
    
    private var sessionPreview: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
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
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.top, 20)
                
                // Session Info
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 60))
                        .foregroundColor(AppConstants.Colors.primaryOrange)
                    
                    Text(session.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(session.description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Stats
                    HStack(spacing: 32) {
                        VStack {
                            Text(session.formattedDuration)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryOrange)
                            Text("Duration")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text(session.category.rawValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryGreen)
                            Text("Category")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text(session.difficulty.rawValue)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryRed)
                            Text("Level")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                    }
                    .padding()
                    .background(AppConstants.Colors.cardBackground)
                    .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                // Background Sound
                VStack(alignment: .leading, spacing: 12) {
                    Text("Background Sound")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                    
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(AppConstants.Colors.primaryOrange)
                        Text(session.backgroundSound.rawValue)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppConstants.Colors.textSecondary)
                        Spacer()
                    }
                    .padding()
                    .background(AppConstants.Colors.cardBackground)
                    .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                // What to Expect
                VStack(alignment: .leading, spacing: 12) {
                    Text("What to Expect")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ExpectationRow(text: "Guided instructions throughout")
                        ExpectationRow(text: "Interactive breathing exercises")
                        ExpectationRow(text: "Calming background sounds")
                        ExpectationRow(text: "Progress tracking")
                    }
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical)
        }
        .overlay(
            VStack {
                Spacer()
                
                Button(action: {
                    meditationViewModel.startSession(session)
                }) {
                    Text("Begin Meditation")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.UI.buttonHeight)
                        .background(AppConstants.Colors.primaryOrange)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                .padding(.bottom, AppConstants.UI.largeSpacing)
            }
        )
    }
    
    private var activeSessionView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    if meditationViewModel.currentSession?.isPaused ?? false {
                        meditationViewModel.resumeSession()
                    } else {
                        meditationViewModel.pauseSession()
                    }
                }) {
                    Image(systemName: meditationViewModel.currentSession?.isPaused ?? false ? "play.fill" : "pause.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(AppConstants.Colors.cardBackground)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    meditationViewModel.cancelSession()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(AppConstants.Colors.cardBackground)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, AppConstants.UI.largeSpacing)
            .padding(.top, 20)
            
            Spacer()
            
            // Breathing Animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                AppConstants.Colors.primaryOrange.opacity(0.3),
                                AppConstants.Colors.primaryOrange.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: breathingCircleSize, height: breathingCircleSize)
                    .animation(.easeInOut(duration: 4), value: breathingCircleSize)
                
                Circle()
                    .stroke(AppConstants.Colors.primaryOrange, lineWidth: 2)
                    .frame(width: breathingCircleSize, height: breathingCircleSize)
                    .animation(.easeInOut(duration: 4), value: breathingCircleSize)
            }
            
            Spacer()
            
            // Current Instruction
            VStack(spacing: 16) {
                Text(meditationViewModel.currentInstruction)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .frame(minHeight: 80)
                
                if meditationViewModel.showInteraction {
                    if let interactionType = meditationViewModel.currentInteractionType {
                        Text(interactionType.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppConstants.Colors.primaryOrange)
                    }
                }
            }
            .padding()
            .background(AppConstants.Colors.cardBackground)
            .cornerRadius(AppConstants.UI.cornerRadius)
            .padding(.horizontal, AppConstants.UI.largeSpacing)
            
            Spacer()
            
            // Progress
            VStack(spacing: 12) {
                HStack {
                    Text(formatTime(meditationViewModel.elapsedTime))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text(formatTime(session.duration))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(AppConstants.Colors.cardBackground)
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(AppConstants.Colors.primaryOrange)
                            .frame(width: geometry.size.width * CGFloat(meditationViewModel.sessionProgress), height: 8)
                            .cornerRadius(4)
                            .animation(.linear, value: meditationViewModel.sessionProgress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, AppConstants.UI.largeSpacing)
            }
            .padding(.bottom, AppConstants.UI.largeSpacing)
        }
        .onChange(of: meditationViewModel.isSessionActive) { newValue in
            if !newValue {
                showCompletion = true
                let minutes = session.duration / 60
                settingsViewModel.incrementMeditationMinutes(minutes)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showCompletion = false
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    private var breathingCircleSize: CGFloat {
        switch meditationViewModel.breathingPhase {
        case .breathIn:
            return 200
        case .breathOut:
            return 100
        case .hold:
            return 150
        case .neutral:
            return 150
        }
    }
    
    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppConstants.Colors.primaryOrange)
                
                Text("Session Complete!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text(meditationViewModel.currentInstruction)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

struct ExpectationRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppConstants.Colors.primaryOrange)
            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(AppConstants.Colors.textSecondary)
            Spacer()
        }
    }
}
