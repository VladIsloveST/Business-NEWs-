//
//  NetworkDataFetcher.swift
//  Business NEWs
//
//  Created by Mac on 27.06.2023.
//

import Foundation

enum CategoriesOfArticles: String {
    case apple = "everything?q=apple&sortBy=popularity&"
    case business = "top-headlines?country=us&category=business&"
    case techCrunch = "top-headlines?sources=techcrunch&"
    case wallStreet = "everything?domains=wsj.com&"
}

protocol NetworkDataFetcherProtocol {
    func getArticlesFromCategory(_ name: CategoriesOfArticles, count: Int, complition: @escaping (Result<Articles, Error>)-> Void)
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    
    let networkService = NetworkService()
    
    private func fetchTracks(url: String, response: @escaping (Result<Articles, Error>) -> Void ) {
        
        networkService.requestFrom(urlWitoutApiKey: url) { result in
            switch result {
                
            case .success(let data):
                do {
                    let articles = try JSONDecoder().decode(Articles.self, from: data)
                    response(.success(articles))
                } catch let jsonError{
                    print("\(jsonError). Unable to decode")
                }
            case .failure(let error):
                print("\(error) - .failure")
                response(.failure(error))
            }
        }
    }
    
    func getArticlesFromCategory(_ name: CategoriesOfArticles, count: Int, complition: @escaping (Result<Articles, Error>) -> Void) {
        let url = "https://newsapi.org/v2/" + name.rawValue + "pageSize=\(count)&"
        fetchTracks(url: url, response: complition)
    }
}


