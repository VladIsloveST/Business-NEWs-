//
//  CustomCompositionalLayout.swift
//  Business NEWs
//
//  Created by Mac on 11.07.2023.
//

import Foundation
import UIKit

final class CustomFlowLayout: UICollectionViewCompositionalLayout {
    
    private var numberOfItemsInSection = 0
    
    // MARK: - Initialization
    convenience init(section: NSCollectionLayoutSection, numberOfItemsInSection: Int) {
        self.init(section: section)
        self.numberOfItemsInSection = numberOfItemsInSection
        register(LightSeparator.self, forDecorationViewOfKind: LightSeparator.description())
        register(DarkSeparator.self, forDecorationViewOfKind: DarkSeparator.description())
    }
    
    // MARK: - Method
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let cellFrame = layoutAttribute.frame
            let lightSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: LightSeparator.description(), with: layoutAttribute.indexPath)
            let darkSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: DarkSeparator.description(), with: layoutAttribute.indexPath)
            
            if layoutAttribute.indexPath.item % numberOfItemsInSection == 0 {
                lightSeparatorAttribute.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y - 41,
                                                       width: cellFrame.size.width, height: 1.5)
                decorationAttributes.append(lightSeparatorAttribute)
                lightSeparatorAttribute.zIndex = Int.max
            } else {
                darkSeparatorAttribute.frame = CGRect(x: cellFrame.origin.x + 20, y: cellFrame.origin.y - 0.5,
                                                      width: cellFrame.size.width - 40, height: 1)
                decorationAttributes.append(darkSeparatorAttribute)
                darkSeparatorAttribute.zIndex = Int.max
            }
        }
        return layoutAttributes + decorationAttributes
    }
}

private final class DarkSeparator: UICollectionReusableView {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}

private final class LightSeparator: UICollectionReusableView {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}


