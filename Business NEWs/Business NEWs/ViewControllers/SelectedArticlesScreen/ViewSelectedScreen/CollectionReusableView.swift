//
//  CollectionReusableView.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    static var identifier = "CollectionReusableView"
    static var kind = "UICollectionElementKindSectionHeader"
    
    var cellTitleLble = UILabel()
    
    func setup(_ title: String) {
        cellTitleLble.text = title
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        cellTitleLble.font = UIFont(name: "Helvetica Neue Medium", size: 25)
        setupViews()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(cellTitleLble)
    }
    
    private func setConstrains() {
        
        cellTitleLble.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellTitleLble.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            cellTitleLble.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

