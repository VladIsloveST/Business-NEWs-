//
//  CoreDataManager.swift
//  Business NEWs
//
//  Created by Mac on 10.09.2023.
//

import CoreData
import UIKit

enum CoreDataError: Error {
    case unableToCreateDescription
    case unableToFetchArticlesFromContext
}

// MARK: - CRUD

protocol CoreDataProtocol {
    static var shared: CoreDataProtocol { get set }
    func createArticle(_ articleData: ArticleData)
    func fetchArticles() -> [Article]
    func deleteArticle(id: String)
    func checkAvaible(with title: String) -> Bool
}

final class CoreDataManager: NSObject, CoreDataProtocol {
    static var shared: CoreDataProtocol = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func createArticle(_ articleData: ArticleData) {
        guard !checkAvaible(with: articleData.title) else { return }
        guard let articleDescription = NSEntityDescription.entity(
            forEntityName: Article.description(), in: context)
        else { return print(CoreDataError.unableToCreateDescription) }
        let article = Article(entity: articleDescription, insertInto: context)
        article.title = articleData.title
        article.author = articleData.author
        article.url = articleData.url
        article.publishedAt = articleData.publishedAt
        DispatchQueue.main.async { [weak self] in
            self?.appDelegate.saveContext()
        }
    }
    
    func fetchArticles() -> [Article] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            return try context.fetch(fetchRequest) as? [Article] ?? []
        } catch {
            print(CoreDataError.unableToFetchArticlesFromContext)
        }
        return []
    }
    
    func deleteArticle(id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            guard let articles = try? context.fetch(fetchRequest) as? [Article],
                  let article = articles.first(where: { $0.title == id }) else { return }
            context.delete(article)
        }
        appDelegate.saveContext()
    }
    
    func fetchArticle(with title: String) -> Article? {
        let articles = fetchArticles()
        guard let article = articles.first(where: { $0.title == title }) else { return nil }
        return article
    }
    
    func checkAvaible(with title: String) -> Bool {
        let articles = fetchArticles()
        return articles.contains(where: { $0.title == title })
    }
}
