//
//  PortraitCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 13.02.2023.
//

import UIKit

class PortraitCell: BasicCollectionViewCell {
    static let identifier = "PortraitCollectionViewCell"
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(imageView)
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lableStackView.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor, constant: -5)
        ])
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -7),
            mainLabel.heightAnchor.constraint(lessThanOrEqualToConstant: self.frame.height/3),
            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120)
        ])
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
