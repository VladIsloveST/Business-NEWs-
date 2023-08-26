//
//  UIImageView.swift
//  Business NEWs
//
//  Created by Mac on 12.08.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(_ imgURLString: String?) {
        guard let imageURLString = imgURLString else {
            let image = UIImage(named: "error")
            self.image = image
            
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = (data != nil) ? UIImage(data: data!) : UIImage(named: "error")
            }
        }
    }
}
