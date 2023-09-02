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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateImage(from url: String?) {
        imageView.image = nil
        //imageView.setImage(url)
        imageView.image = UIImage(named: "error")
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor)
          //  imageView.widthAnchor.constraint(equalTo: widthAnchor),
          //  imageView.heightAnchor.constraint(equalToConstant: 200)
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
                let asp = (superview?.frame.width)! / image.size.width

                let resizeConstraints = [
                    self.widthAnchor.constraint(equalToConstant: image.size.width * asp),
                    self.heightAnchor.constraint(equalToConstant: image.size.height * asp)
                ]
                addConstraints(resizeConstraints)
            }
        }
    }
}
