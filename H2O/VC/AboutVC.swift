//
//  AboutVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 25.03.26.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var h2oLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var developerImage: UIImageView!
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var githubImage: UIImageView!
    @IBOutlet weak var githubLabel: UILabel!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"
        setupImageLogo()
        setuph2oLabel()
        setupVersionLabel()
        setupLine()
        setupDescriptionLabel()
        setupDeveloperButton()
        setupGitHubButton()
        setupEmailButton()
    }
    
    private func setupImageLogo() {
        image.image = UIImage(named: "logo")
        image.layer.borderWidth = 2
    }
    
    private func setuph2oLabel() {
        h2oLabel.text = "H2O Water Tracker"
        h2oLabel.font = .systemFont(ofSize: CGFloat(23), weight: .bold)
    }
    
    private func setupVersionLabel() {
        versionLabel.text = "Version 1.0"
        versionLabel.font = .systemFont(ofSize: CGFloat(21))
        versionLabel.textColor = .gray
    }
    
    private func setupLine() {
        line.backgroundColor = .separator
        line.alpha = 1
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "Track your daily water intake and stay hydrated."
        descriptionLabel.textColor = .gray
    }
    
    private func setupDeveloperButton() {
        developerImage.image = UIImage(systemName: "person.fill")
        developerLabel.text = "Developer"
    }
    
    private func setupGitHubButton() {
        githubImage.image = UIImage(systemName: "eye.fill")
        githubLabel.text = "Source Code"
    }
    
    private func setupEmailButton() {
        emailImage.image = UIImage(systemName: "envelope.fill")
        emailLabel.text = "Contact Us"
    }
    
    @IBAction func developerAction(_ sender: UIButton) {
        let username = "fruitkit"
        if let appURL = URL(string: "tg://resolve?domain=\(username)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://t.me/\(username)") {
            UIApplication.shared.open(webURL)
        }
    }
    
    @IBAction func githubAction(_ sender: UIButton) {
        let appName = "water-tracker-app"
        if let appURL = URL(string: "github://github.com/fruit-kit/\(appName)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://github.com/fruit-kit/water-tracker-app"),
                  UIApplication.shared.canOpenURL(webURL) {
            UIApplication.shared.open(webURL)
        }
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        let email = "robert.kotrutsa@proton.me"
        if let url = URL(string: "mailto: \(email)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default)
            showAlert(title: "Error", message: "Mail app has not found.", actions: [okAction])
        }
    }

}
