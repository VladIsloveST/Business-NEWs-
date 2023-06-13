//
//  SectionType.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

enum SectionType {
    case portrait([ArticleData])
    case story([ArticleData])
    
    var name: String {
        switch self {
        case .portrait:
            return "portrait"
        case .story:
            return "story"
        }
    }
    
    var count: Int {
        switch self {
        case let .portrait(items), let .story(items):
            return items.count
        }
    }

}
