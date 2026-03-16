//
//  NotificationsVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 14.03.26.
//

import UIKit

class RemindersVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var reminderLabelOutlet: UILabel!
    @IBOutlet weak var reminderSwitcherOutlet: UISwitch!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reminders"
        reminderLabelOutlet.text = "Water reminders"
        
        if UserDefaults.standard.bool(forKey: "waterReminder"),
           UserDefaults.standard.bool(forKey: "requestPermission") {
            reminderSwitcherOutlet.isOn = true
        } else {
            reminderSwitcherOutlet.isOn = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func notificationSwitcherAction(_ sender: UISwitch) {
        if sender.isOn {
            NotificationManager.shared.requestPermission { isAllowed in
                guard isAllowed else {
                    DispatchQueue.main.async {
                        self.reminderSwitcherOutlet.isOn = false
                    }
                    UserDefaults.standard.set(false, forKey: "waterReminder")
                    return
                }
                UserDefaults.standard.set(true, forKey: "waterReminder")
                NotificationManager.shared.sendNotification()
            }
        } else {
            UserDefaults.standard.set(sender.isOn, forKey: "waterReminder")
            NotificationManager.shared.removeNotification()
        }
    }
    
}
