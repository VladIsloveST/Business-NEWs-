//
//  TabBar.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    var containerViewController: ContainerViewController!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewController = ContainerViewController()
        configureTabBar()
        setupViewControllers()
    }
    
    // MARK: - Actions
    fileprivate func configureTabBar() {
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        delegate = self
        tabBar.tintColor = .label
        view.backgroundColor = .white
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.didTapButton = { [unowned self] in
            view.alpha = 0.9
            view.isUserInteractionEnabled = false
            self.routeToSettings()
        }
    }
    
    fileprivate func routeToSettings() {
        if #available(iOS 15.0, *) {
            let settingsVC = SettingsViewController()
            settingsVC.delegate = self
            let homeViewController = containerViewController?.navgationController.viewControllers.first
            settingsVC.settingDelegate = (homeViewController as? SettingViewControllerDelegate)
            present(settingsVC, animated: true)
        }
    }
    
    fileprivate func setupViewControllers() {
        viewControllers = [
            createNavController(SelectedArticlesViewController(),
                                title: "Saved",
                                systemImageName: "bookmark",
                                selectedImageName: "bookmark.fill"),
            createTabBarItem(containerViewController,
                             title: "Home",
                             imageName: "house",
                             selectedImageName: "house.fill"),
            UIViewController()
        ]
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

extension TabBarController: TabBarControllerDelegate {
    func removeFromInactiveState() {
        view.alpha = 1.0
        view.isUserInteractionEnabled = true
    }
}




