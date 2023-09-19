//
//  NetworkDataFetcher.swift
//  Business NEWs
//
//  Created by Mac on 27.06.2023.
//

import Foundation

enum CategoriesOfArticles: String, CaseIterable {
    case wallStreet = "everything?domains=wsj.com"
    case apple = "everything?q=apple&sortBy=popularity"
    case techCrunch = "top-headlines?sources=techcrunch"
    case business = "top-headlines?country=us&category=technology"
    case tesla = "everything?q=tesla"
    case bitcoin = "everything?q=bitcoin"
    case ua = "top-headlines?country=ua"
    case bbc = "top-headlines?sources=bbc-news"
}

protocol NetworkDataFetcherProtocol {
    func getArticlesCategoryFrom(_ index: Int, page: Int,
                                 complition: @escaping (Result<Articles, Error>) -> Void)
    func getSearchArticles(fromSearch: String, page: Int, complition: @escaping (Result<Articles, Error>) -> Void)
}

class NetworkDataFetcher: NetworkDataFetcherProtocol {
    typealias ArticlesClousure = (Result<Articles, Error>) -> Void
    let networkService = NetworkService()
    
    private func fetchTracks(url: String, response: @escaping ArticlesClousure ) {
        networkService.requestFrom(urlWitoutApiKey: url) { result in
            switch result {
            case .success(let data):
                do {
                    let articles = try JSONDecoder().decode(Articles.self, from: data)
                    response(.success(articles))
                } catch let jsonError {
                    print("\(jsonError). Unable to decode")
                    response(.failure(NetworkError.unableToDecode))

                }
            case .failure(let error):
                print("\(error) - .failure")
                response(.failure(error))
            }
        }
    }
    
    func getArticlesCategoryFrom(_ index: Int, page: Int,
                                 complition: @escaping (Result<Articles, Error>) -> Void) {
        guard index < CategoriesOfArticles.allCases.count else { return }
        let url = "https://newsapi.org/v2/" + CategoriesOfArticles.allCases[index].rawValue + "&pageSize=12&page=\(page)&"
        fetchTracks(url: url, response: complition)
    }
    
    func getSearchArticles(fromSearch: String, page: Int, complition: @escaping (Result<Articles, Error>) -> Void) {
        print("from NetworkDataFetcher")
        let url = "https://newsapi.org/v2/everything?q=\(fromSearch)&pageSize=12&page=\(page)&" // ???
        fetchTracks(url: url, response: complition)
    }
}
