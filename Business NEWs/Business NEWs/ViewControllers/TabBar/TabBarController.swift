//
//  TabBar.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
                
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .white
        tabBar.tintColor = .label
        setupVCs()
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.didTapButton = { [unowned self] in
            self.routeToSettings()
        }
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

// MARK: - UITabBarController Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // Your middle tab bar item index.
        // In my case it's 2.
        if selectedIndex == 2 {
            return false
        }
        
        return true
    }
}
