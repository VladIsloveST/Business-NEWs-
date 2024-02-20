//
//  HomePresenter.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit

protocol HomeViewInPut: AnyObject {
    func success()
    func failer(error: NetworkError)
}

protocol ViewOutPut: AnyObject {
    var typesOfArticles: [[ArticleData]] { get set }
    init(networkDataFetcher: NetworkDataFetcherProtocol,
         storageManager: Cache, router: RouterProtocol)
    func tapOnTheSearch()
    func getArticlesFromCategory(index: Int, page: Int, isRefreshed: Bool)
}

class HomePresenter: ViewOutPut {
    
    // MARK: - Properties
    var typesOfArticles: [[ArticleData]] = Array(repeating: [], count: 8)
    private weak var view: HomeViewInPut?
    private let group: DispatchGroup
    private let networkDataFetcher: NetworkDataFetcherProtocol
    private var storageManager: Cache?
    private var router: RouterProtocol?
    
    // MARK: - Initialization
    required init(networkDataFetcher: NetworkDataFetcherProtocol,
                  storageManager: Cache, router: RouterProtocol) {
        self.networkDataFetcher = networkDataFetcher
        self.storageManager = storageManager
        self.router = router
        self.group = DispatchGroup()
        Array(0...3).forEach { index in
            getArticlesFromCategory(index: index)
        }
    }
    
    // MARK: - Methods
    func setup(view: HomeViewInPut) {
        self.view = view
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
                self.storageManager?.saveImagesFrom(articles: items.articles)
                let filteredArticles = items.articles.filter { $0.title != "[Removed]" }
                self.typesOfArticles[index].append(contentsOf: filteredArticles)
            case .failure(let error):
                let safeFail = (error as? NetworkError) ?? NetworkError.internetConnectionError
                self.view?.failer(error: safeFail)
            }
            self.group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.view?.success()
        }
    }
}
