//
//  AVitaHarmonyApp.swift
//  AVitaHarmony
//
//  Created by Simon Bakhanets on 24.01.2026.
//

import SwiftUI

@main
struct AVitaHarmonyApp: App {
    @AppStorage(AppConstants.StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}
