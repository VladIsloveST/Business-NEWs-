//
//  HomePresenter.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation

protocol ViewInPut: AnyObject {
    func success()
    func failer(error: Error)
}

protocol ViewOutPut: AnyObject {
    var typesOfArticles: [TypeOfArticles] { get set }
    init(view: ViewInPut, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func tapOnTheSearch()
    func getArticles()
    
}

class Presenter: ViewOutPut {
    
    weak var view: ViewInPut?
    private let group = DispatchGroup()
    private let networkService: NetworkServiceProtocol
    var router: RouterProtocol?
    var typesOfArticles: [TypeOfArticles] = []
    
    required init(view: ViewInPut, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getArticles()
    }
    
    func tapOnTheSearch() {
        router?.showSearch()
    }
    
    func getArticles() {
        group.enter()
        networkService.getArticlesFromApple { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.apple(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        networkService.getArticlesFromBusiness { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.business(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        networkService.getArticlesFromTechCrunch { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.techCrunch(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
        
        group.enter()
        networkService.getArticlesFromWallStreet { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.wallStreet(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
        
        group.notify(queue: DispatchQueue.main){
            self.view?.success()
        }
    }
}
