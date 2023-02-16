//
//  NetworkManager.swift
//  Business NEWs
//
//  Created by Mac on 14.02.2023.
//

import Foundation

enum Result<T> {
    case success(T?)
    case fail(String)
}
/*
class NetworkManager {
    private let baseUrl = "https://todolistmy.mocklab.io/"
    
    func fetchAllTaks(complition: @escaping((Result<[Task]>) -> Void)) {
        let allListMethod = "alllist"
       fetchRequest(methodPath: allListMethod, complition: complition)
    }
    
    func fetchShoppingList(complition: @escaping((Result<[ShoppingList]>) -> Void)) {
            let shoppinglistsMethod = "shoppinglists"
            fetchRequest(methodPath: shoppinglistsMethod, complition: complition)
    }
    
    func fetchDoneTasks(complition: @escaping((Result<[Task]>) -> Void)) {
        let doneListMethod = "alllist?status=done"
        fetchRequest(methodPath: doneListMethod, complition: complition)
}
    
    func addTask(with name: String, taskDescr: String, complition: @escaping((Result<String>) -> Void)) {
        let methodPath = "addtask"
        fetchRequest(
            methodPath: methodPath,
            httpMethod: "POST",
            httpBody: configRequestBody(params: [
                "name" : name,
                "description": taskDescr
            ]),
            complition: complition
        )
    }
    
    private func fetchRequest<T: Codable>(
        methodPath: String,
        httpMethod: String = "GET",
        httpBody: Data? = nil,
        complition: @escaping((Result<T>) -> Void)
    ) {
        guard let allListMethodUrl = URL(string: baseUrl + methodPath) else {
            return
        }
        
        var request = URLRequest(url: allListMethodUrl)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                complition(.fail("Statuscode is unknown"))
                return
            }
            
            if error != nil  {
                complition(.fail("error\(error)"))
                return
            }
            
            if statusCode >= 200 && statusCode <= 299 {
                guard let data = data else {
                    complition(.fail("empty data"))
                    return
                }
                
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(T.self, from: data) {
                    complition(.success(result))
                } else { complition(.fail("error with data")) }
            } else {
                complition(.fail("Stus code\(statusCode)"))
            }
        }.resume()
    }
    
    func configRequestBody(params: [String: String]?) -> Data? {
        guard let params = params else {
            return nil
        }
        
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
}
*/
