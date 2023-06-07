//
//  MenuCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class MenuCollectionView: UICollectionView {
    
    private let nameCategoryArray = ["Like", "and", "subscribe", "chanel"]
    
    private let categoryFlowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryFlowLayout)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        //categoryFlowLayout.minimumInteritemSpacing = 0
        //categoryFlowLayout.scrollDirection = .horizontal
        self.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
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
        
        return CGSize(width: (frame.width - 40)/4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
