//
//  LargePortraitCell.swift
//  Business NEWs
//
//  Created by Mac on 10.07.2023.
//

import Foundation
import UIKit

class LargePortraitCell: BasicCollectionViewCell {
    static let identifier = "LargePortraitCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonStackView.addArrangedSubview(buttonShare)
        buttonStackView.addArrangedSubview(buttonSaving)
        lableStackView.addArrangedSubview(infoLable)
        lableStackView.addArrangedSubview(timeOfPublicationLable)
        
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        
        setConstraint()
        mainLabel.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        //"Baskerville"
        
        mainLabel.setLineSpacing(lineSpacing: 3)
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        imageView.backgroundColor = .white
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])

        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lableStackView.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor)
        ])
    }
}
