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
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton = {
        
        let middleButton = CustomButtonBehavior()
        middleButton.frame.size = CGSize(width: 60, height: 50)
        middleButton.isSelected = false
    
        var filled = UIButton.Configuration.filled()
        filled.attributedTitle = AttributedString("Settings", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
        filled.titleAlignment = .center

        filled.baseForegroundColor = .systemGray
        filled.baseBackgroundColor = .clear
        
        filled.imagePlacement = .top
        filled.imagePadding = 5
                
        
        middleButton.configuration = filled
        middleButton.configurationUpdateHandler = { button in
            button.isHighlighted = false
        }

        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        middleButton.addTarget(self, action: #selector(self.buttonAction), for: .touchDown)
        self.addSubview(middleButton)
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: thirdItemPosition , y: 27)
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        middleButton.isSelected = false
        didTapButton?()
    }
    
    @objc func buttonAction(sender: UIButton) {
        middleButton.isSelected = true
    }
}

class CustomButtonBehavior: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                configuration?.baseForegroundColor = .systemBlue
                guard let image = UIImage(systemName: "gearshape.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19)) else { return }
                setImage(image, for: .normal)
            } else {
                configuration?.baseForegroundColor = .systemGray
                guard let image = UIImage(systemName: "gearshape", withConfiguration: UIImage.SymbolConfiguration(pointSize: 19)) else { return }
                setImage(image, for: .normal)
            }
        }
    }
}
