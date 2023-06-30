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
            UIViewController()
//            createNavController(SettingsViewController(),
//                                title: "Settings",
//                                systemImageName: "gearshape")
        ]
    }
    
    func routeToSettings() {
        if #available(iOS 15.0, *) {
            let settingsVC = SettingsViewController()
            if let sheet = settingsVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.preferredCornerRadius = 20
            }
            present(settingsVC, animated: true)
        }
    }
    
    fileprivate func createNavController(_ viewController: UIViewController,
                                         title: String,
                                         systemImageName: String) -> UIViewController {
        let rootViewController = createTabBarItem(viewController, title: title,
                                                  systemImageName: systemImageName)
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
