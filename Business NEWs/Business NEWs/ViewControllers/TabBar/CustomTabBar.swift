//
//  CustomTabBar.swift
//  Business NEWs
//
//  Created by Mac on 30.06.2023.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    // MARK: - Variables
    var didTapButton: (() -> ())?
    
    lazy var settingsButton: UIButton = {
        
        let button = CustomButtonBehavior()
        button.frame.size = CGSize(width: 65, height: 50)
        button.isSelected = false
        
        var filled = UIButton.Configuration.filled()
        filled.baseForegroundColor = .systemGray
        filled.baseBackgroundColor = .clear
        filled.attributedTitle = AttributedString("Settings", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
        filled.titleAlignment = .center
        filled.imagePlacement = .top
        filled.imagePadding = 5
    
        button.configuration = filled
        button.configurationUpdateHandler = { button in
            button.isHighlighted = false
        }
        
        button.addTarget(self, action: #selector(self.touchUpInsideAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.touchDownAction), for: .touchDown)
        self.addSubview(button)
        return button
    }()
    
    // MARK: - View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        settingsButton.center = CGPoint(x: thirdItemPosition , y: 27)
    }
    
    // MARK: - Actions
    @objc
    private func touchUpInsideAction(sender: UIButton) {
        settingsButton.isSelected = false
        didTapButton?()
    }
    
    @objc
    private func touchDownAction(sender: UIButton) {
        settingsButton.isSelected = true
    }
}

class CustomButtonBehavior: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configuration?.baseForegroundColor = .label
                guard let image = UIImage(systemName: "gearshape.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold, scale: .large)) else { return }
                setImage(image, for: .normal)
            } else {
                configuration?.baseForegroundColor = .systemGray
                guard let image = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .medium, scale: .large)) else { return }
                setImage(image, for: .normal)
            }
        }
    }
}
