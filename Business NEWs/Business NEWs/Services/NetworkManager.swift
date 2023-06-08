//
//  NetworkManager.swift
//  Business NEWs
//
//  Created by Mac on 14.02.2023.
//

import Foundation

enum NetworkError: Error {
    case statusCodeIsUnknown
    case emptyData
    case errorWithData
    case stusCode(_ statusCode: Int)
    
}

protocol NetworkServiceProtocol {
    func getArticlesFromApple(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromBusiness(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromTechCrunch(complition: @escaping (Result<Articles, Error>)-> Void)
    func getArticlesFromWallStreet(complition: @escaping (Result<Articles, Error>)-> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseApiKey = "apiKey=e70eac065c3b4e8b9520a03dc1643d26"
    
    func getArticlesFromApple(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = "https://newsapi.org/v2/everything?q=apple&from=2023-06-07&to=2023-06-07&sortBy=popularity&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromBusiness(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromTechCrunch(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?sources=techcrunch&"
        getArticlefrom(url: url, complition: complition)
    }
    
    func getArticlesFromWallStreet(complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = "https://newsapi.org/v2/everything?domains=wsj.com&"
        getArticlefrom(url: url, complition: complition)
    }
    
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
            
            if statusCode >= 200 && statusCode <= 299 {
                guard let data = data else {
                    complition(.failure(NetworkError.emptyData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Articles.self, from: data)
                    complition(.success(result))
                } catch {
                    complition(.failure(NetworkError.errorWithData))
                }
            } else {
                complition(.failure(NetworkError.stusCode(statusCode)))
            }
        }.resume()
    }
}

