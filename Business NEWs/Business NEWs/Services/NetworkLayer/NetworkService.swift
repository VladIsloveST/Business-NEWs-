//
//  NetworkService.swift
//  Business NEWs
//
//  Created by Mac on 14.02.2023.
//

import Foundation
import UIKit

enum NetworkError: String, Error {
    case missingURL = "URL is nil."
    case emptyData = "Response returned with no data to decode."
    case responseAbsent = "Response is nil."
    case redirection = "You need to take additional steps to fulfill the request."
    case clientError = "You need to be authenticated first."
    case serverError = "Bad request."
    case statusCodeIsUnknown = "Unknown response code status."
    case unableToDecode = "We could't decode the response."
    case internetConnectionError = "The Internet connection appears to be offline."
}

enum StatusCodeResult<Error> {
    case success
    case failure(Error)
}

class NetworkService {
    private let baseApiKey = "977e4b83946b42a1aba422dc52cefbb1" //apiKey=e70eac065c3b4e8b9520a03dc1643d26"
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> StatusCodeResult<Error> {
        print(response.statusCode)
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
            if let error = error { return complition(.failure(error)) }
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

