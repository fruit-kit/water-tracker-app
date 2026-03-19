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
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { isAllow, error in
            UserDefaults.standard.set(isAllow, forKey: UserDefaultsKeys.requestPermission.rawValue)
            completion(isAllow)
        }
    }
    
    func sendNotification(with timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Water reminder"
        content.body = "It's time to drink some water."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: true
        )
        
        let request = UNNotificationRequest(
            identifier: UserDefaultsKeys.waterReminder.rawValue,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [UserDefaultsKeys.waterReminder.rawValue])
    }
    
}
