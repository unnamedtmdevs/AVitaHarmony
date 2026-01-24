//
//  DashboardView.swift
//  AVitaHarmony
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var fitnessViewModel: FitnessViewModel
    @EnvironmentObject var meditationViewModel: MeditationViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Dashboard")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppConstants.Colors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    .padding(.top, 20)
                    
                    // Streak Card
                    if settingsViewModel.getCurrentStreak() > 0 {
                        StreakCard(streak: settingsViewModel.getCurrentStreak())
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Overall Stats
                    OverallStatsCard(
                        totalWorkouts: fitnessViewModel.getTotalWorkouts(),
                        totalMeditationMinutes: meditationViewModel.getTotalMinutes(),
                        totalCalories: fitnessViewModel.getTotalCaloriesBurned(),
                        currentStreak: settingsViewModel.getCurrentStreak()
                    )
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    // Weekly Overview
                    WeeklyOverviewCard(
                        workoutsThisWeek: fitnessViewModel.getWorkoutsThisWeek(),
                        meditationsThisWeek: meditationViewModel.getSessionsThisWeek()
                    )
                    .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    // Recent Workouts
                    if !fitnessViewModel.workoutHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Workouts")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            ForEach(fitnessViewModel.workoutHistory.suffix(5).reversed(), id: \.id) { workout in
                                WorkoutHistoryCard(workout: workout)
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Recent Meditation Sessions
                    if !meditationViewModel.meditationHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Meditations")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppConstants.Colors.textPrimary)
                            
                            ForEach(meditationViewModel.meditationHistory.suffix(5).reversed(), id: \.id) { session in
                                MeditationHistoryCard(session: session)
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                    
                    // Wellness Tips
                    WellnessTipCard()
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    Spacer(minLength: 100)
                }
                .padding(.vertical)
            }
        }
    }
}

struct StreakCard: View {
    let streak: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .font(.system(size: 48))
                .foregroundColor(AppConstants.Colors.primaryOrange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(streak) Day Streak!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text(FeedbackService.shared.getStreakMessage(streak: streak))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    AppConstants.Colors.primaryOrange.opacity(0.2),
                    AppConstants.Colors.primaryRed.opacity(0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}

struct OverallStatsCard: View {
    let totalWorkouts: Int
    let totalMeditationMinutes: Int
    let totalCalories: Int
    let currentStreak: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Overall Progress")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    StatRow(
                        icon: "figure.run",
                        label: "Total Workouts",
                        value: "\(totalWorkouts)",
                        color: AppConstants.Colors.primaryGreen
                    )
                    
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    StatRow(
                        icon: "brain.head.profile",
                        label: "Meditation Minutes",
                        value: "\(totalMeditationMinutes)",
                        color: AppConstants.Colors.primaryOrange
                    )
                    
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    StatRow(
                        icon: "flame.fill",
                        label: "Calories Burned",
                        value: "\(totalCalories)",
                        color: AppConstants.Colors.primaryRed
                    )
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
            }
        }
    }
}

struct WeeklyOverviewCard: View {
    let workoutsThisWeek: Int
    let meditationsThisWeek: Int
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                Spacer()
            }
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("\(workoutsThisWeek)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppConstants.Colors.primaryGreen)
                    
                    Text("Workouts")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppConstants.Colors.primaryGreen.opacity(0.1))
                .cornerRadius(AppConstants.UI.cornerRadius)
                
                VStack(spacing: 8) {
                    Text("\(meditationsThisWeek)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppConstants.Colors.primaryOrange)
                    
                    Text("Meditations")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppConstants.Colors.primaryOrange.opacity(0.1))
                .cornerRadius(AppConstants.UI.cornerRadius)
            }
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}

struct WorkoutHistoryCard: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppConstants.Colors.primaryGreen)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                HStack {
                    Text(workout.formattedDuration)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Text("•")
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Text("\(workout.caloriesBurned) cal")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            if let completedAt = workout.completedAt {
                Text(formatDate(completedAt))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct MeditationHistoryCard: View {
    let session: MeditationSession
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppConstants.Colors.primaryOrange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                HStack {
                    Text(session.formattedDuration)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Text("•")
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    Text(session.category.rawValue)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            if let completedAt = session.completedAt {
                Text(formatDate(completedAt))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct WellnessTipCard: View {
    @State private var tip: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(AppConstants.Colors.primaryGreen)
                Text("Wellness Tip")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                Spacer()
            }
            
            Text(tip)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(AppConstants.Colors.textSecondary)
                .lineSpacing(4)
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
        .onAppear {
            tip = FeedbackService.shared.getWellnessTip()
        }
    }
}
