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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var headerSeparator = UIView()
    
    func setup(_ title: String) {
        cellTitleLable.text = title
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
        addSubview(cellTitleLable)
        addSubview(headerSeparator)
    }
    
    private func setConstrains() {
        
        NSLayoutConstraint.activate([
            cellTitleLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            cellTitleLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        headerSeparator.backgroundColor = .black
        headerSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerSeparator.heightAnchor.constraint(equalToConstant: 1),
            headerSeparator.widthAnchor.constraint(equalToConstant: self.frame.width - 30),
            headerSeparator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

