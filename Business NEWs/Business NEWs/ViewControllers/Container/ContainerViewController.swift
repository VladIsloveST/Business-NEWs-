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
    private let homeVC = ModuleBuilder.createHomeBuilder()
    var navVC: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    func addChildVCs() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        (homeVC as? HomeViewController)?.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn) {
                
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width/2
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }

        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.navVC?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }

        }
    }
}
