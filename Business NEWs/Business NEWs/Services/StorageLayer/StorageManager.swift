//
//  CashManager.swift
//  Business NEWs
//
//  Created by Mac on 03.09.2023.
//

import Foundation
import UIKit

protocol Cashe {
    func save(articles: [ArticleData])
    func loadImageFromCasheWith(_ url: String?) -> UIImage?
    static var shared: Cashe { get set }
}

final class StorageManager: Cashe {
    static var shared: Cashe = StorageManager()
    private init() {}
    let imageCashe = NSCache<NSString, UIImage>()
    
    func loadImageFromCasheWith(_ url: String?) -> UIImage? {
        guard let name = url else { return nil }
        if let cachedImage = imageCashe.object(forKey: name as NSString) {
            return cachedImage
        }
        return nil
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
    
    private func loadingImageUsingCashe(withURL: String?) {
        guard let name = withURL else { return }
        guard let url = URL(string: name) else { return }
        
        let imageData = try? Data(contentsOf: url)
        guard let imageData = imageData else { return }
        if let image = UIImage(data: imageData) {
            self.imageCashe.setObject(image, forKey: name as NSString)
        }
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        guard let image = UIImage(data: imageData) else { return }
//        guard let data = image.jpegData(compressionQuality: 1) else { return }
//        let fileURL = documentsDirectory.appendingPathComponent(name)
//        print(fileURL)
//        if !FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                try data.write(to: fileURL)
//            } catch let error {
//                print("Error saving file with ", error)
//            }
//        }
    }
}
