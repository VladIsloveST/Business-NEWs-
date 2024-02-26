//
//  ImageCache.swift
//  Business NEWs
//
//  Created by Mac on 01.02.2024.
//

import Foundation
import UIKit

class ImageCache: NSObject {
    var image: UIImage!
}

extension ImageCache: NSDiscardableContent {
    
    func beginContentAccess() -> Bool { true }
    func endContentAccess() {}
    func discardContentIfPossible() {}
    func isContentDiscarded() -> Bool { false }
}
