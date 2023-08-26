//
//  MenuCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class MenuCollectionView: UICollectionView {
    
    weak var homeControllerDelegate: ArticlesMovementDelegate?
    
    private let nameCategoryArray = ["Wall St.", "Apple", "TechCrunch", "Business", "Wall St.", "TechCrunch", "Business", "Apple"]
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let categoryFlowLayout = UICollectionViewFlowLayout()
    private var leftAnchorConstraint = NSLayoutConstraint()
    private var widthAnchorConstraint = NSLayoutConstraint()
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: categoryFlowLayout)
        configure()
        setupHorizontalBar()
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        underlineView.roundCorners(corners: [.topLeft, .topRight], radius: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHorizontalBar() {
        addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        leftAnchorConstraint = underlineView.leftAnchor.constraint(equalTo: self.leftAnchor)
        widthAnchorConstraint = underlineView.widthAnchor.constraint(equalToConstant: 84)
        NSLayoutConstraint.activate([
            leftAnchorConstraint,
            widthAnchorConstraint,
            underlineView.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 30),
            underlineView.heightAnchor.constraint(equalToConstant: 6)
        ])
        UIView.animate(withDuration: 0.5) {
            self.underlineView.alpha = 1
        }
    }
    
    private func configure() {
        delegate = self
        dataSource = self

        categoryFlowLayout.minimumInteritemSpacing = 4
        categoryFlowLayout.scrollDirection = .horizontal
        
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        showsHorizontalScrollIndicator = false
        
        register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        selectItem(at: [0,0], animated: true, scrollPosition: [])
    }
    
    private func calculateCategoryWidth(item: Int) -> CGFloat {
        let categoryFont = UIFont(name: "Arial Bold", size: 18)
        let categoryAttributes = [NSAttributedString.Key.font : categoryFont]
        let categoryWidth = nameCategoryArray[item].size(withAttributes: categoryAttributes as [NSAttributedString.Key : Any]).width + 20
        return categoryWidth 
    }
    
    private func calculationLeftIndent(bySelectedCell item: Int) -> CGFloat {
        var originX: CGFloat = 0
        guard item > 0 else { return originX }
        for index in 0...item - 1 {
            let currentWidth = calculateCategoryWidth(item: index) + 4
            originX += currentWidth
        }
        return originX
    }
    
    func animateMovementUnderlineView(item: Int) {
        let indexPath = IndexPath(item: item, section: 0)
        let cell = cellForItem(at: indexPath)
        widthAnchorConstraint.constant = cell?.frame.width ?? 0
        leftAnchorConstraint.constant = calculationLeftIndent(bySelectedCell: item)
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}

    // MARK: - Collection View Delegate
    extension MenuCollectionView: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            homeControllerDelegate?.scrollToMenu(index: indexPath.item)
            animateMovementUnderlineView(item: indexPath.item)
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
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let categoryWidth = calculateCategoryWidth(item: indexPath.item)
            return CGSize(width: categoryWidth, height: frame.height)
        }
    }
