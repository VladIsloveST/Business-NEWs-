//
//  BasicCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.07.2023.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
    let buttonSaving: UIButton = {
        let button = UIButton(normalStateImage: "bookmark",
                           selectedStateImage: "bookmark.fill")
        button.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        return button
    }()
    
    let buttonShare: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "bookmark.fill")
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .center
        stackView.spacing = 23
        return stackView
    }()
    
    var imageView = UIImageView()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 21)
        label.textColor = .white
        label.text = "Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium."
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .darkGray
        return label
    }()
    
    let lableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .leading
        stackView.spacing = -3
        return stackView
    }()
    
    var timeOfPublicationLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "1h ago"
        return label
    }()
    
    var infoLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "Artiane de Vogue"
        return label
    }()
    
    @objc
    private func tappedSelect() {
        switch buttonSaving.isSelected {
        case true:
            print("Not Selected")
            return buttonSaving.isSelected = false
        case false:
            print("Selected")
            return buttonSaving.isSelected = true
        }
    }
}
