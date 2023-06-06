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
    init(view: ViewInPut, networkService: NetworkServiceProtocol)
    func getArticles()
    var articles: Articles? { get set }
}

class Presenter: ViewOutPut {
    
    weak var view: ViewInPut?
    let networkService: NetworkServiceProtocol
    var articles: Articles?
    
    required init(view: ViewInPut, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getArticles()
    }
    
    func getArticles() {
        networkService.getArticle { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.articles = articles
                    self.view?.success()
                case .failure(let error):
                    self.view?.failer(error: error)
                }
            }
        }
    }
}
