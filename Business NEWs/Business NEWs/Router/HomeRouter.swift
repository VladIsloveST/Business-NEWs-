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
    var  assemblyModule: AssemblyModuleProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showSearch()
    func popToRoot()
}

class HomeRouter: RouterProtocol {
    var navigatinController: UINavigationController?
    var assemblyModule: AssemblyModuleProtocol?
        
    init(navigatinController: UINavigationController, assemblyModule: AssemblyModuleProtocol) {
        self.navigatinController = navigatinController
        self.assemblyModule = assemblyModule
    }
    
    func initialViewController() {
        if let navigatinController = navigatinController {
            guard let homeViewController = assemblyModule?.assembleHome(router: self) else { return }
            navigatinController.viewControllers = [homeViewController]
        }
    }
    
    func showSearch() {
        if let navigatinController = navigatinController {
            guard let searchViewController = assemblyModule?.assembleSearch(router: self) else { return }
            navigatinController.pushViewController(searchViewController, animated: false)
        }
    }
    
    func popToRoot() {
        if let navigatinController = navigatinController {
            navigatinController.popToRootViewController(animated: false)
        }
    }
}
