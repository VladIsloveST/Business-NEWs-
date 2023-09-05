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
    //var mockData: [String] { get set }  ???
    init(view: SearchViewInPut, router: RouterProtocol, networkDataFetcher: NetworkDataFetcherProtocol)
    //func delete(_ atIndex: Int)
    func turnBack()
    func search(line: String)
}

class PresenterSearchContoller: SearchViewOutPut {
    
    //var mockData = ["First", "Second", "Third"]
    
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
    
    func search(line: String) {
        DispatchWorkItem { //[weak self] _ in 
            self.networkDataFetcher?.getSearchArticles(fromSearch: line)
        }.perform()
    }
}
