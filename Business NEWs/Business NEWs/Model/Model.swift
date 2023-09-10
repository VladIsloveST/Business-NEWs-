//
//  HomeModel.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

struct Articles: Codable {
    let articles: [ArticleData]
}

struct ArticleData: Codable {
//    let source: Source
    let author: String?
    var title: String
//    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
//    let content: String
}

struct Source: Codable {
    let id: String
    let name: String
}

