//
//  PortraitCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 13.02.2023.
//

import UIKit

class PortraitCell: BasicCollectionViewCell {
    static let identifier = "PortraitCollectionViewCell"
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        imageView.backgroundColor = .lightGray
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor

        buttonStackView.addArrangedSubview(buttonShare)
        buttonStackView.addArrangedSubview(buttonSaving)
        lableStackView.addArrangedSubview(infoLable)
        lableStackView.addArrangedSubview(timeOfPublicationLable)
       
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            lableStackView.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor),
            lableStackView.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor)
        ])
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -7),
            mainLabel.heightAnchor.constraint(lessThanOrEqualToConstant: self.frame.height/3),            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 20),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
    
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -55)
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
    }
}
