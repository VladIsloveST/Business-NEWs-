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
        guard let name = url else { return nil }
        if let cachedImage = imageCache.object(forKey: name as NSString) {
            return cachedImage.image
        }
        return nil
    }
    
    func saveImagesFrom(articles: [ArticleData]) {
        let concurrentQueue = DispatchQueue(label: "cashe.label.concurrent", attributes: .concurrent)
        let neededItems = articles.indices.filter{ $0 % 4 == 0 }.map{ articles[$0] }
        var isSerialLoad = true
        neededItems.forEach { [ weak self ] article in
            if isSerialLoad {
                self?.loadImageToCashe(withURL: article.urlToImage)
                isSerialLoad = !isSerialLoad
                return
            }
            concurrentQueue.async {
                self?.loadImageToCashe(withURL: article.urlToImage)
            }
        }
    }
    
    private func loadImageToCashe(withURL: String?) {
        guard let name = withURL,
              let url = URL(string: name) else { return }
        let imageData = try? Data(contentsOf: url)
        guard let imageData = imageData else { return }
       
        let cacheImage = ImageCache()
        cacheImage.image = UIImage(data: imageData)
        imageCache.setObject(cacheImage, forKey: name as NSString)
    }
}

