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
        
        configureTabBar()
        setupViewControllers()
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.didTapButton = { [unowned self] in
            self.routeToSettings()
        }
    }
    
    fileprivate func configureTabBar() {
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        delegate = self
        tabBar.tintColor = .label
        view.backgroundColor = .systemBackground
    }
    
    fileprivate func setupViewControllers() {
        
        viewControllers = [
            createNavController(SelectedArticlesViewController(),
                                title: "Saved",
                                systemImageName: "bookmark",
                                selectedImageName: "bookmark.fill"),
            createTabBarItem(ContainerViewController(),
                             title: "Home",
                             imageName: "house",
                             selectedImageName: "house.fill"),
            UIViewController()
        ]
    }
    
    fileprivate func routeToSettings() {
        if #available(iOS 15.0, *) {
            let settingsVC = SettingsViewController()
            present(settingsVC, animated: true)
        }
    }
    
    fileprivate func createNavController(_ viewController: UIViewController, title: String,
                                         systemImageName: String,
                                         selectedImageName: String) -> UIViewController {
        let rootViewController = createTabBarItem(viewController, title: title,
                                                  imageName: systemImageName,
                                                  selectedImageName: selectedImageName)
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
        
        if selectedIndex == 2 {
            return false
        }
        
        return true
    }
}
