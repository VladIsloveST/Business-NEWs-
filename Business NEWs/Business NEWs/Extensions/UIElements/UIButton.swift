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
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .large)
        let normalStateImage = UIImage(systemName: normalStateImage, withConfiguration: configuration)
        normalStateImage?.withRenderingMode(.alwaysTemplate)
        let selectedStateImage = UIImage(systemName: selectedStateImage, withConfiguration: configuration)
        selectedStateImage?.withRenderingMode(.alwaysTemplate)
        self.setImage(normalStateImage, for: .normal)
        self.setImage(selectedStateImage, for: .selected)
        self.isSelected = false
    }
}
