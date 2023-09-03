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
        let networkDataFetcher = NetworkDataFetcher()
        let storageManager = StorageManager()
        let presenter = Presenter(view: homeView, networkDataFetcher: networkDataFetcher,
                                  storageManager: storageManager, router: router)
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
