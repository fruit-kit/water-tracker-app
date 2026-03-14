//
//  NotificationManager.swift
//  H2O
//
//  Created by Robert Kotrutsa on 14.03.26.
//
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private init() { }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isAllow, error in
            if isAllow {
                print("Allowed Notifications")
                self.sendNotification()
            } else {
                print("Didn't allow Nitifications")
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Water reminder"
        content.body = "It's time to drink some water."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "waterReminder",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}
