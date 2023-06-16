//
//  SectionType.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

enum SectionType {
    case recent([ArticleData])
    case outdated([ArticleData])
    
    var name: String {
        switch self {
        case .recent:
            return "Recent"
        case .outdated:
            return "Outdated"
        }
    }
    
    var count: Int {
        switch self {
        case let .recent(items), let .outdated(items):
            return items.count
        }
    }

}
