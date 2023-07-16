//
//  LayerExtension.swift
//  Business NEWs
//
//  Created by Mac on 09.07.2023.
//

import Foundation
import UIKit

extension CALayer {
    func addShadow() {
        masksToBounds = false
        cornerRadius = 9
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.6
        shadowOffset =  CGSize(width: 0, height: 1)
        shadowRadius = 2.7
    }
}
