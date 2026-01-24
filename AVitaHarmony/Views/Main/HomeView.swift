//
//  HomeView.swift
//  AVitaHarmony
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var fitnessViewModel: FitnessViewModel
    @EnvironmentObject var meditationViewModel: MeditationViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var selectedWorkout: Workout?
    @State private var selectedMeditation: MeditationSession?
    @State private var showingWorkout = false
    @State private var showingMeditation = false
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, \(settingsViewModel.userProfile.name)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            Text("Ready to transform today?")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Streak Badge
                        if settingsViewModel.getCurrentStreak() > 0 {
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(AppConstants.Colors.primaryOrange)
                                Text("\(settingsViewModel.getCurrentStreak())")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppConstants.Colors.textPrimary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppConstants.Colors.cardBackground)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    .padding(.top, 20)
                    
                    // Quick Stats
                    QuickStatsCard(
                        workouts: settingsViewModel.userProfile.totalWorkouts,
                        meditationMinutes: settingsViewModel.userProfile.totalMeditationMinutes,
                        streak: settingsViewModel.userProfile.streak
                    )
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    // Motivational Quote
                    QuoteCard()
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Start")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                // Workout Quick Start
                                QuickActionCard(
                                    icon: "figure.run",
                                    title: "Start Workout",
                                    subtitle: "Get moving now",
                                    color: AppConstants.Colors.primaryGreen
                                ) {
                                    if let workout = fitnessViewModel.availableWorkouts.first {
                                        selectedWorkout = workout
                                        showingWorkout = true
                                    }
                                }
                                
                                // Meditation Quick Start
                                QuickActionCard(
                                    icon: "brain.head.profile",
                                    title: "Meditate",
                                    subtitle: "Find your peace",
                                    color: AppConstants.Colors.primaryOrange
                                ) {
                                    if let session = meditationViewModel.availableSessions.first {
                                        selectedMeditation = session
                                        showingMeditation = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        }
                    }
                    
                    // Recommended Workouts
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recommended Workouts")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(fitnessViewModel.availableWorkouts.prefix(5)) { workout in
                                    WorkoutCard(workout: workout) {
                                        selectedWorkout = workout
                                        showingWorkout = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        }
                    }
                    
                    // Meditation Sessions
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Meditation Sessions")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(meditationViewModel.availableSessions.prefix(5)) { session in
                                    MeditationCard(session: session) {
                                        selectedMeditation = session
                                        showingMeditation = true
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutView(workout: workout, isPresented: $showingWorkout)
                .environmentObject(fitnessViewModel)
                .environmentObject(settingsViewModel)
        }
        .sheet(item: $selectedMeditation) { session in
            MeditationView(session: session, isPresented: $showingMeditation)
                .environmentObject(meditationViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}

struct QuickStatsCard: View {
    let workouts: Int
    let meditationMinutes: Int
    let streak: Int
    
    var body: some View {
        HStack(spacing: 0) {
            StatItem(
                value: "\(workouts)",
                label: "Workouts",
                color: AppConstants.Colors.primaryGreen
            )
            
            Divider()
                .background(AppConstants.Colors.textSecondary.opacity(0.3))
                .frame(height: 40)
            
            StatItem(
                value: "\(meditationMinutes)",
                label: "Minutes",
                color: AppConstants.Colors.primaryOrange
            )
            
            Divider()
                .background(AppConstants.Colors.textSecondary.opacity(0.3))
                .frame(height: 40)
            
            StatItem(
                value: "\(streak)",
                label: "Day Streak",
                color: AppConstants.Colors.primaryRed
            )
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppConstants.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuoteCard: View {
    @State private var currentQuote: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20))
                    .foregroundColor(AppConstants.Colors.primaryGreen)
                Spacer()
            }
            
            Text(currentQuote)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppConstants.Colors.textPrimary)
                .lineSpacing(4)
            
            HStack {
                Spacer()
                Image(systemName: "quote.closing")
                    .font(.system(size: 20))
                    .foregroundColor(AppConstants.Colors.primaryGreen)
            }
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
        .onAppear {
            currentQuote = AppConstants.Quotes.workout.randomElement() ?? "Transform yourself today!"
        }
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
            .padding()
            .frame(width: 160, height: 140)
            .background(AppConstants.Colors.cardBackground)
            .cornerRadius(AppConstants.UI.cornerRadius)
        }
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Category Badge
                HStack {
                    Text(workout.category.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.primaryGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Image(systemName: "flame.fill")
                        .foregroundColor(AppConstants.Colors.primaryOrange)
                        .font(.system(size: 14))
                }
                
                Text(workout.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                    .lineLimit(2)
                
                Text(workout.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Label(workout.formattedDuration, systemImage: "clock")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Spacer()
                    
                    Label("\(workout.caloriesBurned)", systemImage: "flame")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
            }
            .padding()
            .frame(width: 200, height: 200)
            .background(AppConstants.Colors.cardBackground)
            .cornerRadius(AppConstants.UI.cornerRadius)
        }
    }
}

struct MeditationCard: View {
    let session: MeditationSession
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Category Badge
                HStack {
                    Text(session.category.rawValue)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.primaryOrange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(AppConstants.Colors.primaryOrange.opacity(0.2))
                        .cornerRadius(8)
                    
                    Spacer()
                }
                
                Text(session.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                    .lineLimit(2)
                
                Text(session.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Label(session.formattedDuration, systemImage: "clock")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Spacer()
                    
                    Text(session.difficulty.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
            }
            .padding()
            .frame(width: 200, height: 200)
            .background(AppConstants.Colors.cardBackground)
            .cornerRadius(AppConstants.UI.cornerRadius)
        }
    }
}
