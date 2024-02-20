//
//  Article+CoreDataProperties.swift
//  Business NEWs
//
//  Created by Mac on 11.09.2023.
//
//

import Foundation
import CoreData


extension Article {

    @NSManaged public var author: String?
    @NSManaged public var publishedAt: String
    @NSManaged public var title: String
    @NSManaged public var url: String
}

extension Article : Identifiable {}
