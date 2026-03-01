//
//  ViewController.swift
//  H2O
//
//  Created by Robert Kotrutsa on 01.03.26.
//

import UIKit

class HomeVC: UIViewController {
    
    private var currentVolume = 0
    private var goalVolume = 2000

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
    
    // MARK: Setup navigation
    private func setupNavigation() {
        navigationItem.title = "H2O"
        navigationController?.title = "H2O"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Setup progress label
    private func setupProgressLabel() {
        updateProgressLabel()
        self.progressLabel.font = .systemFont(ofSize: CGFloat(23), weight: .bold)
        self.progressLabel.textColor = .appPrimary
    }
    
    // MARK: Setup buttons
    private func setupButtons() {
        setup(button: self.drink100MlOutlet, title: "Drink 100ml", state: .normal, color: .appPrimary, borderWidth: 1)
        setup(button: self.drink200MlOutlet, title: "Drink 200ml", state: .normal, color: .appPrimary, borderWidth: 1)
        setup(button: self.drink300MlOutlet, title: "Drink 300ml", state: .normal, color: .appPrimary, borderWidth: 1)
        setup(button: self.customeVolumeOutlet, title: "Custome volume", state: .normal, color: .appPrimary, borderWidth: 1)
        setup(button: self.undoLastOutlet, title: "Undo last add", state: .normal, color: .appPrimary, borderWidth: 1)
        setup(button: self.resetAllDayOutlet, title: "Reset all day", state: .normal, color: .appPrimary, borderWidth: 1)
    }
    
    // MARK: Update progress label
    private func updateProgressLabel() {
        let percent = (Double(currentVolume) / Double(goalVolume)) * 100
        progressLabel.text = "Progress: \(currentVolume) / \(goalVolume)ml (\(Int(percent))%)"
    }
    
    private func setup(button: UIButton, title: String, state: UIControl.State, color: UIColor, borderWidth: CGFloat) {
        button.setTitle(title, for: state)
        button.setTitleColor(color, for: state)
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = UIColor.appPrimary.cgColor
    }
 
    @IBAction func drink100MlButton(_ sender: UIButton) {
        currentVolume += 100
        updateProgressLabel()
    }
    
    @IBAction func drink200MlButton(_ sender: UIButton) {
        currentVolume += 200
        updateProgressLabel()
    }
    
    @IBAction func drink300MlButton(_ sender: UIButton) {
        currentVolume += 300
        updateProgressLabel()
    }
    
    @IBAction func customeVolumeButton(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func undoLastButton(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func resetAllDayButton(_ sender: UIButton) {
        currentVolume = 0
        updateProgressLabel()
    }
    
}

