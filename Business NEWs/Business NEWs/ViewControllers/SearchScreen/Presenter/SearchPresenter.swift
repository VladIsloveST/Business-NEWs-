//
//  PresenterSearchContoller.swift
//  Business NEWs
//
//  Created by Mac on 12.06.2023.
//

import Foundation

protocol SearchViewInPut: AnyObject {
    func showUpdateData()
}

protocol SearchViewOutPut: AnyObject {
    var searchResultArticles: [ArticleData] { get set }
    init(view: SearchViewInPut, router: RouterProtocol, networkDataFetcher: NetworkDataFetcherProtocol)
    func turnBack()
    func search(line: String, page: Int)
}

class SearchPresenter: SearchViewOutPut {
    var searchResultArticles: [ArticleData] = []
    weak var view: SearchViewInPut?
    var router: RouterProtocol?
    var networkDataFetcher: NetworkDataFetcherProtocol?
    
    required init(view: SearchViewInPut, router: RouterProtocol, networkDataFetcher: NetworkDataFetcherProtocol) {
        self.view = view
        self.router = router
        self.networkDataFetcher = networkDataFetcher
    }
    
    func turnBack() {
        router?.popToRoot()
    }
    
    func search(line: String, page: Int) {
        searchResultArticles = []
        let dispatchWorkItem = DispatchWorkItem { //[weak self] _ in
            self.networkDataFetcher?.getSearchArticles(fromSearch: line, page: page, complition: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let items):
                    self.searchResultArticles.append(contentsOf: items.articles)
                case .failure(let error):
                    print("Error with data \(error)")
                }
            })
        }
        
        dispatchWorkItem.perform()
        
        dispatchWorkItem.notify(queue: DispatchQueue.main) {
            self.view?.showUpdateData()
        }
    }
}
