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
        register(WhiteSeparatorView.self, forDecorationViewOfKind: "whiteSeparator")
        register(DarkSeparatorView.self, forDecorationViewOfKind: "darkSeparator")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let cellFrame = layoutAttribute.frame
            let whiteSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: "whiteSeparator", with: layoutAttribute.indexPath)
            let blackSeparatorAttribute = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: "darkSeparator", with: layoutAttribute.indexPath)
            
            if layoutAttribute.indexPath.item % 4 == 0 {
                whiteSeparatorAttribute.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y - 41,
                                                  width: cellFrame.size.width, height: 2)
                decorationAttributes.append(whiteSeparatorAttribute)
                whiteSeparatorAttribute.zIndex = Int.max
            } else {
                blackSeparatorAttribute.frame = CGRect(x: cellFrame.origin.x + 20, y: cellFrame.origin.y - 0.5,
                                                  width: cellFrame.size.width - 40, height: 1)
                decorationAttributes.append(blackSeparatorAttribute)
                blackSeparatorAttribute.zIndex = Int.max
            }
        }
        return layoutAttributes + decorationAttributes
    }
}

private final class WhiteSeparatorView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}

private final class DarkSeparatorView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}
