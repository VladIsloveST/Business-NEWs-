//
//  MenuCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Helvetica Neue Medium", size: 18)
        label.alpha = 0.95
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            nameCategoryLabel.font = self.isSelected ?
            UIFont(name: "Helvetica Neue Bold", size: 18) :
            UIFont(name: "Helvetica Neue Medium", size: 18)
            nameCategoryLabel.alpha = self.isSelected ? 1 : 0.95
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addCategoryLabel() {
        addSubview(nameCategoryLabel)
        nameCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameCategoryLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameCategoryLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            nameCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        backgroundColor = .white
    }
}
