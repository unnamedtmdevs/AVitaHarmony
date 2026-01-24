//
//  SettingsViewModel.swift
//  AVitaHarmony
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var notificationsEnabled: Bool = true
    @Published var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var soundEnabled: Bool = true
    @Published var hapticsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = true
    
    init(profile: UserProfile) {
        self.userProfile = profile
        loadSettings()
    }
    
    // MARK: - Profile Management
    func updateProfile(name: String? = nil,
                      email: String? = nil,
                      fitnessGoal: FitnessGoal? = nil,
                      fitnessLevel: FitnessLevel? = nil,
                      age: Int? = nil,
                      weight: Double? = nil,
                      height: Double? = nil) {
        if let name = name {
            userProfile.name = name
        }
        if let email = email {
            userProfile.email = email
        }
        if let fitnessGoal = fitnessGoal {
            userProfile.fitnessGoal = fitnessGoal
        }
        if let fitnessLevel = fitnessLevel {
            userProfile.fitnessLevel = fitnessLevel
        }
        if let age = age {
            userProfile.age = age
        }
        if let weight = weight {
            userProfile.weight = weight
        }
        if let height = height {
            userProfile.height = height
        }
        
        saveProfile()
    }
    
    func updateWorkoutPreferences(duration: Int) {
        userProfile.preferredWorkoutDuration = duration
        saveProfile()
    }
    
    func updateMeditationPreferences(duration: Int) {
        userProfile.preferredMeditationDuration = duration
        saveProfile()
    }
    
    func incrementWorkoutCount() {
        userProfile.totalWorkouts += 1
        updateStreak()
        saveProfile()
    }
    
    func incrementMeditationMinutes(_ minutes: Int) {
        userProfile.totalMeditationMinutes += minutes
        updateStreak()
        saveProfile()
    }
    
    // MARK: - Streak Management
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastWorkoutDateData = UserDefaults.standard.object(forKey: AppConstants.StorageKeys.lastWorkoutDate) as? Date {
            let lastWorkoutDate = calendar.startOfDay(for: lastWorkoutDateData)
            let daysDifference = calendar.dateComponents([.day], from: lastWorkoutDate, to: today).day ?? 0
            
            if daysDifference == 0 {
                // Same day, streak continues
                return
            } else if daysDifference == 1 {
                // Consecutive day, increment streak
                userProfile.streak += 1
            } else {
                // Streak broken, reset
                userProfile.streak = 1
            }
        } else {
            // First workout
            userProfile.streak = 1
        }
        
        UserDefaults.standard.set(Date(), forKey: AppConstants.StorageKeys.lastWorkoutDate)
        saveProfile()
    }
    
    func getCurrentStreak() -> Int {
        return userProfile.streak
    }
    
    // MARK: - Settings Management
    func toggleNotifications() {
        notificationsEnabled.toggle()
        saveSettings()
    }
    
    func updateReminderTime(_ time: Date) {
        reminderTime = time
        saveSettings()
    }
    
    func toggleSound() {
        soundEnabled.toggle()
        saveSettings()
    }
    
    func toggleHaptics() {
        hapticsEnabled.toggle()
        saveSettings()
    }
    
    func toggleDarkMode() {
        darkModeEnabled.toggle()
        saveSettings()
    }
    
    // MARK: - Account Management
    func deleteAccount() {
        // Clear all user data (but don't actually delete the account as per requirements)
        userProfile = UserProfile(isGuest: true)
        
        // Clear all stored data
        UserDefaults.standard.removeObject(forKey: AppConstants.StorageKeys.userProfile)
        UserDefaults.standard.removeObject(forKey: AppConstants.StorageKeys.workoutHistory)
        UserDefaults.standard.removeObject(forKey: AppConstants.StorageKeys.meditationHistory)
        UserDefaults.standard.removeObject(forKey: AppConstants.StorageKeys.lastWorkoutDate)
        UserDefaults.standard.removeObject(forKey: AppConstants.StorageKeys.currentStreak)
        UserDefaults.standard.set(false, forKey: AppConstants.StorageKeys.hasCompletedOnboarding)
        
        // Reset settings to defaults
        notificationsEnabled = true
        soundEnabled = true
        hapticsEnabled = true
        darkModeEnabled = true
    }
    
    func logout() {
        userProfile = UserProfile(isGuest: true)
        UserDefaults.standard.set(false, forKey: AppConstants.StorageKeys.hasCompletedOnboarding)
    }
    
    // MARK: - Persistence
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: AppConstants.StorageKeys.userProfile)
        }
    }
    
    func loadProfile() -> UserProfile {
        if let data = UserDefaults.standard.data(forKey: AppConstants.StorageKeys.userProfile),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return decoded
        }
        return UserProfile(isGuest: true)
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(hapticsEnabled, forKey: "hapticsEnabled")
        UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled")
    }
    
    private func loadSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        if let savedTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date {
            reminderTime = savedTime
        }
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }
    
    // MARK: - Statistics
    func getBMI() -> Double? {
        guard let weight = userProfile.weight,
              let height = userProfile.height,
              height > 0 else { return nil }
        
        let heightInMeters = height / 100.0
        return weight / (heightInMeters * heightInMeters)
    }
    
    func getBMICategory() -> String {
        guard let bmi = getBMI() else { return "N/A" }
        
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
}
