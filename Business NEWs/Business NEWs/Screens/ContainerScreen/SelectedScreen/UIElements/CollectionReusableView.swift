//
//  CollectionReusableView.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = CollectionReusableView.description()
    static let kind = "UICollectionElementKindSectionHeader"
    
    // MARK: - Properties
    private var headerSeparator: UIView!
    private var cellTitleLable: UILabel = {
        $0.textColor = .black
        $0.font = UIFont(name: "Helvetica Neue Bold", size: 22)
        return $0
    }(UILabel())
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .myBackgroundColor
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
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
        
        headerSeparator = UIView()
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

