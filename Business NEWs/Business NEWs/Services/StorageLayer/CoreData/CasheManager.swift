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
    func loadImageFromCasheWith(_ url: String?) -> UIImage?
    func save(articles: [ArticleData])
}

final class CasheManager: Cashe {
    static var shared: Cashe = CasheManager()
    private init() {}
    private let imageCashe = NSCache<NSString, UIImage>()
    
    func loadImageFromCasheWith(_ url: String?) -> UIImage? {
        guard let name = url else { return nil }
        if let cachedImage = imageCashe.object(forKey: name as NSString) {
            return cachedImage
        }
        return nil
    }
    
    private func loadingImageUsingCashe(withURL: String?) {
        guard let name = withURL else { return }
        guard let url = URL(string: name) else { return }
        
        let imageData = try? Data(contentsOf: url)
        guard let imageData = imageData else { return }
        if let image = UIImage(data: imageData) {
            self.imageCashe.setObject(image, forKey: name as NSString)
        }
    }
    
    func save(articles: [ArticleData]) {
        let dispQueue = DispatchQueue(label: "cashe.label.concurrent", attributes: .concurrent)
        var isFirst = true
        let neededItems = articles.indices.filter{ $0 % 4 == 0 }.map{ articles[$0] }
        neededItems.forEach { [ weak self ] article in
            if isFirst {
                self?.loadingImageUsingCashe(withURL: article.urlToImage)
                isFirst = false
                return
            }
            dispQueue.async {
                self?.loadingImageUsingCashe(withURL: article.urlToImage)
            }
        }
    }
}
