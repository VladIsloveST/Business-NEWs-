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
}

class StorageManager: Cashe {
    func save(articles: [ArticleData]) {
//        let neededItems = articles.indices.filter{ $0 % 4 == 0 }.map{ articles[$0] }
//        neededItems.forEach { article in
//            saveImage(fromURL: article.urlToImage)
//        }
        
        saveImage(fromURL: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/11cf0e30bb3cfd27a7b0f55aa6eddfd3.jpg")
    }
    
    private func saveImage(fromURL: String?) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else { return }
        guard let name = fromURL else { return }
        guard let url = URL(string: name) else { return }
        let imageData = try? Data(contentsOf: url)
        guard let imageData = imageData else { return }
        guard let image = UIImage(data: imageData) else { return }
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(name)
        print(fileURL)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch let error {
                print("Error saving file with ", error)
            }
        }
    }
}
