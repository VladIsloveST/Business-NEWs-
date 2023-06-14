//
//  UITabBarControllerExtension.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import Foundation
import UIKit

extension UITabBarController  {
    func createTabBarItem(_ viewController: UIViewController, title: String, systemImageName: String) -> UIViewController {
        
        viewController.tabBarItem.title = title
        let image = UIImage(systemName: systemImageName)
        viewController.tabBarItem.image = image
        return viewController
    }
}
