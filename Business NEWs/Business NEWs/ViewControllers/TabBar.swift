//
//  TabBar.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
            viewControllers = [
                createNavController(for: SelectedArticlesViewController(),
                                    title: NSLocalizedString("Saved", comment: ""),
                                    imageName: "bookmark"),
                createNavController(for: ModuleBuilder.createHomeBuilder(),
                                    title: NSLocalizedString("Home", comment: ""),
                                    imageName: "house"),
                createNavController(for: SettingsViewController(),
                                    title: NSLocalizedString("Settings", comment: ""),
                                    imageName: "gearshape")
            ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        let image = UIImage(systemName: imageName)
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
