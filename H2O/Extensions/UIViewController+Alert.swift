//
//  UIViewController+Alert.swift
//  H2O
//
//  Created by Robert Kotrutsa on 09.03.26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertController.Style = .alert, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
