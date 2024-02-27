//
//  MergedViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

class MergedViewController: UIViewController {
    
    private enum MenuState {
        case closed
        case opened
    }
    
    // MARK: - Private Properties
    private var menuState: MenuState = .closed
    private var menuViewController: MenuViewController!
    private var navgationController = UINavigationController()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    // MARK: - Private Methods
    private func addChildVCs() {
        menuViewController = MenuViewController(size: navgationController.view.bounds.width / 22)
        menuViewController.delegate = self
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        let assembly = AssemblyModule()
        navgationController.navigationBar.prefersLargeTitles = true
        let router = HomeRouter(navigatinController: navgationController, assemblyModule: assembly)
        router.initialViewController()
        (navgationController.viewControllers.first as? HomeViewController)?.delegate = self
        addChild(navgationController)
        view.addSubview(navgationController.view)
        navgationController.didMove(toParent: self)
    }
}

// MARK: - Additional Delegate
extension MergedViewController: HomeViewControllerMenuDelegate {
    func didTapMenuButton() {
        toggleMenu(complition: nil)
    }
    
    private func toggleMenu(complition: (() -> Void)? ) {
        let homeViewController = (self.navgationController.viewControllers.first as? HomeViewController)
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0, options: .curveEaseIn) {
                self.navgationController.view.frame.origin.x = (self.navgationController.view.frame.size.width) / 2.5
                homeViewController?.view.alpha = 0.95
                homeViewController?.view.isUserInteractionEnabled = false
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
            
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0, options: .curveEaseOut) {
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

extension MergedViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuOptions) {
        toggleMenu { 
            switch menuItem {
            case .business:
                break
            case .health:
                break
            case .science:
                break
            case .sports:
                break
            case .technology:
                break
            case .relevancy:
                break
            case .popularity:
                break
            case .today:
                break
            case .yesterday:
                break
            case .week:
                break
            case .month:
                break
            }
        }
    }
}
