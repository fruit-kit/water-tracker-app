//
//  DailyGoalVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 16.03.26.
//

import UIKit

class DailyGoalVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var setGoalOutlet: UIButton!
    @IBOutlet weak var resetToDefaultOutlet: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillGoalVC()
    }
    
    // MARK: - Methods
    
    private func fillGoalVC() {
        setupGoalLabel()
        
        navigationItem.title = "Daily Goal"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setGoalOutlet.applyStyle(title: "Set goal", normalColor: .white, highlightedColor: .gray)
        self.resetToDefaultOutlet.applyStyle(title: "Reset to default", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    private func setupGoalLabel() {
        updateGoalLabel()
        self.goalLabel.font = .systemFont(ofSize: CGFloat(23), weight: .bold)
    }
    
    private func updateGoalLabel() {
        self.goalLabel.text = "Current goal is \(DrinkManager.shared.currentGoal) ml"
    }
    
    // MARK: - Actions
    
    @IBAction func setGoalAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Daily Goal", message: "Enter amount in ml", preferredStyle: .alert)
        
        let setAction = UIAlertAction(title: "Set", style: .default) { _ in
            let text = alertController.textFields?.first?.text ?? ""
            if let customeGoal = Int(text),
               customeGoal > 0 {
                UserDefaults.standard.set(customeGoal, forKey: UserDefaultsKeys.goal.rawValue)
                self.updateGoalLabel()
            } else {
                UserDefaults.standard.set(DrinkManager.shared.defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
                self.updateGoalLabel()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "ml"
        }
        
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction func resetToDefaultAction(_ sender: UIButton) {
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.set(DrinkManager.shared.defaultGoal, forKey: UserDefaultsKeys.goal.rawValue)
            self.updateGoalLabel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertConfirmation(title: "Reset to Default?", message: "Daily goal will be set to 2000 ml.", actions: [resetAction, cancelAction])
    }
    
}
