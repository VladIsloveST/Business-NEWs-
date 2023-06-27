//
//  NetworkService.swift
//  Business NEWs
//
//  Created by Mac on 14.02.2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case missingURL
    case responseAbsent
    case emptyData
    case redirection
    case clientError
    case serverError
    case statusCodeIsUnknown
}

enum StatusCodeResult<Error> {
    case success
    case failure(Error)
}

class NetworkService {
    private let baseApiKey = "apiKey=e70eac065c3b4e8b9520a03dc1643d26"
    
    func requestFrom(urlWitoutApiKey: String, complition: @escaping (Result<Data, Error>) -> Void) {
        let url = urlWitoutApiKey + baseApiKey
        guard let url = URL(string: url) else {
            return complition(.failure(NetworkError.missingURL)) }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                return complition(.failure(NetworkError.responseAbsent)) }
            
            let result = self.handleNetworkResponse(response)
            switch result {
                
            case .success:
                guard let data = data else {
                    complition(.failure(NetworkError.emptyData))
                    return
                }
                complition(.success(data))
            case .failure(let networkError):
                complition(.failure(networkError))
                
            }
        }.resume()
    }
}

