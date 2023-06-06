//
//  MockData.swift
//  Business NEWs
//
//  Created by Mac on 12.02.2023.
//

import Foundation

struct MockData {
    
    static let shared = MockData()
    
    private var portraits: SectionType = {
        .portrait([ .init(title: ""),
                    .init(title: "")
        ])
    }()
    
    private let stories: SectionType = {
        .story([ .init(title: ""),
                 .init(title: ""),
                 .init(title: ""),
                 .init(title: ""),
                 .init(title: ""),
                 .init(title: "")
        ])
    }()
    
    var articleData: [SectionType] {  // computed property
        [stories, portraits]
    }
    
}
