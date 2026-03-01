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
    private var lastAdd = 0

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
        self.progressLabel.textColor = .bluePrimary
    }
    
    // MARK: Setup buttons
    private func setupButtons() {
        setup(button: self.drink100MlOutlet, title: "Drink 100ml", color: .bluePrimary)
        setup(button: self.drink200MlOutlet, title: "Drink 200ml", color: .bluePrimary)
        setup(button: self.drink300MlOutlet, title: "Drink 300ml", color: .bluePrimary)
        setup(button: self.customeVolumeOutlet, title: "Custome volume", color: .bluePrimary)
        setup(button: self.undoLastOutlet, title: "Undo last add", color: .redPrimary)
        setup(button: self.resetAllDayOutlet, title: "Reset all day", color: .redPrimary)
    }
    
    // MARK: Update progress label
    private func updateProgressLabel() {
        let percent = (Double(currentVolume) / Double(goalVolume)) * 100
        progressLabel.text = "Progress: \(currentVolume) / \(goalVolume)ml (\(Int(percent))%)"
    }
    
    private func setup(button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = color.cgColor
    }
 
    @IBAction func drink100MlButton(_ sender: UIButton) {
        lastAdd = 100
        currentVolume += lastAdd
        updateProgressLabel()
    }
    
    @IBAction func drink200MlButton(_ sender: UIButton) {
        lastAdd = 200
        currentVolume += lastAdd
        updateProgressLabel()
    }
    
    @IBAction func drink300MlButton(_ sender: UIButton) {
        lastAdd = 300
        currentVolume += lastAdd
        updateProgressLabel()
    }
    
    @IBAction func customeVolumeButton(_ sender: UIButton) {
        print(#function)
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

