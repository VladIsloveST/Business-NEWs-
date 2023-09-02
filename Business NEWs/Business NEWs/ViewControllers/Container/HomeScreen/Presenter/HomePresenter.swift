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
    func getArticlesFromCategory(index: Int, page: Int, isRefreshed: Bool)
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
        
        Array(0...5).forEach { index in
            getArticlesFromCategory(index: index)
        }
    }
    
    func tapOnTheSearch() {
        router?.showSearch()
    }
    
    func getArticlesFromCategory(index: Int, page: Int = 1, isRefreshed: Bool = false) {
        if isRefreshed { typesOfArticles[index] = [] }
        group.enter()
        networkDataFetcher.getArticlesCategoryFrom(index, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.typesOfArticles[index].append(contentsOf: items.articles)
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
