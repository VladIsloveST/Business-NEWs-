//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showNotification(_ title: String, message: String, actionTitle: String = "Cancel") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
