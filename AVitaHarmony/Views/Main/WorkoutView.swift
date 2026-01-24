//
//  WorkoutView.swift
//  AVitaHarmony
//

import SwiftUI

struct WorkoutView: View {
    let workout: Workout
    @Binding var isPresented: Bool
    @EnvironmentObject var fitnessViewModel: FitnessViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var showCompletion = false
    
    var body: some View {
        ZStack {
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            if !fitnessViewModel.isWorkoutActive {
                // Pre-workout view
                workoutPreview
            } else {
                // Active workout view
                activeWorkoutView
            }
            
            if showCompletion {
                completionOverlay
            }
        }
    }
    
    private var workoutPreview: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button(action: {
                        isPresented = false
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
                
                // Workout Info
                VStack(spacing: 16) {
                    Text(workout.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(workout.description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Stats
                    HStack(spacing: 32) {
                        VStack {
                            Text(workout.formattedDuration)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryGreen)
                            Text("Duration")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text("\(workout.caloriesBurned)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppConstants.Colors.primaryOrange)
                            Text("Calories")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(AppConstants.Colors.textSecondary)
                        }
                        
                        VStack {
                            Text(workout.difficulty.rawValue)
                                .font(.system(size: 24, weight: .bold))
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
                
                // Exercises List
                VStack(alignment: .leading, spacing: 16) {
                    Text("Exercises (\(workout.exercises.count))")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .padding(.horizontal, AppConstants.UI.largeSpacing)
                    
                    ForEach(workout.exercises) { exercise in
                        ExercisePreviewCard(exercise: exercise)
                            .padding(.horizontal, AppConstants.UI.largeSpacing)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.vertical)
        }
        .overlay(
            VStack {
                Spacer()
                
                Button(action: {
                    fitnessViewModel.startWorkout(workout)
                }) {
                    Text("Start Workout")
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
        )
    }
    
    private var activeWorkoutView: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Button(action: {
                    fitnessViewModel.pauseWorkout()
                }) {
                    Image(systemName: fitnessViewModel.currentWorkoutSession?.isPaused ?? false ? "play.fill" : "pause.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(AppConstants.Colors.cardBackground)
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {
                    fitnessViewModel.cancelWorkout()
                    isPresented = false
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
            
            // Current Exercise
            if let session = fitnessViewModel.currentWorkoutSession,
               fitnessViewModel.currentExerciseIndex < session.workout.exercises.count {
                let currentExercise = session.workout.exercises[fitnessViewModel.currentExerciseIndex]
                
                VStack(spacing: 24) {
                    // Progress
                    Text("Exercise \(fitnessViewModel.currentExerciseIndex + 1) of \(session.workout.exercises.count)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                    
                    // Exercise Name
                    Text(currentExercise.name)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(AppConstants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Exercise Description
                    Text(currentExercise.description)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Timer or Reps
                    if let reps = currentExercise.reps {
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(reps)")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(AppConstants.Colors.primaryGreen)
                                Text("Reps")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppConstants.Colors.textSecondary)
                            }
                            
                            if let sets = currentExercise.sets {
                                VStack {
                                    Text("\(sets)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(AppConstants.Colors.primaryOrange)
                                    Text("Sets")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(AppConstants.Colors.textSecondary)
                                }
                            }
                        }
                    }
                    
                    // Coach Message
                    Text(fitnessViewModel.currentCoachMessage)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.primaryGreen)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                        .padding(.horizontal, 32)
                }
            }
            
            Spacer()
            
            // Progress Bar
            VStack(spacing: 12) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(AppConstants.Colors.cardBackground)
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(AppConstants.Colors.primaryGreen)
                            .frame(width: geometry.size.width * CGFloat(fitnessViewModel.workoutProgress), height: 8)
                            .cornerRadius(4)
                            .animation(.linear, value: fitnessViewModel.workoutProgress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal, AppConstants.UI.largeSpacing)
                
                Text("\(Int(fitnessViewModel.workoutProgress * 100))% Complete")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textSecondary)
            }
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: {
                    fitnessViewModel.skipExercise()
                }) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppConstants.Colors.cardBackground)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
                
                Button(action: {
                    fitnessViewModel.completeCurrentExercise()
                }) {
                    Text("Complete")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppConstants.Colors.primaryGreen)
                        .cornerRadius(AppConstants.UI.cornerRadius)
                }
            }
            .padding(.horizontal, AppConstants.UI.largeSpacing)
            .padding(.bottom, AppConstants.UI.largeSpacing)
        }
        .onChange(of: fitnessViewModel.isWorkoutActive) { newValue in
            if !newValue {
                showCompletion = true
                settingsViewModel.incrementWorkoutCount()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCompletion = false
                    isPresented = false
                }
            }
        }
    }
    
    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppConstants.Colors.primaryGreen)
                
                Text("Workout Complete!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                Text(fitnessViewModel.currentCoachMessage)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppConstants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

struct ExercisePreviewCard: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: "figure.run")
                .font(.system(size: 24))
                .foregroundColor(AppConstants.Colors.primaryGreen)
                .frame(width: 50, height: 50)
                .background(AppConstants.Colors.primaryGreen.opacity(0.2))
                .cornerRadius(12)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppConstants.Colors.textPrimary)
                
                if let reps = exercise.reps, let sets = exercise.sets {
                    Text("\(reps) reps × \(sets) sets")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                } else {
                    Text("\(exercise.duration)s")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppConstants.Colors.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(AppConstants.Colors.cardBackground)
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
}
