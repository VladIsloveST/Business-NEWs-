//
//  RotationAnimation.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import UIKit

class RotationAnimation: CABasicAnimation {
    // MARK: - Initialization
    override init() {
        super.init()
    }
    
    public init(
        fromValue: CGFloat,
        toValue: CGFloat,
        duration: Double,
        repeatCount: Float
    ) {

        super.init()
        
        self.keyPath = "transform.rotation.z"
        
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.repeatCount = repeatCount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
