//
//  Assembly.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit


protocol Builder {
    static func createHomeBuilder() -> UIViewController
    static func createSearchBuilder() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createHomeBuilder() -> UIViewController {
        let homeView = HomeViewController()
        let networkService = NetworkService()
        let presenter = Presenter(view: homeView, networkService: networkService)
        homeView.presenter = presenter
        return homeView
    }
    
    static func createSearchBuilder() -> UIViewController {
        let searchView = SearchViewController()
        let searchPresenter = PresenterSearchContoller(view: searchView)
        searchView.presenter = searchPresenter
        return searchView
    }
}
