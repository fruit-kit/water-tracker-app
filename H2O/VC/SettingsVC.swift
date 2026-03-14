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
        notificationBorder.layer.borderWidth = 1
        notificationBorder.layer.borderColor = UIColor.white.cgColor
        notificationBorder.layer.cornerRadius = 25
    }
    
    @IBAction func notificationSwitchAction(_ sender: UISwitch) {
        
    }
    
}
