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
    var mockData: [String] { get set }
    init(view: SearchViewInPut, router: RouterProtocol)
    func delete(_ atIndex: Int)
    func turnBack()
}

class PresenterSearchContoller: SearchViewOutPut {
    
    var mockData = ["First, First, First, First, First, First,First, Firstmmm","Second","Third"]
    var router: RouterProtocol?
    weak var view: SearchViewInPut?
    
    required init(view: SearchViewInPut, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func delete(_ atIndex: Int) {
        mockData.remove(at: atIndex)
        view?.showUpdateData()
    }
    
    func turnBack() {
        router?.popToRoot()
    }
}
