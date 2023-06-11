//
//  NetworkManager.swift
//  Business NEWs
//
//  Created by Mac on 14.02.2023.
//

import Foundation

enum NetworkError: Error {
    case emptyData
    case unableToDecode
    case statusCodeIsUnknown
    case redirection
    case clientError
    case serverError
    case requestFailed
    
}

protocol NetworkServiceProtocol {
    func getArticlesFromApple(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromBusiness(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromTechCrunch(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromWallStreet(complition: @escaping (Result<Articles, Error>)-> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private let endpoint = "https://newsapi.org/v2/"
    private let baseApiKey = "apiKey=e70eac065c3b4e8b9520a03dc1643d26"
    
    private func getArticlefrom(url: String, complition: @escaping (Result<Articles, Error>) -> Void) {
        let urlTechCrunch = url + baseApiKey
        guard let url = URL(string: urlTechCrunch) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                complition(.failure(NetworkError.statusCodeIsUnknown))
                return
            }
            
            if let error = error {
                complition(.failure(error))
                return
            }
            
            switch statusCode {
            case 200...299:
                guard let data = data else {
                    complition(.failure(NetworkError.emptyData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Articles.self, from: data)
                    complition(.success(result))
                } catch {
                    complition(.failure(NetworkError.unableToDecode))
                }
                
            case 300...399:
                complition(.failure(NetworkError.redirection))
            case 400...499:
                complition(.failure(NetworkError.clientError))
            case 500...599:
                complition(.failure(NetworkError.serverError))
            default:
                complition(.failure(NetworkError.requestFailed))
            }
        }.resume()
    }
    
    func getArticlesFromApple(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url =  endpoint + "everything?q=apple&from=2023-06-07&to=2023-06-07&sortBy=popularity&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromBusiness(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = endpoint + "top-headlines?country=us&category=business&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromTechCrunch(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = endpoint + "top-headlines?sources=techcrunch&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromWallStreet(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = endpoint + "everything?domains=wsj.com&"
        getArticlefrom(url: url, complition: complition)
    }
}

