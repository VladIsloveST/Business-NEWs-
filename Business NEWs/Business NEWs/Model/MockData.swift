//
//  MockData.swift
//  Business NEWs
//
//  Created by Mac on 12.02.2023.
//

import Foundation

struct MockData {
    
    static let shared = MockData()
    
    private var recent: SectionType = {
        .recent([ 
//                    .init(title: ""),
//                    .init(title: ""),
//                    .init(title: ""),
//                    .init(title: ""),
//                    .init(title: "")
        ])
    }()
    
    private let outdated: SectionType = {
        .outdated([
            //.init(title: ""),
//                 .init(title: ""),
//                 .init(title: ""),
//                 .init(title: ""),
//                 .init(title: ""),
//                 .init(title: "")
        ])
    }()
    
    var articleData: [SectionType] {  // computed property
        [outdated, recent]
    }
    
}
