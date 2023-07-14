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
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .center
        stackView.spacing = 23
        stackView.addArrangedSubview(buttonShare)
        stackView.addArrangedSubview(buttonSaving)
        return stackView
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        label.textColor = .white
        label.text = "Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium."
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .left
        //label.backgroundColor = .l
        return label
    }()
    
    var infoLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "Artiane de Vogue"
        return label
    }()
    
    var timeOfPublicationLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "1h ago"
        return label
    }()
    
    lazy var lableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .leading
        stackView.spacing = -3
        stackView.addArrangedSubview(infoLable)
        stackView.addArrangedSubview(timeOfPublicationLable)
        return stackView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
