//
//  MenuCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class MenuCollectionView: UICollectionView {
    
    private let nameCategoryArray = ["Wall St.", "TechCrunch", "Apple",  "Business", "Wall St.", "TechCrunch", "Apple",  "Business"]
    
    private let categoryFlowLayout = UICollectionViewFlowLayout()
    
    private var horizontalBarView: UIView = {
        let horizontalView = UIView()
        horizontalView.backgroundColor = .black
        horizontalView.translatesAutoresizingMaskIntoConstraints = false
        return horizontalView
    }()
    
    
    var leftAnchorConstraint = NSLayoutConstraint()
    var homeController: HomeViewController?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryFlowLayout)
        
        configure()
        setupHorizontalBar()
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        horizontalBarView.roundCorners(corners: [.topLeft, .topRight], radius: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHorizontalBar() {
        
        addSubview(horizontalBarView)
        
        leftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        NSLayoutConstraint.activate([
            leftAnchorConstraint,
            horizontalBarView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:  1/4),
            horizontalBarView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func configure() {
        
        categoryFlowLayout.scrollDirection = .horizontal
        
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
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        homeController?.scrollToMenu(index: indexPath.item)
    }
}

// MARK: - Collection View Data Source

extension MenuCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nameCategoryArray.count
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
