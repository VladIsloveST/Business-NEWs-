//
//  CashManager.swift
//  Business NEWs
//
//  Created by Mac on 03.09.2023.
//

import Foundation
import UIKit

protocol Cache {
    static var shared: Cache { get set }
    func fetchImageFromCasheWith(_ url: String?) -> UIImage?
    func saveImagesFrom(articles: [ArticleData])
    func removeAllObjects()
}

final class CacheManager: Cache {
    static var shared: Cache = CacheManager()
    private init() {}
    private let imageCache = NSCache<NSString, ImageCache>()
    
    func removeAllObjects() {
        imageCache.removeAllObjects()
    }
    
    func fetchImageFromCasheWith(_ url: String?) -> UIImage? {
        guard let cachedImage = imageCache.object(forKey: (url ?? "") as NSString) else { return nil }
        return cachedImage.image
    }
    
    func saveImagesFrom(articles: [ArticleData]) {
        let concurrentQueue = DispatchQueue(label: "cashe.label.concurrent", attributes: .concurrent)
        let filteredItems = articles.enumerated().filter { $0.offset % 4 == 0 }
        var isSerialLoad = true
        filteredItems.forEach { [weak self] article in
            if isSerialLoad {
                self?.loadImageToCashe(with: article.element.urlToImage)
                isSerialLoad = !isSerialLoad
                return
            }
            concurrentQueue.async {
                self?.loadImageToCashe(with: article.element.urlToImage)
            }
        }
    }
    
    private func loadImageToCashe(with url: String?) {
        guard let imageUrl = URL(string: url ?? "") else { return }
        do {
            let imageData = try Data(contentsOf: imageUrl)
            let cacheImage = ImageCache()
            cacheImage.image = UIImage(data: imageData)
            imageCache.setObject(cacheImage, forKey: imageUrl.description as NSString)
        } catch {
            print(error)
        }
    }
}

