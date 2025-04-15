//
//  RecordViewModel.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//

import Foundation
import Combine

class RecordViewModel: ObservableObject {
    @Published var isTracking = false
    @Published var showingForm = false
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    
    var timeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func toggleTracking() {
        isTracking.toggle()
        if isTracking {
            startTimer()
            NotificationManager.shared.scheduleTimeoutNotification()
        } else {
            let finalTime = elapsedTime
            stopTimer()
            NotificationManager.shared.cancelAllNotifications()
            showingForm = true
            elapsedTime = finalTime  
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
        NotificationManager.shared.cancelAllNotifications()
    }
}
