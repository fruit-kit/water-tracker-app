//
//  AddDrinkVC.swift
//  H2O
//
//  Created by Robert Kotrutsa on 08.03.26.
//

import UIKit

class AddDrinkVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var addDrinkEntryOutlet: UIButton!
    @IBOutlet weak var cancelDrinkEntryOutlet: UIButton!
    
    weak var delegate: AddDrinkDelegate?
    var presentVolume: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupTextField()
        self.addDrinkEntryOutlet.applyStyle(title: "Add", normalColor: .white, highlightedColor: .gray)
        self.cancelDrinkEntryOutlet.applyStyle(title: "Cancel", normalColor: .systemPink, highlightedColor: .gray)
    }
    
    private func setupTitle() {
        self.titleLabel.text = "Add drink entry"
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
    
    @IBAction func addDrinkEntryAction(_ sender: UIButton) {
        guard let text = self.textFieldOutlet.text,
              let ml = Int(text),
        ml > 0 else {
            self.dismiss(animated: true)
            return
        }
        DrinkManager.shared.addDrink(ml)
        delegate?.didAddDrink()
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelDrinkEntryAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

protocol AddDrinkDelegate: AnyObject {
    func didAddDrink()
}
