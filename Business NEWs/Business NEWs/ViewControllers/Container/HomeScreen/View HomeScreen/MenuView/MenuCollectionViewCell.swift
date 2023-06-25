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
        label.font = UIFont(name: "Helvetica Neue Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var separatorLine = UIView()
    
    override var isSelected: Bool {
        didSet {
            nameCategoryLabel.font = self.isSelected ?
            UIFont(name: "Helvetica Neue Bold", size: 18) :
            UIFont(name: "Helvetica Neue Medium", size: 18)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
        setConstrains()
        addSeparatorLineView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSeparatorLineView(){
        separatorLine.backgroundColor = .darkGray
        
        addSubview(separatorLine)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.widthAnchor.constraint(equalTo: widthAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
        ])
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(nameCategoryLabel)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            nameCategoryLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            nameCategoryLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            nameCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
