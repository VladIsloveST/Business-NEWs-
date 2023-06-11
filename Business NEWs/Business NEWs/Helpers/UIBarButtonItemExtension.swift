//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 10.06.2023.
//

import UIKit

extension UIBarButtonItem {
    convenience public init(imageSystemName: String, target: Any?, action: Selector?) {
        let image = UIImage(systemName: imageSystemName)?.withRenderingMode(.alwaysOriginal)
        self.init(image: image, style: .plain, target: target, action: action)
    }
}

