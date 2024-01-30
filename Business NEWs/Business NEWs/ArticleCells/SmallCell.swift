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
        setLableFont()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            generalStackView.heightAnchor.constraint(lessThanOrEqualToConstant: frame.height),
            generalStackView.widthAnchor.constraint(equalToConstant: frame.width - 40),
            generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            generalStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
//generalStackView.topAnchor.constraint(equalTo: bottomAnchor, constant: 14),
//generalStackView.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
//generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//generalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
