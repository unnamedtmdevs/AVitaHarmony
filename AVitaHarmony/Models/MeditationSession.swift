//
//  MeditationSession.swift
//  AVitaHarmony
//

import Foundation

struct MeditationSession: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var duration: Int // in seconds
    var category: MeditationCategory
    var difficulty: MeditationDifficulty
    var backgroundSound: BackgroundSound
    var instructions: [MeditationInstruction]
    var completedAt: Date?
    var rating: Int?
    var focusScore: Double? // 0.0 to 1.0
    
    var formattedDuration: String {
        let minutes = duration / 60
        return "\(minutes) min"
    }
}

enum MeditationCategory: String, Codable, CaseIterable {
    case breathwork = "Breathwork"
    case bodyAwareness = "Body Awareness"
    case mindfulness = "Mindfulness"
    case visualization = "Visualization"
    case stressRelief = "Stress Relief"
    case sleep = "Sleep"
    case focus = "Focus"
}

enum MeditationDifficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum BackgroundSound: String, Codable, CaseIterable {
    case none = "None"
    case ocean = "Ocean Waves"
    case rain = "Rain"
    case forest = "Forest"
    case bells = "Tibetan Bells"
    case singing = "Singing Bowls"
    case white = "White Noise"
}

struct MeditationInstruction: Codable, Identifiable {
    var id: UUID = UUID()
    var timestamp: Int // in seconds from start
    var text: String
    var isInteractive: Bool
    var interactionType: InteractionType?
    
    init(timestamp: Int, text: String, isInteractive: Bool = false, interactionType: InteractionType? = nil) {
        self.timestamp = timestamp
        self.text = text
        self.isInteractive = isInteractive
        self.interactionType = interactionType
    }
}

enum InteractionType: String, Codable {
    case breathIn = "Breathe In"
    case breathOut = "Breathe Out"
    case hold = "Hold"
    case focus = "Focus"
    case release = "Release"
    case visualize = "Visualize"
}

struct ActiveMeditationSession: Codable, Identifiable {
    var id: UUID = UUID()
    var session: MeditationSession
    var startTime: Date
    var endTime: Date?
    var currentInstructionIndex: Int
    var isPaused: Bool
    var interactionResponses: [Bool] // Track user interaction quality
    
    var duration: TimeInterval {
        if let endTime = endTime {
            return endTime.timeIntervalSince(startTime)
        }
        return Date().timeIntervalSince(startTime)
    }
    
    var focusScore: Double {
        guard !interactionResponses.isEmpty else { return 0.0 }
        let positiveResponses = interactionResponses.filter { $0 }.count
        return Double(positiveResponses) / Double(interactionResponses.count)
    }
}
