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
    
    var cellTitleLable: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Helvetica Neue Bold", size: 22)
        return label
    }()
    private var headerSeparator = UIView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .systemGray3
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ title: String) {
        cellTitleLable.text = title
    }
    
    private func setViews() {
        addSubview(cellTitleLable)
        cellTitleLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellTitleLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cellTitleLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(headerSeparator)
        headerSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerSeparator.heightAnchor.constraint(equalToConstant: 1),
            headerSeparator.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            headerSeparator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        headerSeparator.backgroundColor = .black
    }
}

