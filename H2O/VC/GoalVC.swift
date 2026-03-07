//
//  GoalVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 01.03.26.
//

import UIKit

class GoalVC: UIViewController {
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var setGoalOutlet: UIButton!
    @IBOutlet weak var resetToDefaultOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillGoalVC()
    }
    
    private func fillGoalVC() {
        self.goalLabel.text = "Current goal is \(DrinkManager.shared.currentGoal)ml"
        self.goalLabel.font = .systemFont(ofSize: CGFloat(23), weight: .bold)
        
        navigationItem.title = "Goal"
        navigationController?.title = "Goal"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setGoalOutlet.applyStyle(title: "Set goal", normalColor: .white, highlightedColor: .gray)
        self.resetToDefaultOutlet.applyStyle(title: "Reset to default", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    @IBAction func setGoalButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Set goal", message: nil, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default) { _ in
            let customeGoal = alertController.textFields?.first?.text ?? ""
            if let customeGoal = Int(customeGoal),
               customeGoal > 0 {
                UserDefaults.standard.set(customeGoal, forKey: UserDefaultsKeys.goal.rawValue)
                self.goalLabel.text = "Current goal is \(DrinkManager.shared.currentGoal)ml"
            } else {
                UserDefaults.standard.set(DrinkManager.shared.defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
                self.goalLabel.text = "Current goal is \(DrinkManager.shared.currentGoal)ml"
            }
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "ml"
        }
        alertController.addAction(actionButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    @IBAction func resetToDefaultButton(_ sender: UIButton) {
        UserDefaults.standard.set(DrinkManager.shared.defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
        self.goalLabel.text = "Current goal is \(UserDefaults.standard.integer(forKey: UserDefaultsKeys.goal.rawValue))ml"
    }
    
}
