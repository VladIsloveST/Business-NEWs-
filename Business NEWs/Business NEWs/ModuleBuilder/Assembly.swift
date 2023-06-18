//
//  Assembly.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit


protocol AssemblyBuilderProtocol {
    func createHomeBuilder(router: RouterProtocol) -> UIViewController
    func createSearchBuilder(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: AssemblyBuilderProtocol {
    
    func createHomeBuilder(router: RouterProtocol) -> UIViewController {
        let homeView = HomeViewController()
        let networkService = NetworkService()
        let presenter = Presenter(view: homeView, networkService: networkService, router: router)
        homeView.presenter = presenter
        return homeView
    }
    
    func createSearchBuilder(router: RouterProtocol) -> UIViewController {
        let searchView = SearchViewController()
        let searchPresenter = PresenterSearchContoller(view: searchView, router: router)
        searchView.presenter = searchPresenter
        return searchView
    }
}
