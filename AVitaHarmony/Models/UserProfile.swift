//
//  UserProfile.swift
//  AVitaHarmony
//

import Foundation

struct UserProfile: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var email: String
    var fitnessGoal: FitnessGoal
    var fitnessLevel: FitnessLevel
    var age: Int?
    var weight: Double? // in kg
    var height: Double? // in cm
    var isGuest: Bool
    var createdAt: Date
    var totalWorkouts: Int
    var totalMeditationMinutes: Int
    var streak: Int
    var preferredWorkoutDuration: Int // in minutes
    var preferredMeditationDuration: Int // in minutes
    
    init(name: String = "Guest",
         email: String = "",
         fitnessGoal: FitnessGoal = .general,
         fitnessLevel: FitnessLevel = .beginner,
         age: Int? = nil,
         weight: Double? = nil,
         height: Double? = nil,
         isGuest: Bool = false,
         createdAt: Date = Date(),
         totalWorkouts: Int = 0,
         totalMeditationMinutes: Int = 0,
         streak: Int = 0,
         preferredWorkoutDuration: Int = 30,
         preferredMeditationDuration: Int = 10) {
        self.name = name
        self.email = email
        self.fitnessGoal = fitnessGoal
        self.fitnessLevel = fitnessLevel
        self.age = age
        self.weight = weight
        self.height = height
        self.isGuest = isGuest
        self.createdAt = createdAt
        self.totalWorkouts = totalWorkouts
        self.totalMeditationMinutes = totalMeditationMinutes
        self.streak = streak
        self.preferredWorkoutDuration = preferredWorkoutDuration
        self.preferredMeditationDuration = preferredMeditationDuration
    }
}

enum FitnessGoal: String, Codable, CaseIterable {
    case weightLoss = "Weight Loss"
    case muscleGain = "Muscle Gain"
    case endurance = "Endurance"
    case flexibility = "Flexibility"
    case general = "General Fitness"
    case stressRelief = "Stress Relief"
}

enum FitnessLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}
