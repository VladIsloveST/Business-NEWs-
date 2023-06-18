//
//  Router.swift
//  Business NEWs
//
//  Created by Mac on 17.06.2023.
//

import Foundation
import UIKit

protocol RouterMain {
    var  navigatinController: UINavigationController? { get set }
    var  assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showSearch()
    func popToRoot()
}

class HomeRouter: RouterProtocol {
    var navigatinController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
        
    init(navigatinController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigatinController = navigatinController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigatinController = navigatinController {
            guard let homeViewController = assemblyBuilder?.createHomeBuilder(router: self) else { return }
            navigatinController.viewControllers = [homeViewController]
        }
    }
    
    func showSearch() {
        if let navigatinController = navigatinController {
            guard let searchViewController = assemblyBuilder?.createSearchBuilder(router: self) else { return }
            navigatinController.pushViewController(searchViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigatinController = navigatinController {
            navigatinController.popToRootViewController(animated: true)
        }
    }
}
