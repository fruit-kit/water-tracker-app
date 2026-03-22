//
//  AddDrinkVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 08.03.26.
//

import UIKit

class AddDrinkVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addDrinkEntryOutlet: UIButton!
    @IBOutlet weak var cancelDrinkEntryOutlet: UIButton!
    
    // MARK: - Properties
    
    weak var addDrinkDelegate: AddDrinkDelegate?
    weak var delegateHistoryVC: EditDrinkDelegate?
    var presentVolume: Int?
    var selectedDrink: DrinkType = .water
    var mode: AddDrinkMode = .add
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupPicker()
        switch mode {
        case .add:
            setup(title: "Add drink")
            self.addDrinkEntryOutlet.applyStyle(title: "Add", normalColor: .white, highlightedColor: .gray)
        case .edit(_):
            setup(title: "Edit drink")
            self.addDrinkEntryOutlet.applyStyle(title: "Save", normalColor: .white, highlightedColor: .gray)
        }
        self.cancelDrinkEntryOutlet.applyStyle(title: "Cancel", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    // MARK: - Methods
    
    private func setup(title: String) {
        self.titleLabel.text = title
        self.titleLabel.font = .systemFont(ofSize: CGFloat(34), weight: .bold)
    }
    
    private func setupTextField() {
        textFieldOutlet.placeholder = "ml"
        if let presentVolume {
            textFieldOutlet.text = "\(presentVolume)"
        }
        textFieldOutlet.keyboardType = .numberPad
        textFieldOutlet.layer.cornerRadius = 20
        textFieldOutlet.clipsToBounds = true
        textFieldOutlet.layer.borderWidth = 1
        textFieldOutlet.layer.borderColor = UIColor.gray.cgColor
    }
    
    private func setupPicker() {
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        if let index = DrinkType.allCases.firstIndex(of: selectedDrink) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addDrinkEntryAction(_ sender: UIButton) {
        guard let text = textFieldOutlet.text,
              let ml = Int(text),
              ml > 0 else {
            dismiss(animated: true)
            return
        }
        switch mode {
        case .add:
            DrinkManager.shared.addDrink(amount: ml, drink: selectedDrink)
            addDrinkDelegate?.didAddDrink()
            
            NotificationManager.shared.removeNotification()
            if DrinkManager.shared.currentVolume < DrinkManager.shared.currentGoal && UserDefaults.standard.bool(forKey: UserDefaultsKeys.waterReminder.rawValue),
               let timeInterval = UserDefaults.standard.object(forKey: UserDefaultsKeys.intervalReminder.rawValue) as? TimeInterval {
                NotificationManager.shared.sendNotification(with: timeInterval)
            }
            
            dismiss(animated: true)
        case .edit(let index):
            DrinkManager.shared.updateDrinkEntry(at: index, volume: ml, drink: selectedDrink)
            delegateHistoryVC?.didEditDrink()
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancelDrinkEntryAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

// MARK: - Protocols

protocol AddDrinkDelegate: AnyObject {
    func didAddDrink()
}

protocol EditDrinkDelegate: AnyObject {
    func didEditDrink()
}

// MARK: - Extensions

extension AddDrinkVC: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        DrinkType.allCases.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
}

extension AddDrinkVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let drinks = DrinkType.allCases
        let text = drinks[row].rawValue
        return text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDrink = DrinkType.allCases[row]
    }
    
}
