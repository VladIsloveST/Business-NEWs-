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
    
    // MARK: - Private Properties
    private var bottomSeparator: UIView!
    private var contentInsetViewTop: UIView!
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        setupSeparators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupSeparators() {
        bottomSeparator = UIView()
        addSubview(bottomSeparator)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparator.widthAnchor.constraint(equalToConstant: self.frame.width),
            bottomSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        bottomSeparator.backgroundColor = .black
        
        contentInsetViewTop = UIView()
        addSubview(contentInsetViewTop)
        contentInsetViewTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentInsetViewTop.heightAnchor.constraint(equalToConstant: 20),
            contentInsetViewTop.widthAnchor.constraint(equalToConstant: self.frame.width),
            contentInsetViewTop.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        contentInsetViewTop.backgroundColor = .myBackgroundColor
    }
    
    func add(_ element: UISearchBar) {
        addSubview(element)
        element.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            element.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            element.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            element.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
        ])
    }
}
