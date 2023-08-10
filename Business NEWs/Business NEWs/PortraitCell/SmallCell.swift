//
//  SmallCell.swift
//  Business NEWs
//
//  Created by Mac on 10.07.2023.
//

import Foundation
import UIKit

class SmallCell: BasicCollectionViewCell {
    static let identifier = "SmallCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraint()
        mainLabel.font = UIFont(name: "Hiragino Mincho ProN W3", size: 20)
        mainLabel.text = "Hiragino Mincho ProN W3 HiraginoHiragino Mincho ProN W3Hiragino Mincho Pro"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5),
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lableStackView.rightAnchor.constraint(equalTo: buttonStackView.leftAnchor, constant: 5)
        ])
    }
}
