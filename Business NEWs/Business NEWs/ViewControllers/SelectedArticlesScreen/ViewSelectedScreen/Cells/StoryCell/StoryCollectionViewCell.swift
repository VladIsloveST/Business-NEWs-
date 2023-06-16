//
//  StoryCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 13.02.2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "StoryCollectionViewCell"

    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
