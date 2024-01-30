//
//  HomePresenter.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import Foundation
import UIKit

protocol ViewInPut: AnyObject {
    func success()
    func failer(error: NetworkError)
}

protocol ViewOutPut: AnyObject {
    var typesOfArticles: [[ArticleData]] { get set }
    init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol,
         storageManager: Cashe, router: RouterProtocol)
    func tapOnTheSearch()
    func getArticlesFromCategory(index: Int, page: Int, isRefreshed: Bool)
}

class Presenter: ViewOutPut {
    weak var view: ViewInPut?
    private let group = DispatchGroup()
    private let networkDataFetcher: NetworkDataFetcherProtocol
    var storageManager: Cashe?
    var router: RouterProtocol?
    var typesOfArticles: [[ArticleData]] = Array(repeating: [], count: 8)
    
    required init(view: ViewInPut, networkDataFetcher: NetworkDataFetcherProtocol,
                  storageManager: Cashe, router: RouterProtocol) {
        self.view = view
        self.networkDataFetcher = networkDataFetcher
        self.storageManager = storageManager
        self.router = router

        Array(0...3).forEach { index in
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