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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setConstraints()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(from url: String?) {
        imageView.image = nil
        imageView.loadImageFromDiskWith(fileName: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/11cf0e30bb3cfd27a7b0f55aa6eddfd3.jpg")
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
            mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            mainLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 40),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        lableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lableStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lableStackView.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor, constant: -5),
            lableStackView.rightAnchor.constraint(equalTo: buttonStackView.leftAnchor, constant: 0)
        ])
    }
}

class ResizableImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            guard let image = image else { return }
            if superview != nil {
                let aspectRatio = (superview?.frame.width)! / image.size.width

                let resizeConstraints = [
                    self.widthAnchor.constraint(equalToConstant: image.size.width * aspectRatio),
                    self.heightAnchor.constraint(equalToConstant: image.size.height * aspectRatio)
                ]
                addConstraints(resizeConstraints)
            }
        }
    }
}
