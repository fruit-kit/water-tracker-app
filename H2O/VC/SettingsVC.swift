//
//  SettingsVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 14.03.26.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var notificationButtonOutlet: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        notificationButtonOutlet.applyStyle(
            title: "Notifications",
            normalColor: .white,
            highlightedColor: .gray
        )
    }

    // MARK: - Methods
    
    private func setupNavigation() {
        navigationItem.title = "Settings"
        navigationController?.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Actions
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        let notificationsVC = NotificationsVC(nibName: "NotificationsVC", bundle: Bundle.main)
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
}
