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
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
