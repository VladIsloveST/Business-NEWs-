//
//  MenuCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class MenuCollectionView: UICollectionView {
    
    private let nameCategoryArray = ["like", "and", "subscribe", "chanel"]
    
    private let categoryFlowLayout = UICollectionViewFlowLayout()
    
    private var horizontalBarView: UIView = {
        let horizontalView = UIView()
        horizontalView.backgroundColor = .black
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalView
    }()
    
    private var leftAnchorConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryFlowLayout)
        
        configure()
        setupHorizontalBar()
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        horizontalBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHorizontalBar() {
        
        addSubview(horizontalBarView)
        
        leftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        NSLayoutConstraint.activate([
            leftAnchorConstraint,
            horizontalBarView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:  1/4),
            horizontalBarView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func configure() {
        
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        selectItem(at: [0,0], animated: true, scrollPosition: [])
    }
}

// MARK: - Collection View Delegate

extension MenuCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        let x = CGFloat(indexPath.item) * frame.width/4
        leftAnchorConstraint.constant = x
    }
}

// MARK: - Collection View Data Source

extension MenuCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
        cell.nameCategoryLabel.text = nameCategoryArray[indexPath.item]
        return cell
    }
}

// MARK: - Collection View Delegate Flow Layout

extension MenuCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let categoryFont = UIFont(name: "Arial Bold", size: 18)
//        let categoryAttributes = [NSAttributedString.Key.font : categoryFont]
//        let categoryWidth = nameCategoryArray[indexPath.item].size(withAttributes: categoryAttributes as [NSAttributedString.Key : Any]).width + 20
        
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
