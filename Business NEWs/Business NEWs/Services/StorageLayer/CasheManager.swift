//
//  CashManager.swift
//  Business NEWs
//
//  Created by Mac on 03.09.2023.
//

import Foundation
import UIKit

protocol Cashe {
    static var shared: Cashe { get set }
    func fetchImageFromCasheWith(_ url: String?) -> UIImage?
    func saveImagesFrom(articles: [ArticleData])
}

final class CasheManager: Cashe {
    static var shared: Cashe = CasheManager()
    private init() {}
    private let imageCashe = NSCache<NSString, UIImage>()
    
    func fetchImageFromCasheWith(_ url: String?) -> UIImage? {
        guard let name = url else { return nil }
        if let cachedImage = imageCashe.object(forKey: name as NSString) {
            return cachedImage
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
        guard let name = withURL else { return }
        guard let url = URL(string: name) else { return }
        
        let imageData = try? Data(contentsOf: url)
        guard let imageData = imageData else { return }
        if let image = UIImage(data: imageData) {
            self.imageCashe.setObject(image, forKey: name as NSString)
        }
    }
}
