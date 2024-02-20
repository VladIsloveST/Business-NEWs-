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
    
    // MARK: - Methods
    func assembleHome(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let storageManager = CacheManager.shared
        let homePresenter = HomePresenter(networkDataFetcher: networkDataFetcher,
                                  storageManager: storageManager, router: router)
        let homeView = HomeViewController(presenter: homePresenter)
        homePresenter.setup(view: homeView)
        return homeView
    }
    
    func assembleSearch(router: RouterProtocol) -> UIViewController {
        let networkDataFetcher = NetworkDataFetcher()
        let searchPresenter = SearchPresenter(router: router, networkDataFetcher: networkDataFetcher)
        let searchView = SearchViewController(presenter: searchPresenter)
        searchPresenter.setup(view: searchView)
        return searchView
    }
}

protocol SettingsAssemblyProtocol {
    static func assembleSettings() -> UIViewController
}

class SettingsAssembly: SettingsAssemblyProtocol {
    static func assembleSettings() -> UIViewController {
        let localNotification = NotificationManager()
        let settingsView = SettingsViewController(localNotification: localNotification)
        localNotification.setup(delegate: settingsView)
        return settingsView
    }
}
