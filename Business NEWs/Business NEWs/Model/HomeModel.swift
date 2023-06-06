//
//  HomeModel.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

struct Article: Codable {
//    let source: Source
//    let autor: String
    let title: String
//    let description: String
//    let url: URL
//    let urlToImage: URL
//    let publishedAt: String
//    let content: String
}

struct Source: Codable {
    let id: String
    let name: String
}

