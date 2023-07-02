//
//  File.swift
//  Business NEWs
//
//  Created by Mac on 10.06.2023.
//

import UIKit

extension UIBarButtonItem {
    convenience public init(imageSystemName: String, target: Any?, action: Selector) {
        
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let button: UIButton = UIButton(frame: frame)
        let image = UIImage(systemName: imageSystemName,
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(target, action: action, for: .touchUpInside)
        let customView = UIView(frame: frame)
        customView.addSubview(button)
        self.init(customView: customView)
    }
}

