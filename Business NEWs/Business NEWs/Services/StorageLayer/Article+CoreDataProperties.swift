//
//  Article+CoreDataProperties.swift
//  Business NEWs
//
//  Created by Mac on 10.09.2023.
//
//

import Foundation
import CoreData


@objc(Article)
public class Article: NSManagedObject {}

extension Article {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
//        return NSFetchRequest<Article>(entityName: "Article")
//    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var publishedAt: String?
}

extension Article : Identifiable {}
