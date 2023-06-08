//
//  ProgressShapeLayer.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import UIKit

class ProgressShapeLayer: CAShapeLayer {
    
    // MARK: - Initialization
    public init(lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = UIColor.systemGray.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

