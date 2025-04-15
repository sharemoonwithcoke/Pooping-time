//
//  Pooping_timeApp.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import SwiftUI
import UserNotifications

@main
struct HealthTrackerApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var dataManager = DataManager.shared
    
    init() {
       
        DispatchQueue.main.async {
            NotificationManager.shared.requestAuthorization()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if userViewModel.isFirstLaunch {
                OnboardingView()
                    .environmentObject(userViewModel)
            } else {
                ContentView()
                    .environmentObject(userViewModel)
                    .environmentObject(dataManager)
            }
        }
    }
}
