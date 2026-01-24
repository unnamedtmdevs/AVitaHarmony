//
//  FeedbackService.swift
//  AVitaHarmony
//

import Foundation

class FeedbackService {
    static let shared = FeedbackService()
    
    private init() {}
    
    // MARK: - Virtual Coach Feedback
    func getWorkoutEncouragement(progress: Double, exerciseName: String) -> String {
        let messages: [String]
        
        if progress < 0.25 {
            messages = [
                "Great start! Keep that energy up!",
                "You've got this! Let's go!",
                "Perfect form on those \(exerciseName)!",
                "Strong start! Keep pushing!",
                "Excellent! You're doing amazing!"
            ]
        } else if progress < 0.50 {
            messages = [
                "You're doing great! Halfway there!",
                "Keep that momentum going!",
                "Look at you go! Impressive!",
                "You're crushing it! Don't stop now!",
                "Fantastic work! Keep it up!"
            ]
        } else if progress < 0.75 {
            messages = [
                "Almost there! You're so strong!",
                "You're in the zone! Keep going!",
                "Incredible effort! Push through!",
                "You're unstoppable today!",
                "Amazing! The finish line is near!"
            ]
        } else {
            messages = [
                "Final push! You've got this!",
                "So close! Finish strong!",
                "You're about to crush this workout!",
                "Last stretch! Give it everything!",
                "Almost done! You're amazing!"
            ]
        }
        
        return messages.randomElement() ?? AppConstants.CoachMessages.encouragement.randomElement()!
    }
    
    func getRestPeriodMessage() -> String {
        return AppConstants.CoachMessages.rest.randomElement() ?? "Rest up! You've earned it."
    }
    
    func getWorkoutCompletionMessage(performance: Double) -> String {
        if performance > 0.8 {
            return "Outstanding performance! You absolutely crushed that workout! 💪"
        } else if performance > 0.6 {
            return "Great job! You completed the workout with solid effort!"
        } else if performance > 0.4 {
            return "Good work! You finished the workout. Keep building that consistency!"
        } else {
            return "You did it! Every workout counts. You're making progress!"
        }
    }
    
    // MARK: - Meditation Feedback
    func getMeditationGuidance(category: MeditationCategory, timeElapsed: Int) -> String? {
        let minutes = timeElapsed / 60
        
        switch category {
        case .breathwork:
            if minutes == 2 {
                return "Notice how your breathing is becoming more natural and rhythmic."
            } else if minutes == 5 {
                return "You're doing wonderfully. Stay with the breath."
            }
        case .mindfulness:
            if minutes == 3 {
                return "If your mind wanders, that's perfectly normal. Gently return to the present."
            } else if minutes == 7 {
                return "Notice the stillness growing within you."
            }
        case .stressRelief:
            if minutes == 2 {
                return "Feel the tension melting away with each breath."
            } else if minutes == 5 {
                return "You're releasing what no longer serves you."
            }
        case .focus:
            if minutes == 3 {
                return "Your concentration is strengthening. Keep your attention steady."
            }
        case .visualization:
            if minutes == 2 {
                return "Let the images come naturally. Don't force them."
            } else if minutes == 5 {
                return "Immerse yourself fully in this visualization."
            }
        default:
            break
        }
        
        return nil
    }
    
    func getMeditationCompletionMessage(focusScore: Double) -> String {
        if focusScore > 0.8 {
            return "Exceptional focus! Your meditation practice is truly deepening. 🧘"
        } else if focusScore > 0.6 {
            return "Great session! You maintained good focus throughout."
        } else if focusScore > 0.4 {
            return "Nice work! Each meditation strengthens your practice."
        } else {
            return "You completed the session! Remember, meditation is a journey, not a destination."
        }
    }
    
    // MARK: - Progress Feedback
    func getStreakMessage(streak: Int) -> String {
        switch streak {
        case 1:
            return "Great start! You've begun your journey to better health! 🎉"
        case 7:
            return "Amazing! One week streak! You're building a powerful habit! 🔥"
        case 14:
            return "Two weeks strong! Your consistency is impressive! ⭐"
        case 30:
            return "30 days! You're officially a wellness warrior! 🏆"
        case 50:
            return "50 days! Your dedication is truly inspiring! 💎"
        case 100:
            return "100 DAYS! You're a true champion! This is legendary! 👑"
        default:
            if streak % 7 == 0 {
                return "\(streak / 7) weeks of consistency! Keep the momentum going! 🚀"
            } else if streak > 100 && streak % 50 == 0 {
                return "\(streak) days! You're unstoppable! 🌟"
            }
            return "Day \(streak)! Your commitment is paying off!"
        }
    }
    
    func getMotivationalQuote(for category: String) -> String {
        if category.lowercased().contains("workout") || category.lowercased().contains("fitness") {
            return AppConstants.Quotes.workout.randomElement() ?? "Keep pushing forward!"
        } else {
            return AppConstants.Quotes.meditation.randomElement() ?? "Find peace within."
        }
    }
    
    // MARK: - Performance Analysis
    func analyzeWorkoutPerformance(session: WorkoutSession) -> String {
        let completedExercises = session.workout.exercises.filter { $0.isCompleted }.count
        let totalExercises = session.workout.exercises.count
        let completionRate = Double(completedExercises) / Double(totalExercises)
        
        var feedback = ""
        
        if completionRate == 1.0 {
            feedback = "Perfect! You completed every exercise! "
        } else if completionRate > 0.75 {
            feedback = "Excellent! You completed most of the workout! "
        } else if completionRate > 0.5 {
            feedback = "Good effort! You made it through more than half! "
        } else {
            feedback = "Every start counts! Try to complete more next time. "
        }
        
        if session.performance > 0.8 {
            feedback += "Your performance was outstanding!"
        } else if session.performance > 0.6 {
            feedback += "You performed well today!"
        } else {
            feedback += "Keep building your strength and endurance!"
        }
        
        return feedback
    }
    
    func analyzeMeditationPerformance(session: ActiveMeditationSession) -> String {
        let focusScore = session.focusScore
        var feedback = ""
        
        if focusScore > 0.8 {
            feedback = "Your focus was exceptional! You're mastering the art of meditation. "
        } else if focusScore > 0.6 {
            feedback = "Great focus! You're making wonderful progress in your practice. "
        } else if focusScore > 0.4 {
            feedback = "Good session! Your meditation skills are developing. "
        } else {
            feedback = "You showed up and that's what matters! Each session improves your focus. "
        }
        
        let durationMinutes = Int(session.duration) / 60
        feedback += "You meditated for \(durationMinutes) minutes. "
        
        if durationMinutes >= 20 {
            feedback += "That's an impressive duration!"
        } else if durationMinutes >= 10 {
            feedback += "A solid meditation length!"
        } else {
            feedback += "Even short sessions have great benefits!"
        }
        
        return feedback
    }
    
    // MARK: - Recommendations
    func getNextWorkoutRecommendation(profile: UserProfile, recentPerformance: Double) -> String {
        var recommendation = ""
        
        if recentPerformance > 0.8 {
            recommendation = "You're ready for a challenge! Try increasing the intensity or duration of your next workout."
        } else if recentPerformance > 0.6 {
            recommendation = "Great progress! Continue with your current routine or add some variety."
        } else {
            recommendation = "Focus on consistency. Stick with your current level and build your foundation."
        }
        
        return recommendation
    }
    
    func getWellnessTip() -> String {
        let tips = [
            "Stay hydrated! Drink at least 8 glasses of water today.",
            "Quality sleep is crucial for recovery. Aim for 7-9 hours tonight.",
            "Protein helps muscle recovery. Include it in your post-workout meal.",
            "Stretch daily to improve flexibility and prevent injury.",
            "Progressive overload is key to improvement. Gradually increase your workout intensity.",
            "Rest days are essential! Your muscles grow during recovery.",
            "Consistency beats intensity. Show up regularly, even if you don't feel 100%.",
            "Mind-muscle connection improves results. Focus on the muscles you're working.",
            "Warm up properly to prevent injury and improve performance.",
            "Track your progress! What gets measured gets improved."
        ]
        
        return tips.randomElement() ?? "Take care of your body. It's the only place you have to live."
    }
}
