//
//  UIButtonExtension.swift
//  Business NEWs
//
//  Created by Mac on 16.06.2023.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(normalStateImage: String, selectedStateImage: String) {
        self.init()
        let normalStateImage = UIImage(systemName: normalStateImage)?
            .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        let selectedStateImage = UIImage(systemName: selectedStateImage)?
            .withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        self.setImage(normalStateImage, for: .normal)
        self.setImage(selectedStateImage, for: .selected)
        
        self.isSelected = false
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
}
