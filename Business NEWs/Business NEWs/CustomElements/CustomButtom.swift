//
//  CustomButton.swift
//  Business NEWs
//
//  Created by Mac on 06.03.2024.
//

import Foundation
import UIKit

class CustomButtom: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
