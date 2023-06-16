//
//  PortraitCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 13.02.2023.
//

import UIKit

class PortraitCollectionViewCell: UICollectionViewCell {
    static let identifier = "PortraitCollectionViewCell"
    
    let buttonFirst: UIButton = {
        let but = UIButton(normalStateImage: "bookmark",
                           selectedStateImage: "bookmark.fill")
        but.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        
        return but
    }()
    
    let buttonSecond: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "bookmark.fill")
        return button
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.alignment = .center
        sv.spacing = 20
        return sv
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor

        stackView.addArrangedSubview(buttonSecond)
        stackView.addArrangedSubview(buttonFirst)
        self.addSubview(stackView)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        
        buttonFirst.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonFirst.widthAnchor.constraint(equalToConstant: 30),
            buttonFirst.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        buttonSecond.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonSecond.widthAnchor.constraint(equalToConstant: 30),
            buttonSecond.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func tappedSelect() {
        switch buttonFirst.isSelected {
        case true:
            print("Not Selected")
            return buttonFirst.isSelected = false
        case false:
            print("Selected")
            return buttonFirst.isSelected = true
        }
    }
}
