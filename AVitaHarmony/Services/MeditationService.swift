//
//  MeditationService.swift
//  AVitaHarmony
//

import Foundation

class MeditationService {
    static let shared = MeditationService()
    
    private init() {}
    
    // MARK: - Generate Meditation Sessions
    func generateMeditationSessions(for profile: UserProfile) -> [MeditationSession] {
        var sessions: [MeditationSession] = []
        
        // Generate sessions based on fitness goals and preferences
        sessions.append(contentsOf: generateBreathworkSessions())
        sessions.append(contentsOf: generateMindfulnessSessions())
        sessions.append(contentsOf: generateStressReliefSessions())
        sessions.append(contentsOf: generateFocusSessions())
        sessions.append(contentsOf: generateVisualizationSessions())
        
        // Filter based on preferred duration
        return sessions.filter { session in
            let minutes = session.duration / 60
            return abs(minutes - profile.preferredMeditationDuration) <= 10
        }
    }
    
    // MARK: - Breathwork Sessions
    private func generateBreathworkSessions() -> [MeditationSession] {
        return [
            MeditationSession(
                title: "Box Breathing",
                description: "A calming breathwork technique used by athletes and professionals",
                duration: 600, // 10 minutes
                category: .breathwork,
                difficulty: .beginner,
                backgroundSound: .ocean,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Welcome to Box Breathing. Find a comfortable seated position."),
                    MeditationInstruction(timestamp: 10, text: "We'll breathe in a pattern of 4-4-4-4. Ready?"),
                    MeditationInstruction(timestamp: 20, text: "Breathe in...", isInteractive: true, interactionType: .breathIn),
                    MeditationInstruction(timestamp: 24, text: "Hold...", isInteractive: true, interactionType: .hold),
                    MeditationInstruction(timestamp: 28, text: "Breathe out...", isInteractive: true, interactionType: .breathOut),
                    MeditationInstruction(timestamp: 32, text: "Hold...", isInteractive: true, interactionType: .hold),
                    MeditationInstruction(timestamp: 36, text: "Continue this pattern...", isInteractive: true, interactionType: .breathIn),
                    MeditationInstruction(timestamp: 300, text: "You're halfway there. Notice how calm you feel."),
                    MeditationInstruction(timestamp: 570, text: "Begin to slow down your breathing."),
                    MeditationInstruction(timestamp: 590, text: "Take one final deep breath and release. Well done.")
                ]
            ),
            MeditationSession(
                title: "4-7-8 Breathing",
                description: "A powerful technique for relaxation and sleep",
                duration: 480, // 8 minutes
                category: .breathwork,
                difficulty: .beginner,
                backgroundSound: .rain,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Welcome. This technique helps you relax deeply."),
                    MeditationInstruction(timestamp: 10, text: "Breathe in for 4 counts...", isInteractive: true, interactionType: .breathIn),
                    MeditationInstruction(timestamp: 14, text: "Hold for 7 counts...", isInteractive: true, interactionType: .hold),
                    MeditationInstruction(timestamp: 21, text: "Exhale for 8 counts...", isInteractive: true, interactionType: .breathOut),
                    MeditationInstruction(timestamp: 29, text: "Again, breathe in...", isInteractive: true, interactionType: .breathIn),
                    MeditationInstruction(timestamp: 240, text: "Feel the relaxation spreading through your body."),
                    MeditationInstruction(timestamp: 460, text: "Prepare to finish the session."),
                    MeditationInstruction(timestamp: 475, text: "Return to normal breathing. Excellent work.")
                ]
            ),
            MeditationSession(
                title: "Energizing Breath",
                description: "Activate your body and mind with this dynamic breathwork",
                duration: 600,
                category: .breathwork,
                difficulty: .intermediate,
                backgroundSound: .bells,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "This practice will energize you. Sit up tall."),
                    MeditationInstruction(timestamp: 10, text: "Take quick, powerful breaths through your nose."),
                    MeditationInstruction(timestamp: 20, text: "Breathe in sharply!", isInteractive: true, interactionType: .breathIn),
                    MeditationInstruction(timestamp: 21, text: "Breathe out!", isInteractive: true, interactionType: .breathOut),
                    MeditationInstruction(timestamp: 300, text: "Feel the energy building in your body."),
                    MeditationInstruction(timestamp: 580, text: "Slow down and return to normal breathing.")
                ]
            )
        ]
    }
    
    // MARK: - Mindfulness Sessions
    private func generateMindfulnessSessions() -> [MeditationSession] {
        return [
            MeditationSession(
                title: "Body Scan",
                description: "Connect with your body through mindful awareness",
                duration: 900, // 15 minutes
                category: .bodyAwareness,
                difficulty: .beginner,
                backgroundSound: .forest,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Lie down or sit comfortably. Close your eyes."),
                    MeditationInstruction(timestamp: 20, text: "Bring awareness to your toes. Notice any sensations."),
                    MeditationInstruction(timestamp: 120, text: "Move your attention to your feet and ankles."),
                    MeditationInstruction(timestamp: 240, text: "Scan through your lower legs, noticing any tension."),
                    MeditationInstruction(timestamp: 360, text: "Bring awareness to your thighs and hips.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 480, text: "Notice your abdomen and lower back."),
                    MeditationInstruction(timestamp: 600, text: "Scan your chest and upper back. Breathe deeply."),
                    MeditationInstruction(timestamp: 720, text: "Bring attention to your shoulders, arms, and hands.", isInteractive: true, interactionType: .release),
                    MeditationInstruction(timestamp: 780, text: "Finally, scan your neck, face, and head."),
                    MeditationInstruction(timestamp: 840, text: "Feel your whole body as one connected system."),
                    MeditationInstruction(timestamp: 880, text: "Slowly open your eyes when you're ready.")
                ]
            ),
            MeditationSession(
                title: "Present Moment Awareness",
                description: "Simple mindfulness practice for beginners",
                duration: 600,
                category: .mindfulness,
                difficulty: .beginner,
                backgroundSound: .ocean,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Sit comfortably and close your eyes."),
                    MeditationInstruction(timestamp: 15, text: "Notice the sounds around you without judgment."),
                    MeditationInstruction(timestamp: 120, text: "Bring attention to your breath.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 240, text: "When your mind wanders, gently return to the breath."),
                    MeditationInstruction(timestamp: 360, text: "Notice any thoughts without getting caught in them.", isInteractive: true, interactionType: .release),
                    MeditationInstruction(timestamp: 480, text: "Simply be present in this moment."),
                    MeditationInstruction(timestamp: 570, text: "Begin to deepen your breath."),
                    MeditationInstruction(timestamp: 590, text: "When you're ready, open your eyes.")
                ]
            )
        ]
    }
    
    // MARK: - Stress Relief Sessions
    private func generateStressReliefSessions() -> [MeditationSession] {
        return [
            MeditationSession(
                title: "Letting Go",
                description: "Release stress and tension from your day",
                duration: 720,
                category: .stressRelief,
                difficulty: .beginner,
                backgroundSound: .rain,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Find a comfortable position. Take a deep breath."),
                    MeditationInstruction(timestamp: 20, text: "Acknowledge any stress you're feeling without judgment."),
                    MeditationInstruction(timestamp: 120, text: "Imagine stress as a color. What color is it?", isInteractive: true, interactionType: .visualize),
                    MeditationInstruction(timestamp: 180, text: "With each exhale, imagine this color leaving your body.", isInteractive: true, interactionType: .release),
                    MeditationInstruction(timestamp: 360, text: "Feel yourself becoming lighter with each breath."),
                    MeditationInstruction(timestamp: 540, text: "Notice how much calmer you feel now."),
                    MeditationInstruction(timestamp: 690, text: "Carry this peace with you as you return to your day.")
                ]
            ),
            MeditationSession(
                title: "Calm Mind",
                description: "Quiet mental chatter and find inner peace",
                duration: 900,
                category: .stressRelief,
                difficulty: .intermediate,
                backgroundSound: .singing,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Close your eyes and settle into your seat."),
                    MeditationInstruction(timestamp: 30, text: "Notice the thoughts passing through your mind."),
                    MeditationInstruction(timestamp: 120, text: "Imagine each thought as a cloud floating by.", isInteractive: true, interactionType: .visualize),
                    MeditationInstruction(timestamp: 240, text: "Don't grab onto the clouds. Just watch them pass."),
                    MeditationInstruction(timestamp: 450, text: "Return to the stillness between thoughts.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 720, text: "Rest in this quiet space."),
                    MeditationInstruction(timestamp: 870, text: "Gently return to the present moment.")
                ]
            )
        ]
    }
    
    // MARK: - Focus Sessions
    private func generateFocusSessions() -> [MeditationSession] {
        return [
            MeditationSession(
                title: "Mental Clarity",
                description: "Sharpen your focus and concentration",
                duration: 600,
                category: .focus,
                difficulty: .intermediate,
                backgroundSound: .white,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Sit with a straight spine. Eyes closed or softly focused."),
                    MeditationInstruction(timestamp: 20, text: "Choose a single point of focus - your breath."),
                    MeditationInstruction(timestamp: 60, text: "Count your breaths from 1 to 10, then start over.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 180, text: "If you lose count, simply start again at 1."),
                    MeditationInstruction(timestamp: 360, text: "Notice how your focus becomes sharper.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 540, text: "This concentrated attention is available anytime."),
                    MeditationInstruction(timestamp: 580, text: "Slowly transition back to normal awareness.")
                ]
            ),
            MeditationSession(
                title: "Deep Concentration",
                description: "Advanced focus training",
                duration: 1200,
                category: .focus,
                difficulty: .advanced,
                backgroundSound: .bells,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "This is a deep concentration practice. Be patient."),
                    MeditationInstruction(timestamp: 30, text: "Focus on a single point - the tip of your nose."),
                    MeditationInstruction(timestamp: 120, text: "Feel the subtle sensations of breath at this point.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 600, text: "Maintain unwavering focus. You're doing great."),
                    MeditationInstruction(timestamp: 1140, text: "Gradually expand your awareness."),
                    MeditationInstruction(timestamp: 1180, text: "Open your eyes slowly. Notice your mental clarity.")
                ]
            )
        ]
    }
    
    // MARK: - Visualization Sessions
    private func generateVisualizationSessions() -> [MeditationSession] {
        return [
            MeditationSession(
                title: "Peaceful Place",
                description: "Create your personal sanctuary in your mind",
                duration: 900,
                category: .visualization,
                difficulty: .beginner,
                backgroundSound: .ocean,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Close your eyes and take three deep breaths."),
                    MeditationInstruction(timestamp: 30, text: "Imagine a place where you feel completely at peace.", isInteractive: true, interactionType: .visualize),
                    MeditationInstruction(timestamp: 90, text: "What do you see? Notice the colors and shapes."),
                    MeditationInstruction(timestamp: 180, text: "What sounds do you hear in this peaceful place?"),
                    MeditationInstruction(timestamp: 300, text: "Feel the temperature. Is there a breeze?", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 480, text: "Notice how safe and relaxed you feel here."),
                    MeditationInstruction(timestamp: 720, text: "Remember you can return to this place anytime."),
                    MeditationInstruction(timestamp: 840, text: "Slowly say goodbye to this place for now."),
                    MeditationInstruction(timestamp: 880, text: "Return to the present, feeling refreshed.")
                ]
            ),
            MeditationSession(
                title: "Goal Visualization",
                description: "Visualize achieving your fitness and wellness goals",
                duration: 720,
                category: .visualization,
                difficulty: .intermediate,
                backgroundSound: .forest,
                instructions: [
                    MeditationInstruction(timestamp: 0, text: "Sit comfortably and breathe deeply."),
                    MeditationInstruction(timestamp: 20, text: "Think of a goal you want to achieve.", isInteractive: true, interactionType: .visualize),
                    MeditationInstruction(timestamp: 90, text: "Imagine yourself having already achieved this goal."),
                    MeditationInstruction(timestamp: 180, text: "How do you look? How do you feel?", isInteractive: true, interactionType: .visualize),
                    MeditationInstruction(timestamp: 300, text: "See yourself confident and successful."),
                    MeditationInstruction(timestamp: 480, text: "Feel the emotions of this achievement.", isInteractive: true, interactionType: .focus),
                    MeditationInstruction(timestamp: 660, text: "This future is yours to create."),
                    MeditationInstruction(timestamp: 700, text: "Return to the present with renewed motivation.")
                ]
            )
        ]
    }
    
    // MARK: - Adapt Session Based on Focus Score
    func adaptSession(_ session: MeditationSession, focusScore: Double) -> MeditationSession {
        var adaptedSession = session
        
        // If focus is high (>0.75), move to next difficulty or increase duration
        if focusScore > 0.75 {
            if session.difficulty == .beginner {
                adaptedSession.difficulty = .intermediate
            } else if session.difficulty == .intermediate {
                adaptedSession.difficulty = .advanced
            }
            adaptedSession.duration = Int(Double(session.duration) * 1.2)
        }
        // If focus is low (<0.4), simplify the session
        else if focusScore < 0.4 {
            adaptedSession.duration = Int(Double(session.duration) * 0.8)
            if session.difficulty == .advanced {
                adaptedSession.difficulty = .intermediate
            } else if session.difficulty == .intermediate {
                adaptedSession.difficulty = .beginner
            }
        }
        
        return adaptedSession
    }
    
    // MARK: - Get Next Instruction
    func getNextInstruction(for session: MeditationSession, currentTime: Int) -> MeditationInstruction? {
        return session.instructions.first { instruction in
            instruction.timestamp <= currentTime &&
            instruction.timestamp > currentTime - 5
        }
    }
}
