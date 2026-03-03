//
//  ViewController.swift
//  H2O
//
//  Created by Robert Kotrutsa on 01.03.26.
//

import UIKit

class HomeVC: UIViewController {
    
    private var currentVolume: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentVolume.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentVolume.rawValue)
        }
    }
    private var goal: Int {
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.goal.rawValue)
    }
    private var lastAdd: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastAdd.rawValue)
        }
    }

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
        updateProgressLabel()
    }
    
    private func setupNavigation() {
        navigationItem.title = "H2O"
        navigationController?.title = "H2O"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupProgressLabel() {
        updateProgressLabel()
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
    
    private func addWater(_ amount: Int) {
        lastAdd = amount
        currentVolume += lastAdd
        updateProgressLabel()
    }
    
    private func updateProgressLabel() {
        let percent = (Double(currentVolume) / Double(goal)) * 100
        progressLabel.text = "Progress: \(currentVolume) / \(goal)ml (\(Int(percent))%)"
    }
 
    @IBAction func drink100MlButton(_ sender: UIButton) {
        addWater(100)
    }
    
    @IBAction func drink200MlButton(_ sender: UIButton) {
        addWater(200)
    }
    
    @IBAction func drink300MlButton(_ sender: UIButton) {
        addWater(300)
    }
    
    @IBAction func customeVolumeButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter the volume", message: nil, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default) { _ in
            let customeVolume = alertController.textFields?.first?.text ?? ""
            if let customeVolume = Int(customeVolume),
               customeVolume > 0 {
                self.lastAdd = customeVolume
                self.currentVolume += self.lastAdd
                self.updateProgressLabel()
            }
        }
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "milliliters"
        }
        alertController.addAction(cancelButton)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true)
    }
    
    @IBAction func undoLastButton(_ sender: UIButton) {
        guard currentVolume >= lastAdd else {
            currentVolume = 0
            updateProgressLabel()
            return
        }
        currentVolume -= lastAdd
        updateProgressLabel()
        lastAdd = 0
    }
    
    @IBAction func resetAllDayButton(_ sender: UIButton) {
        currentVolume = 0
        updateProgressLabel()
    }
    
}

