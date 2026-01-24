//
//  MeditationViewModel.swift
//  AVitaHarmony
//

import Foundation
import SwiftUI
import Combine

class MeditationViewModel: ObservableObject {
    @Published var availableSessions: [MeditationSession] = []
    @Published var currentSession: ActiveMeditationSession?
    @Published var meditationHistory: [MeditationSession] = []
    @Published var isSessionActive: Bool = false
    @Published var sessionProgress: Double = 0.0
    @Published var elapsedTime: Int = 0
    @Published var currentInstruction: String = ""
    @Published var currentInteractionType: InteractionType?
    @Published var showInteraction: Bool = false
    @Published var breathingPhase: BreathingPhase = .neutral
    
    private var timer: Timer?
    private let meditationService = MeditationService.shared
    private let feedbackService = FeedbackService.shared
    
    enum BreathingPhase {
        case neutral
        case breathIn
        case hold
        case breathOut
    }
    
    // MARK: - Initialize Sessions
    func loadSessions(for profile: UserProfile) {
        availableSessions = meditationService.generateMeditationSessions(for: profile)
    }
    
    // MARK: - Start Session
    func startSession(_ session: MeditationSession) {
        currentSession = ActiveMeditationSession(
            session: session,
            startTime: Date(),
            endTime: nil,
            currentInstructionIndex: 0,
            isPaused: false,
            interactionResponses: []
        )
        
        isSessionActive = true
        elapsedTime = 0
        sessionProgress = 0.0
        currentInstruction = "Beginning your meditation session..."
        
        startTimer()
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateSessionProgress()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Update Progress
    private func updateSessionProgress() {
        guard var session = currentSession, !session.isPaused else { return }
        
        elapsedTime += 1
        sessionProgress = Double(elapsedTime) / Double(session.session.duration)
        
        // Check for new instructions
        if let instruction = meditationService.getNextInstruction(
            for: session.session,
            currentTime: elapsedTime
        ) {
            displayInstruction(instruction)
            
            if session.currentInstructionIndex < session.session.instructions.count {
                session.currentInstructionIndex += 1
                currentSession = session
            }
        }
        
        // Get periodic guidance
        if elapsedTime % 60 == 0 {
            if let guidance = feedbackService.getMeditationGuidance(
                category: session.session.category,
                timeElapsed: elapsedTime
            ) {
                currentInstruction = guidance
            }
        }
        
        // Check if session is complete
        if elapsedTime >= session.session.duration {
            completeSession()
        }
    }
    
    // MARK: - Display Instruction
    private func displayInstruction(_ instruction: MeditationInstruction) {
        currentInstruction = instruction.text
        
        if instruction.isInteractive, let interactionType = instruction.interactionType {
            currentInteractionType = interactionType
            showInteraction = true
            
            // Update breathing phase
            switch interactionType {
            case .breathIn:
                breathingPhase = .breathIn
            case .breathOut:
                breathingPhase = .breathOut
            case .hold:
                breathingPhase = .hold
            default:
                breathingPhase = .neutral
            }
        } else {
            showInteraction = false
            breathingPhase = .neutral
        }
    }
    
    // MARK: - Interaction Response
    func recordInteraction(successful: Bool) {
        currentSession?.interactionResponses.append(successful)
    }
    
    // MARK: - Session Control
    func pauseSession() {
        currentSession?.isPaused = true
        stopTimer()
    }
    
    func resumeSession() {
        currentSession?.isPaused = false
        startTimer()
    }
    
    func completeSession() {
        guard var session = currentSession else { return }
        
        session.endTime = Date()
        
        var completedSession = session.session
        completedSession.completedAt = Date()
        completedSession.focusScore = session.focusScore
        
        meditationHistory.append(completedSession)
        saveMeditationHistory()
        
        let message = feedbackService.getMeditationCompletionMessage(focusScore: session.focusScore)
        currentInstruction = message
        
        stopTimer()
        
        // Reset after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.isSessionActive = false
            self?.currentSession = nil
            self?.sessionProgress = 0.0
            self?.elapsedTime = 0
            self?.breathingPhase = .neutral
        }
    }
    
    func cancelSession() {
        stopTimer()
        isSessionActive = false
        currentSession = nil
        sessionProgress = 0.0
        elapsedTime = 0
        currentInstruction = ""
        breathingPhase = .neutral
    }
    
    // MARK: - Persistence
    private func saveMeditationHistory() {
        if let encoded = try? JSONEncoder().encode(meditationHistory) {
            UserDefaults.standard.set(encoded, forKey: AppConstants.StorageKeys.meditationHistory)
        }
    }
    
    func loadMeditationHistory() {
        if let data = UserDefaults.standard.data(forKey: AppConstants.StorageKeys.meditationHistory),
           let decoded = try? JSONDecoder().decode([MeditationSession].self, from: data) {
            meditationHistory = decoded
        }
    }
    
    // MARK: - Statistics
    func getTotalSessions() -> Int {
        return meditationHistory.count
    }
    
    func getTotalMinutes() -> Int {
        return meditationHistory.reduce(0) { $0 + ($1.duration / 60) }
    }
    
    func getAverageFocusScore() -> Double {
        let sessions = meditationHistory.filter { $0.focusScore != nil }
        guard !sessions.isEmpty else { return 0.0 }
        let total = sessions.reduce(0.0) { $0 + ($1.focusScore ?? 0.0) }
        return total / Double(sessions.count)
    }
    
    func getSessionsThisWeek() -> Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return meditationHistory.filter { session in
            guard let completedAt = session.completedAt else { return false }
            return completedAt > weekAgo
        }.count
    }
    
    deinit {
        stopTimer()
    }
}
