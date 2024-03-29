//
//  StrokeAnimation.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import UIKit

class StrokeAnimation: CABasicAnimation {
    enum StrokeType {
        case start
        case end
    }
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
    
    init(type: StrokeType,beginTime: Double,
         fromValue: CGFloat = 0.0, toValue: CGFloat = 1.0, duration: Double = 0.75) {

        super.init()
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

