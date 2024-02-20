//
//  CustomButtonBehavior.swift
//  Business NEWs
//
//  Created by Mac on 19.02.2024.
//

import Foundation
import UIKit

private enum ImageName: String {
    case clean = "gearshape"
    case fill = "gearshape.fill"
}

class CustomButtonBehavior: UIButton {
    
    // MARK: - Property
    override var isSelected: Bool {
        didSet {
            isSelected ? changeImage() : changeImage(with: .systemGray, weight: .medium, name: .clean)
        }
    }
    
    // MARK: - Private Method
    private func changeImage(with color: UIColor = .label,
                             weight: UIImage.SymbolWeight = .semibold,
                             name: ImageName = .fill) {
        configuration?.baseForegroundColor = color
        let configuration = UIImage.SymbolConfiguration(pointSize: 19, weight: weight, scale: .large)
        guard let image = UIImage(systemName: name.rawValue,
                                  withConfiguration: configuration) else { return }
        setImage(image, for: .normal)
    }
}
