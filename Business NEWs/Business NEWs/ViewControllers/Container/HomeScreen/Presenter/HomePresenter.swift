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
    init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol, router: RouterProtocol)
    func tapOnTheSearch()
    func getArticles(count: Int)
}

class Presenter: ViewOutPut {
    weak var view: ViewInPut?
    private let group = DispatchGroup()
    private let networkDataFetcher: NetworkDataFetcherProtocol
    var router: RouterProtocol?
    var typesOfArticles: [TypeOfArticles] = []
    
    required init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol, router: RouterProtocol) {
        self.view = view
        self.networkDataFetcher = networkDataFetcher
        self.router = router
        getArticles(count: 8)  // default count
    }
    
    func tapOnTheSearch() {
        router?.showSearch()
    }
    
    func getArticles(count: Int) {
        typesOfArticles = []
        group.enter()
        networkDataFetcher.getArticlesFromCategory(.business, count: count) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.business(items))
                print("getArticles success")
            case .failure(let error):
                self.view?.failer(error: error)
                
            }
            self.group.leave()
        }
        
        group.enter()
        networkDataFetcher.getArticlesFromCategory(.techCrunch, count: count) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.techCrunch(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
        
   /*     group.enter()
        networkDataFetcher.getArticlesFromCategory(.wallStreet) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.wallStreet(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
    
        group.enter()
        networkDataFetcher.getArticlesFromCategory(.apple) { [weak self] result in  // error
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles.append(.apple(items))
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }
    */
        group.notify(queue: DispatchQueue.main) {
            self.view?.success()
        }
    }
}
