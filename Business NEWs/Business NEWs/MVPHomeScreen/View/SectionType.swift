//
//  SectionType.swift
//  Business NEWs
//
//  Created by Mac on 11.02.2023.
//

import Foundation

enum SectionType {
    case portrait([Article])
    case story([Article])
    
    var items: [Article] {
        switch self {
        case .portrait(let items), .story(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var name: String {
        switch self {
        case .portrait:
            return "portrait"
        case .story:
            return "story"
        }
    }
}
