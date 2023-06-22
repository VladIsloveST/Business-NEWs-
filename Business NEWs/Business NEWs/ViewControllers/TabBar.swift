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
        
  //      self.tabBarController?.delegate = self
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .white
        tabBar.tintColor = .label
        setupVCs()
        
    }
    
    fileprivate func setupVCs() {
        
        viewControllers = [
            createNavController(SelectedArticlesViewController(),
                                title: "Saved",
                                systemImageName: "bookmark"),
            createTabBarItem(ContainerViewController(),
                             title: "Home",
                             systemImageName: "house"),
            createNavController(SettingsViewController(),
                                title: "Settings",
                                systemImageName: "gearshape")
        ]
    }
    
    fileprivate func createNavController(_ viewController: UIViewController,
                                         title: String,
                                         systemImageName: String) -> UIViewController {
        let rootViewController = createTabBarItem(viewController, title: title, systemImageName: systemImageName)
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
