//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ title: String, message: String, actionTitle: String = "Cancel") {
        let attributedStringForMessage = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.setValue(attributedStringForMessage, forKey: "attributedMessage")
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
