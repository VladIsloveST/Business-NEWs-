//
//  SearchCollectionReusableView.swift
//  Business NEWs
//
//  Created by Mac on 06.07.2023.
//

import UIKit

class SearchCollectionReusableView: UICollectionReusableView {
    static var identifier = "SearchCollectionReusableView"
    static var kind = "UICollectionElementKindSectionHeader"
    
    let bottomSeparator = UIView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupSeparator()
    }
    
    func setupSeparator() {
        addSubview(bottomSeparator)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.widthAnchor.constraint(equalToConstant: self.frame.width),
            bottomSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
        bottomSeparator.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
