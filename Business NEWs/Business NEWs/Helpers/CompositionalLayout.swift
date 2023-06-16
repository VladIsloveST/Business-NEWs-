//
//  CompositionalLayout.swift
//  Business NEWs
//
//  Created by Mac on 01.06.2023.
//

import Foundation
import UIKit

enum CompositionalGroupAligment {
    case horizontal
    case vertical
}

struct CompositionalLayout {
    
    static func createItem(width: NSCollectionLayoutDimension,
                           height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: .init(widthDimension: width,
                                                        heightDimension: height))
    }
    
    static func createGroup(aligment: CompositionalGroupAligment,
                            width: NSCollectionLayoutDimension,
                            height: NSCollectionLayoutDimension,
                            subitems: NSCollectionLayoutItem...) -> NSCollectionLayoutGroup {
        switch aligment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: .init(widthDimension: width, heightDimension: height),
                subitems: subitems)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: width, heightDimension: height),
                subitems: subitems)
        }
    }
    
    static func createSection(group: NSCollectionLayoutGroup,
                              interGroupSpacing: CGFloat = 15,
                              scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollingBehavior
        section.interGroupSpacing = interGroupSpacing
        section.supplementariesFollowContentInsets = false
        section.contentInsets = .init(top: 0, leading: 15, bottom: 15, trailing: 15)
        return section
    }
}
