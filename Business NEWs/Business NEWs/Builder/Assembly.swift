//
//  Assembly.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit

protocol AssemblyModuleProtocol {
    func assembleHome(router: RouterProtocol) -> UIViewController
    func assembleSearch(router: RouterProtocol) -> UIViewController
}

class AssemblyModule: AssemblyModuleProtocol {
    
    func assembleHome(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let homeView = HomeViewController()
        let storageManager = CasheManager.shared
        let presenter = Presenter(view: homeView, networkDataFetcher: networkDataFetcher,
                                  storageManager: storageManager, router: router)
        homeView.presenter = presenter
        return homeView
    }
    
    func assembleSearch(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let searchView = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchView, router: router, networkDataFetcher: networkDataFetcher)
        searchView.presenter = searchPresenter
        return searchView
    }
}

protocol SettingsAssemblyProtocol {
    static func assembleSettings() -> UIViewController
}

class SettingsAssembly: SettingsAssemblyProtocol {
    static func assembleSettings() -> UIViewController {
        let settingsView = SettingsViewController()
        let localNotification = LocalNotification()
        settingsView.localNotification = localNotification
        localNotification.delegate = settingsView
        return settingsView
    }
}


// MARK: - update ???
protocol HomeAssemblyProtocol {
    static func createHomeBuilder(router: RouterProtocol) -> UIViewController
}

class HomeAssembly: HomeAssemblyProtocol {
    static func createHomeBuilder(router: RouterProtocol) -> UIViewController {
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
    static func assembleSearch(router: RouterProtocol) -> UIViewController
}

class SearchAssembly: SearchAssemblyProtocol {
    static func assembleSearch(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let searchView = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchView,
                                              router: router, networkDataFetcher: networkDataFetcher)
        searchView.presenter = searchPresenter
        return searchView
    }
}

final class Builder {
    var homeScreen: HomeAssemblyProtocol!
    var searchScreen: SearchAssemblyProtocol!
    
    init() {

//        homeScreen = HomeAssembly.createHomeBuilder(router: <#T##RouterProtocol#>)
          
//        searchScreen = SearchAssembly.createSearchBuilder(router: <#T##RouterProtocol#>)
    }
}
