//
//  CustomImageView.swift
//  Business NEWs
//
//  Created by Mac on 06.02.2024.
//

import Foundation
import UIKit

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
