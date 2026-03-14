//
//  SettingsVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 14.03.26.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var notificationSwitcher: UISwitch!
    @IBOutlet weak var notificationOutlet: UILabel!
    @IBOutlet weak var notificationBorder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNotificationSetting()
    }

    private func setupNavigation() {
        navigationItem.title = "Settings"
        navigationController?.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNotificationSetting() {
        notificationOutlet.text = "Notifications"
        notificationBorder.layer.borderWidth = 1.5
        notificationBorder.layer.borderColor = UIColor.white.cgColor
        notificationBorder.layer.cornerRadius = 20
    }
    
    @IBAction func notificationSwitchAction(_ sender: UISwitch) {
        
    }
    
}
