//
//  MenuCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = CategoryCollectionViewCell.description()

    // MARK: - Private Properties
    private var nameCategoryLabel: UILabel = {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont(name: "Helvetica Neue Medium", size: 18)
        $0.alpha = 0.95
        return $0
    }(UILabel())
    
    override var isSelected: Bool {
        didSet {
            nameCategoryLabel.alpha = self.isSelected ? 1 : 0.95
            nameCategoryLabel.font = self.isSelected ?
            UIFont(name: "Helvetica Neue Bold", size: 18) :
            UIFont(name: "Helvetica Neue Medium", size: 18)
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super .init(frame: frame)
        addCategoryLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(categoryLabel text: String) {
        nameCategoryLabel.text = text
    }
    
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

