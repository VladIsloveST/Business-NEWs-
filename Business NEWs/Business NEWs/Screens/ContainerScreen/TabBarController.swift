//
//  TabBarController.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Private Properties
    private var viewBuilder: SettingsAssemblyProtocol!
    
    // MARK: - Initialization
    init(viewBuilder: SettingsAssemblyProtocol = SettingsAssembly()) {
        self.viewBuilder = viewBuilder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    private func configureTabBar() {
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
    
    private func routeToSettings() {
        if #available(iOS 15.0, *) {
            let settingsVC = viewBuilder.assembleSettings()
            (settingsVC as? SettingsViewController)?.setup(delegate: self)
            present(settingsVC, animated: true)
        }
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavController(SelectedArticlesViewController(),
                                title: "Saved".localized,
                                systemImage: "bookmark",
                                selectedImage: "bookmark.fill"),
            createTabBarItem(MergedViewController(),
                             title: "Home".localized,
                             imageName: "house",
                             selectedImage: "house.fill"),
            UIViewController()
        ]
    }
    
    private func createNavController(_ viewController: UIViewController, title: String,
                                         systemImage: String, selectedImage: String) -> UIViewController {
        let rootViewController = createTabBarItem(viewController, title: title,
                                                  imageName: systemImage, selectedImage: selectedImage)
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}

// MARK: - UITabBarController Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
           selectedIndex == 2 { return false }
        return true
    }
}

// MARK: - Additional Delegate
extension TabBarController: ReappearanceDelegate {
    func removeFromInactiveState() {
        view.alpha = 1.0
        view.isUserInteractionEnabled = true
    }
}
