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
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horizontalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .red : .darkGray
            nameCategoryLabel.textColor = self.isSelected ? .gray : .white
            horizontalBarView.backgroundColor = self.isSelected ? .black : .none
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
        horizontalBarView.backgroundColor = .none
        backgroundColor = .darkGray
        addSubview(nameCategoryLabel)
        addSubview(horizontalBarView)
    }
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            nameCategoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameCategoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor),
            horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor),
            horizontalBarView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
