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
        mainLabel.font = .systemFont(ofSize: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -300)
        ])
        imageView.backgroundColor = .blue
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7),
            mainLabel.bottomAnchor.constraint(equalTo: lableStackView.topAnchor, constant: -10),
            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        buttonSaving.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonSaving.widthAnchor.constraint(equalToConstant: 30),
            buttonSaving.heightAnchor.constraint(equalToConstant: 30)
        ])

        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonShare.widthAnchor.constraint(equalToConstant: 30),
            buttonShare.heightAnchor.constraint(equalToConstant: 30)
        ])

        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])

        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            lableStackView.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),
            lableStackView.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor)
        ])
    }
}
