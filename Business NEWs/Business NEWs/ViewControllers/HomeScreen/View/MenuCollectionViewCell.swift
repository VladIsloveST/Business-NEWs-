//
//  MenuCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Devanagari Sangam MN Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override var isSelected: Bool {
        didSet {
            nameCategoryLabel.font = self.isSelected ?
            UIFont(name: "Arial Bold", size: 18) : UIFont(name: "Devanagari Sangam MN Bold", size: 18)
            
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setupViews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(nameCategoryLabel)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            nameCategoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
