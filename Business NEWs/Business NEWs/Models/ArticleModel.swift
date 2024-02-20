//
//  ArticleModel.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

struct Articles: Codable {
    let articles: [ArticleData]
}

struct ArticleData: Codable {
    let author: String?
    var title: String
    let url: String
    var urlToImage: String? = nil
    let publishedAt: String
}
