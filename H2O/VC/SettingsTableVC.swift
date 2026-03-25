//
//  SettingsTableVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 16.03.26.
//

import UIKit

class SettingsTableVC: UITableViewController {
    
    // MARK: - Outlets
    
    let settings: [SettingModal] = [
        SettingModal(settingImage: UIImage(systemName: "bell.fill"), settingName: "Reminders"),
        SettingModal(settingImage: UIImage(systemName: "star.fill"), settingName: "Daily Goal"),
        SettingModal(settingImage: UIImage(systemName: "book.fill"), settingName: "About")
    ]

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        let settingsTableViewCell = UINib(nibName: "SettingsTableViewCell", bundle: Bundle.main)
        tableView.register(settingsTableViewCell, forCellReuseIdentifier: "settingsTableViewCell")
    }
    
    // MARK: - Methods
    
    private func setupNavigation() {
            navigationItem.title = "Settings"
            navigationController?.title = "Settings"
            navigationController?.navigationBar.prefersLargeTitles = true
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.settingImage.image = settings[indexPath.row].settingImage
        cell.settingName.text = settings[indexPath.row].settingName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let notificationsVC = RemindersVC(nibName: "RemindersVC", bundle: Bundle.main)
            navigationController?.pushViewController(notificationsVC, animated: true)
        case 1:
            let goalVC = DailyGoalVC(nibName: "DailyGoalVC", bundle: Bundle.main)
            navigationController?.pushViewController(goalVC, animated: true)
        case 2:
            let aboutVC = AboutVC(nibName: "AboutVC", bundle: Bundle.main)
            navigationController?.pushViewController(aboutVC, animated: true)
        default:
            break
        }
        
    }

}
