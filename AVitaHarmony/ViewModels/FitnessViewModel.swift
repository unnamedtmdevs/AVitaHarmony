//
//  FitnessViewModel.swift
//  AVitaHarmony
//

import Foundation
import SwiftUI
import Combine

class FitnessViewModel: ObservableObject {
    @Published var availableWorkouts: [Workout] = []
    @Published var currentWorkoutSession: WorkoutSession?
    @Published var workoutHistory: [Workout] = []
    @Published var isWorkoutActive: Bool = false
    @Published var currentExerciseIndex: Int = 0
    @Published var workoutProgress: Double = 0.0
    @Published var elapsedTime: Int = 0
    @Published var currentCoachMessage: String = ""
    @Published var performance: Double = 0.75 // Track user performance
    
    private var timer: Timer?
    private var exerciseStartTime: Date?
    private let workoutService = WorkoutService.shared
    private let feedbackService = FeedbackService.shared
    
    // MARK: - Initialize Workouts
    func loadWorkouts(for profile: UserProfile) {
        availableWorkouts = workoutService.generateWorkouts(for: profile)
    }
    
    // MARK: - Start Workout
    func startWorkout(_ workout: Workout) {
        var mutableWorkout = workout
        mutableWorkout.exercises = workout.exercises.map { exercise in
            var mutableExercise = exercise
            mutableExercise.isCompleted = false
            return mutableExercise
        }
        
        currentWorkoutSession = WorkoutSession(
            workout: mutableWorkout,
            startTime: Date(),
            endTime: nil,
            currentExerciseIndex: 0,
            isPaused: false,
            performance: 0.75
        )
        
        isWorkoutActive = true
        currentExerciseIndex = 0
        elapsedTime = 0
        workoutProgress = 0.0
        exerciseStartTime = Date()
        
        updateCoachMessage()
        startTimer()
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateWorkoutProgress()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Update Progress
    private func updateWorkoutProgress() {
        guard let session = currentWorkoutSession, !session.isPaused else { return }
        
        elapsedTime += 1
        
        let totalDuration = session.workout.exercises.reduce(0) { $0 + $1.duration }
        let completedDuration = session.workout.exercises.prefix(currentExerciseIndex).reduce(0) { $0 + $1.duration }
        
        if currentExerciseIndex < session.workout.exercises.count {
            let currentExerciseDuration = session.workout.exercises[currentExerciseIndex].duration
            let currentElapsed = Int(Date().timeIntervalSince(exerciseStartTime ?? Date()))
            
            workoutProgress = Double(completedDuration + currentElapsed) / Double(totalDuration)
            
            // Check if current exercise is complete
            if currentElapsed >= currentExerciseDuration {
                completeCurrentExercise()
            }
            
            // Update coach message periodically
            if elapsedTime % 15 == 0 {
                updateCoachMessage()
            }
        }
    }
    
    // MARK: - Exercise Control
    func completeCurrentExercise() {
        guard var session = currentWorkoutSession else { return }
        
        // Mark current exercise as completed
        if currentExerciseIndex < session.workout.exercises.count {
            session.workout.exercises[currentExerciseIndex].isCompleted = true
        }
        
        currentExerciseIndex += 1
        
        // Check if workout is complete
        if currentExerciseIndex >= session.workout.exercises.count {
            completeWorkout()
        } else {
            exerciseStartTime = Date()
            currentWorkoutSession = session
            
            // Show rest message if next exercise has rest time
            if let restTime = session.workout.exercises[currentExerciseIndex].restTime, restTime > 0 {
                currentCoachMessage = feedbackService.getRestPeriodMessage()
            } else {
                updateCoachMessage()
            }
        }
    }
    
    func skipExercise() {
        performance = max(0.0, performance - 0.1)
        completeCurrentExercise()
    }
    
    func pauseWorkout() {
        currentWorkoutSession?.isPaused = true
        stopTimer()
    }
    
    func resumeWorkout() {
        currentWorkoutSession?.isPaused = false
        exerciseStartTime = Date()
        startTimer()
    }
    
    // MARK: - Complete Workout
    func completeWorkout() {
        guard var session = currentWorkoutSession else { return }
        
        session.endTime = Date()
        session.performance = performance
        
        var completedWorkout = session.workout
        completedWorkout.completedAt = Date()
        
        // Calculate actual calories burned
        let duration = session.duration
        let calories = workoutService.calculateCalories(
            duration: duration,
            weight: nil,
            intensity: performance
        )
        completedWorkout.caloriesBurned = calories
        
        workoutHistory.append(completedWorkout)
        saveWorkoutHistory()
        
        currentCoachMessage = feedbackService.getWorkoutCompletionMessage(performance: performance)
        
        stopTimer()
        
        // Reset after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isWorkoutActive = false
            self?.currentWorkoutSession = nil
            self?.currentExerciseIndex = 0
            self?.workoutProgress = 0.0
            self?.performance = 0.75
        }
    }
    
    func cancelWorkout() {
        stopTimer()
        isWorkoutActive = false
        currentWorkoutSession = nil
        currentExerciseIndex = 0
        workoutProgress = 0.0
        elapsedTime = 0
        performance = 0.75
    }
    
    // MARK: - Coach Messages
    private func updateCoachMessage() {
        guard let session = currentWorkoutSession,
              currentExerciseIndex < session.workout.exercises.count else { return }
        
        let currentExercise = session.workout.exercises[currentExerciseIndex]
        currentCoachMessage = feedbackService.getWorkoutEncouragement(
            progress: workoutProgress,
            exerciseName: currentExercise.name
        )
    }
    
    // MARK: - Performance Tracking
    func recordGoodPerformance() {
        performance = min(1.0, performance + 0.05)
    }
    
    func recordPoorPerformance() {
        performance = max(0.0, performance - 0.05)
    }
    
    // MARK: - Persistence
    private func saveWorkoutHistory() {
        if let encoded = try? JSONEncoder().encode(workoutHistory) {
            UserDefaults.standard.set(encoded, forKey: AppConstants.StorageKeys.workoutHistory)
        }
    }
    
    func loadWorkoutHistory() {
        if let data = UserDefaults.standard.data(forKey: AppConstants.StorageKeys.workoutHistory),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workoutHistory = decoded
        }
    }
    
    // MARK: - Statistics
    func getTotalWorkouts() -> Int {
        return workoutHistory.count
    }
    
    func getTotalCaloriesBurned() -> Int {
        return workoutHistory.reduce(0) { $0 + $1.caloriesBurned }
    }
    
    func getAverageWorkoutDuration() -> Int {
        guard !workoutHistory.isEmpty else { return 0 }
        let total = workoutHistory.reduce(0) { $0 + $1.duration }
        return total / workoutHistory.count
    }
    
    func getWorkoutsThisWeek() -> Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return workoutHistory.filter { workout in
            guard let completedAt = workout.completedAt else { return false }
            return completedAt > weekAgo
        }.count
    }
    
    deinit {
        stopTimer()
    }
}
