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
    case emptyData
    case responseAbsent
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
    private let baseApiKey = "apiKey=977e4b83946b42a1aba422dc52cefbb1"
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> StatusCodeResult<Error> {
        switch response.statusCode {
        case 200...299: return .success
        case 300...399: return .failure(NetworkError.redirection)
        case 400...499: return .failure(NetworkError.clientError)
        case 500...599: return .failure(NetworkError.serverError)
        default: return .failure(NetworkError.statusCodeIsUnknown)
        }
    }
    
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

