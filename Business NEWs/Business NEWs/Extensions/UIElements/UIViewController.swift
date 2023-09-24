//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWith(message: String,
                       title: String = "Error",
                       actionTitle: String = "Cancel") {
        let attributedStringForMessage = NSAttributedString(string: message.localized, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
        let alert = UIAlertController(title: title.localized, message: "", preferredStyle: .alert)
        alert.setValue(attributedStringForMessage, forKey: "attributedMessage")
        let action = UIAlertAction(title: actionTitle.localized, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
