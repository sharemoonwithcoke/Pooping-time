//
//  NotificationManager.swift
//  Pooping-time
//
//  Created by yueming on 2/6/25.
//


import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification Permission Acquired")
                    self.registerNotificationCategories()
                } else if let error = error {
                    print("Notify permission request failure: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func registerNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([])
    }
    
    // Record Alert
    func scheduleTimeoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Record Alert"
        content.body = "You've been on 🚽 for more than 5 mins, watch out!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to add notification: \(error.localizedDescription)")
            }
        }
    }
    
    // health alert
    func scheduleHealthReminder(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "healthReminder-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
