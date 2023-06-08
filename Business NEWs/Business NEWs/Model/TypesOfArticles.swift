//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import Foundation

enum TypeOfArticles {
    case apple(Articles)
    case business(Articles)
    case techCrunch(Articles)
    case wallStreet(Articles)
    
    var name: String {
        switch self {
        case .apple:
            return "Apple"
        case .business:
            return "Business"
        case .techCrunch:
            return "Tech Crunch"
        case .wallStreet:
            return "Wall Street"
        }
    }
    
    var numberOfArticles: Int {
        switch self {
        case .apple(let typeOfArticles):
            return typeOfArticles.articles.count
        case .business(let typeOfArticles):
            return typeOfArticles.articles.count
        case .techCrunch(let typeOfArticles):
            return typeOfArticles.articles.count
        case .wallStreet(let typeOfArticles):
            return typeOfArticles.articles.count
        }
    }
}
