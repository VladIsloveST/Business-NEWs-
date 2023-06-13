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
    init(view: SearchViewInPut)
    func delete(_ atIndex: Int)
}

class PresenterSearchContoller: SearchViewOutPut {
    
    var mockData = ["First, First, First, First, First, First,First, Firstmmm","Second","Third"]
    weak var view: SearchViewInPut?
    
    required init(view: SearchViewInPut) {
        self.view = view
    }
    
    func delete(_ atIndex: Int) {
        mockData.remove(at: atIndex)
        view?.showUpdateData()
    }
}
