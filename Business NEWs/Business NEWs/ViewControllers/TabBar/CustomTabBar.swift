//
//  CustomTabBar.swift
//  Business NEWs
//
//  Created by Mac on 30.06.2023.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    // MARK: - Private Properties
    var didTapButton: (UndefinedAction)?
    private lazy var settingsButton: UIButton = {
        let button = CustomButtonBehavior()
        button.frame.size = CGSize(width: 90, height: 50)
        button.isSelected = false
        button.tintAdjustmentMode = .normal
        
        var filled = UIButton.Configuration.filled()
        filled.baseForegroundColor = .systemGray
        filled.baseBackgroundColor = .clear
        filled.attributedTitle = AttributedString("Settings".localized, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
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
    
    // MARK: - Private Methods
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
