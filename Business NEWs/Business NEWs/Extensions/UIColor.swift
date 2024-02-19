//
//  UIColor.swift
//  Business NEWs
//
//  Created by Mac on 11.09.2023.
//

import Foundation
import UIKit

extension UIColor {
    class var myBackgroundColor: UIColor {
        switch SettingManager().isDark {
        case true:
            return .systemGray3
        case false:
            return .white
        }
    }
    
    class var cellBackgroundColor: UIColor {
        switch SettingManager().isDark {
        case true:
            return .darkGray
        case false:
            return .systemGray3
        }
    }
    
    class var myTextColor: UIColor {
        switch SettingManager().isDark {
        case true:
            return .white
        case false:
            return .darkGray
        }
    }
}
