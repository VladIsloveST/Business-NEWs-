//
//  ContainerViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuState {
        case closed
        case opened
    }
    
    private var menuState: MenuState = .closed
    private let menuVC = MenuViewController()
    var navgationController = UINavigationController()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    private func addChildVCs() {
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        menuVC.size = navgationController.view.bounds.width / 22
        
        let assembly = ModuleBuilder()
        navgationController.navigationBar.prefersLargeTitles = true
        let router = HomeRouter(navigatinController: navgationController, assemblyBuilder: assembly)
        router.initialViewController()
        (navgationController.viewControllers.first as? HomeViewController)?.delegate = self
        addChild(navgationController)
        view.addSubview(navgationController.view)
        navgationController.didMove(toParent: self)
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(complition: nil)
    }
    
    func toggleMenu(complition: (() -> Void)? ) {
        let homeViewController = (self.navgationController.viewControllers.first as? HomeViewController)
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn) {
                self.navgationController.view.frame.origin.x = (self.navgationController.view.frame.size.width) / 2.5
                homeViewController?.view.alpha = 0.95
                homeViewController?.view.isUserInteractionEnabled = false
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
            
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                self.navgationController.view.frame.origin.x = 0
                homeViewController?.view.alpha = 1
                homeViewController?.view.isUserInteractionEnabled = true
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                         complition?()
                    }
                }
            }
        }
    }
}

extension ContainerViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuOptions) {
        toggleMenu { 
            switch menuItem {
            case .home:
                break
            case .info:
                break
            case .appRating:
                break
            case .shareApp:
                break
            case .settings:
                break
            case .homeTest:
                break
            case .infoTest:
                break
            case .appRatingTest:
                break
            case .shareAppTest:
                break
            }
        }
    }
}
