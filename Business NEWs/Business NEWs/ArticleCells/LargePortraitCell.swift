//
//  LargePortraitCell.swift
//  Business NEWs
//
//  Created by Mac on 10.07.2023.
//

import Foundation
import UIKit

class LargePortraitCell: BasicCollectionViewCell {
    static let identifier = "LargePortraitCell"
    
    var imageView = ResizableImageView()
    let storageManager = CasheManager.shared
    
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
    
    override func assignCellData(from article: ArticleData, currentHour: Int?) {
        super.assignCellData(from: article, currentHour: currentHour)
        updateImage(from: article.urlToImage)
    }
    
    private func updateImage(from url: String?) {
        imageView.image = nil
        imageView.image = storageManager.loadImageFromCasheWith(url)
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            generalStackView.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            generalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            generalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

class ResizableImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            guard let image = image else { return }
            if superview != nil {
                let aspectRatio = superview!.frame.width / image.size.width
                
                let resizeConstraints = [
                    self.widthAnchor.constraint(equalToConstant: image.size.width * aspectRatio),
                    self.heightAnchor.constraint(equalToConstant: image.size.height * aspectRatio)
                ]
                addConstraints(resizeConstraints)
            }
        }
    }
}
