//
//  LargePortraitCell.swift
//  Business NEWs
//
//  Created by Mac on 10.07.2023.
//

import Foundation
import UIKit

class LargePortraitCell: BasicCollectionViewCell {
    
    // MARK: -  Properties
    static let identifier = "LargePortraitCell"
    private var imageView = ResizableImageView()
    private let storageManager = CacheManager.shared
    
    // MARK: - Init Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    override func assignCellData(from article: ArticleData, isSaved: Bool, currentDate: DateComponents?) {
        updateImage(from: article.urlToImage)
        super.assignCellData(from: article, isSaved: isSaved, currentDate: currentDate)
    }
    
    private func updateImage(from url: String?) {
        imageView.image = nil
        imageView.image = storageManager.fetchImageFromCasheWith(url)
        //contentView.reloadInputViews()
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            generalStackView.widthAnchor.constraint(equalToConstant: frame.width - 40),
            generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            generalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
