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
    var typesOfArticles: [[ArticleData]] { get set }
    init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol, router: RouterProtocol)
    func tapOnTheSearch()
    func getArticles(index: Int, page: Int, isRefrash: Bool)
}

class Presenter: ViewOutPut {
    weak var view: ViewInPut?
    private let group = DispatchGroup()
    private let networkDataFetcher: NetworkDataFetcherProtocol
    var router: RouterProtocol?
    var typesOfArticles: [[ArticleData]] = Array(repeating: [], count: 8)
    
    required init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol, router: RouterProtocol) {
        self.view = view
        self.networkDataFetcher = networkDataFetcher
        self.router = router
        
        getArticles(index: 0)
        getArticles(index: 1)
        getArticles(index: 2)
        getArticles(index: 3)
    }
    
    func tapOnTheSearch() {
        router?.showSearch()
    }
    
    func getArticles(index: Int, page: Int = 1, isRefrash: Bool = false) {
        if isRefrash { typesOfArticles[0] = [] }
        
//        let workItem = DispatchWorkItem { [weak self] in
//        self?.networkDataFetcher.getArticlesFromCategory(fromIndex, page: page) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let items):
//                print(self.typesOfArticles.count)
//                self.typesOfArticles[fromIndex] = items.articles
//
//            case .failure(let error):
//                self.view?.failer(error: error)
//            }
//        }
//    }
//
//    workItem.perform()
//    workItem.notify(queue: DispatchQueue.main) {
//        self.view?.success()
//    }
        
        group.enter()
        networkDataFetcher.getArticlesCategoryFrom(index, page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let items):
                self.typesOfArticles[index] = items.articles
            case .failure(let error):
                self.view?.failer(error: error)
            }
            self.group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            self.view?.success()
        }
    }
}
