//
//  CustomCompositionalLayout.swift
//  Business NEWs
//
//  Created by Mac on 11.07.2023.
//

import Foundation
import UIKit

final class CustomFlowLayout: UICollectionViewCompositionalLayout {
    
    override init(section: NSCollectionLayoutSection) {
        super.init(section: section)
        register(LightSeparatorView.self, forDecorationViewOfKind: "whiteSeparator")
        register(SeparatorView.self, forDecorationViewOfKind: "darkSeparator")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let cellFrame = layoutAttribute.frame
            let lightSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: "whiteSeparator", with: layoutAttribute.indexPath)
            let darkSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: "darkSeparator", with: layoutAttribute.indexPath)
            
            if layoutAttribute.indexPath.item % 4 == 0 {
                lightSeparatorAttribute.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y - 41,
                                                  width: cellFrame.size.width, height: 2)
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

private final class SeparatorView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}

private final class LightSeparatorView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}

