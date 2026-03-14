//
//  ViewController.swift
//  H2O
//
//  Created by Robert Kotrutsa on 01.03.26.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var drink100MlOutlet: UIButton!
    @IBOutlet weak var drink200MlOutlet: UIButton!
    @IBOutlet weak var drink300MlOutlet: UIButton!
    @IBOutlet weak var customeVolumeOutlet: UIButton!
    @IBOutlet weak var undoLastOutlet: UIButton!
    @IBOutlet weak var resetAllDayOutlet: UIButton!
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Methods
    
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
    
    private func presentAddDrink(volume: Int?) {
        let addDrinkVC = AddDrinkVC(nibName: "AddDrinkVC", bundle: Bundle.main)
        addDrinkVC.addDrinkDelegate = self
        
        if let sheet = addDrinkVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        addDrinkVC.presentVolume = volume
        present(addDrinkVC, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func drink100MlButton(_ sender: UIButton) {
        presentAddDrink(volume: 100)
    }
    
    @IBAction func drink200MlButton(_ sender: UIButton) {
        presentAddDrink(volume: 200)
    }
    
    @IBAction func drink300MlButton(_ sender: UIButton) {
        presentAddDrink(volume: 300)
    }
    
    @IBAction func customeVolumeButton(_ sender: UIButton) {
        presentAddDrink(volume: nil)
    }
    
    @IBAction func undoLastButton(_ sender: UIButton) {
        let undoAction = UIAlertAction(title: "Undo", style: .destructive) { _ in
            DrinkManager.shared.undoLast()
            self.updateProgressLabel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertConfirmation(title: "Undo last drink?",
                          message: "This action will remove the last entry and cannot be undone.",
                          actions: [undoAction, cancelAction])
    }
    
    @IBAction func resetAllDayButton(_ sender: UIButton) {
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            DrinkManager.shared.resetDay()
            self.updateProgressLabel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertConfirmation(title: "Reset all day?", message: "This action will remove all entries for today and cannot be undone.", actions: [resetAction, cancelAction])
    }
    
}

// MARK: - Extensions

extension HomeVC: AddDrinkDelegate {
    
    func didAddDrink() {
        updateProgressLabel()
    }
    
}

