//
//  UIViewExtension.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import Foundation
import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func constraint(equalToAnchors: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: equalToAnchors.topAnchor),
            bottomAnchor.constraint(equalTo: equalToAnchors.bottomAnchor),
            rightAnchor.constraint(equalTo: equalToAnchors.rightAnchor),
            leftAnchor.constraint(equalTo: equalToAnchors.leftAnchor)
        ])
    }
}
