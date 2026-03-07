//
//  ViewController.swift
//  H2O
//
//  Created by Robert Kotrutsa on 01.03.26.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var drink100MlOutlet: UIButton!
    @IBOutlet weak var drink200MlOutlet: UIButton!
    @IBOutlet weak var drink300MlOutlet: UIButton!
    @IBOutlet weak var customeVolumeOutlet: UIButton!
    @IBOutlet weak var undoLastOutlet: UIButton!
    @IBOutlet weak var resetAllDayOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupProgressLabel()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DrinkManager.shared.checkDate()
        updateProgressLabel()
    }
    
    private func setupNavigation() {
        navigationItem.title = "H2O"
        navigationController?.title = "H2O"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupProgressLabel() {
        self.progressLabel.font = .systemFont(ofSize: CGFloat(23), weight: .bold)
    }
    
    private func setupButtons() {
        self.drink100MlOutlet.applyStyle(title: "Drink 100ml", normalColor: .white, highlightedColor: .gray)
        self.drink200MlOutlet.applyStyle(title: "Drink 200ml", normalColor: .white, highlightedColor: .gray)
        self.drink300MlOutlet.applyStyle(title: "Drink 300ml", normalColor: .white, highlightedColor: .gray)
        self.customeVolumeOutlet.applyStyle(title: "Custome volume", normalColor: .white, highlightedColor: .gray)
        self.undoLastOutlet.applyStyle(title: "Undo last add", normalColor: .systemPink, highlightedColor: .gray)
        self.resetAllDayOutlet.applyStyle(title: "Reset all day", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    private func updateProgressLabel() {
        let percent = (Double(DrinkManager.shared.currentVolume) / Double(DrinkManager.shared.currentGoal)) * 100
        progressLabel.text = "Progress: \(DrinkManager.shared.currentVolume) / \(DrinkManager.shared.currentGoal)ml (\(Int(percent))%)"
    }
 
    @IBAction func drink100MlButton(_ sender: UIButton) {
        DrinkManager.shared.addDrink(100)
        updateProgressLabel()
    }
    
    @IBAction func drink200MlButton(_ sender: UIButton) {
        DrinkManager.shared.addDrink(200)
        updateProgressLabel()
    }
    
    @IBAction func drink300MlButton(_ sender: UIButton) {
        DrinkManager.shared.addDrink(300)
        updateProgressLabel()
    }
    
    @IBAction func customeVolumeButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter the volume", message: nil, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default) { _ in
            let customeVolume = alertController.textFields?.first?.text ?? ""
            if let customeVolume = Int(customeVolume),
               customeVolume > 0 {
                DrinkManager.shared.addDrink(customeVolume)
                self.updateProgressLabel()
            }
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "ml"
        }
        alertController.addAction(cancelButton)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true)
    }
    
    @IBAction func undoLastButton(_ sender: UIButton) {
        DrinkManager.shared.undoLast()
        updateProgressLabel()
    }
    
    @IBAction func resetAllDayButton(_ sender: UIButton) {
        DrinkManager.shared.resetDay()
        updateProgressLabel()
    }
    
}

