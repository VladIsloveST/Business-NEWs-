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
        let networkDataFetcher = NetworkDataFetcher()
        let homeView = HomeViewController()
        let storageManager = CasheManager.shared
        let presenter = Presenter(view: homeView, networkDataFetcher: networkDataFetcher,
                                  storageManager: storageManager, router: router)
        homeView.presenter = presenter
        return homeView
    }
    
    func createSearchBuilder(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let searchView = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchView, router: router, networkDataFetcher: networkDataFetcher)
        searchView.presenter = searchPresenter
        return searchView
    }
}


// MARK: - update ???
protocol HomeAssemblyProtocol {
    func createHomeBuilder(router: RouterProtocol) -> UIViewController
}

class HomeAssembly: HomeAssemblyProtocol {
    func createHomeBuilder(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let homeView = HomeViewController()
        let storageManager = CasheManager.shared
        let presenter = Presenter(view: homeView, networkDataFetcher: networkDataFetcher,
                                  storageManager: storageManager, router: router)
        homeView.presenter = presenter
        return homeView
    }
}

protocol SearchAssemblyProtocol {
    func createSearchBuilder(router: RouterProtocol) -> UIViewController
}

class SearchAssembly: SearchAssemblyProtocol {
    func createSearchBuilder(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let searchView = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchView,
                                              router: router, networkDataFetcher: networkDataFetcher)
        searchView.presenter = searchPresenter
        return searchView
    }
}

final class Builder {
    
}
