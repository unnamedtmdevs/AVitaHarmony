//
//  Constants.swift
//  AVitaHarmony
//

import SwiftUI

struct AppConstants {
    
    // MARK: - Colors
    struct Colors {
        static let background = Color(hex: "0e0e0e")
        static let primaryGreen = Color(hex: "28a809")
        static let primaryRed = Color(hex: "e6053a")
        static let primaryOrange = Color(hex: "d17305")
        
        static let cardBackground = Color(hex: "1a1a1a")
        static let textPrimary = Color.white
        static let textSecondary = Color.gray
    }
    
    // MARK: - App Storage Keys
    struct StorageKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let userProfile = "userProfile"
        static let workoutHistory = "workoutHistory"
        static let meditationHistory = "meditationHistory"
        static let lastWorkoutDate = "lastWorkoutDate"
        static let currentStreak = "currentStreak"
    }
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let spacing: CGFloat = 12
        static let largeSpacing: CGFloat = 24
        static let animationDuration: Double = 0.3
        static let buttonHeight: CGFloat = 56
    }
    
    // MARK: - Motivational Quotes
    struct Quotes {
        static let workout = [
            "Push yourself, because no one else is going to do it for you.",
            "Great things never come from comfort zones.",
            "The only bad workout is the one that didn't happen.",
            "Your body can stand almost anything. It's your mind you have to convince.",
            "Fitness is not about being better than someone else. It's about being better than you used to be."
        ]
        
        static let meditation = [
            "The present moment is filled with joy and happiness. If you are attentive, you will see it.",
            "Meditation is not evasion; it is a serene encounter with reality.",
            "In the midst of movement and chaos, keep stillness inside of you.",
            "Peace comes from within. Do not seek it without.",
            "The thing about meditation is you become more and more you."
        ]
    }
    
    // MARK: - Virtual Coach Messages
    struct CoachMessages {
        static let encouragement = [
            "You're doing amazing! Keep it up!",
            "Great form! I can see the improvement!",
            "You're stronger than you think!",
            "Almost there! Don't give up now!",
            "Excellent work! Your dedication is paying off!",
            "Feel that burn? That's progress happening!",
            "You're crushing it today!"
        ]
        
        static let rest = [
            "Take a deep breath and recover.",
            "Good job! Use this time to recharge.",
            "Rest well, you've earned it!",
            "Breathe deeply and prepare for the next set.",
            "Recovery is just as important as the workout."
        ]
        
        static let completion = [
            "Congratulations! You've completed your workout!",
            "Amazing job! You're one step closer to your goals!",
            "You did it! Your body will thank you later!",
            "Fantastic work! Same time tomorrow?",
            "You're unstoppable! Great session today!"
        ]
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
