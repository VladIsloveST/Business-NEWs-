//
//  CollectionReusableView.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    
    static var identifier = "CollectionReusableView"
    
    var cellTitleLble: UILabel?
    
    func setup(_ title: String) {
        cellTitleLble?.text = title
    }
}

