//
//  Workout.swift
//  AVitaHarmony
//

import Foundation

struct Workout: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var duration: Int // in seconds
    var difficulty: FitnessLevel
    var category: WorkoutCategory
    var exercises: [Exercise]
    var caloriesBurned: Int
    var completedAt: Date?
    var rating: Int?
    
    var formattedDuration: String {
        let minutes = duration / 60
        let seconds = duration % 60
        if seconds == 0 {
            return "\(minutes)m"
        }
        return "\(minutes)m \(seconds)s"
    }
}

enum WorkoutCategory: String, Codable, CaseIterable {
    case cardio = "Cardio"
    case strength = "Strength"
    case yoga = "Yoga"
    case hiit = "HIIT"
    case stretching = "Stretching"
    case fullBody = "Full Body"
}

struct Exercise: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var duration: Int // in seconds
    var reps: Int?
    var sets: Int?
    var restTime: Int? // in seconds
    var videoURL: String?
    var instructions: [String]
    var targetMuscles: [String]
    var isCompleted: Bool
    
    init(name: String,
         description: String,
         duration: Int,
         reps: Int? = nil,
         sets: Int? = nil,
         restTime: Int? = nil,
         videoURL: String? = nil,
         instructions: [String] = [],
         targetMuscles: [String] = [],
         isCompleted: Bool = false) {
        self.name = name
        self.description = description
        self.duration = duration
        self.reps = reps
        self.sets = sets
        self.restTime = restTime
        self.videoURL = videoURL
        self.instructions = instructions
        self.targetMuscles = targetMuscles
        self.isCompleted = isCompleted
    }
}

struct WorkoutSession: Codable, Identifiable {
    var id: UUID = UUID()
    var workout: Workout
    var startTime: Date
    var endTime: Date?
    var currentExerciseIndex: Int
    var isPaused: Bool
    var performance: Double // 0.0 to 1.0
    
    var duration: TimeInterval {
        if let endTime = endTime {
            return endTime.timeIntervalSince(startTime)
        }
        return Date().timeIntervalSince(startTime)
    }
}
