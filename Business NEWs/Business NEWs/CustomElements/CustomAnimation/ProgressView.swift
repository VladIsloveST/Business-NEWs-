//
//  ProgressView.swift
//  Business NEWs
//
//  Created by Mac on 08.06.2023.
//

import UIKit

class ProgressView: UIView {
    
    // MARK: - Properties
    private let lineWidth: CGFloat
    private lazy var shapeLayer = ProgressShapeLayer(lineWidth: lineWidth)
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }
    
    // MARK: - Initialization
    init(lineWidth: CGFloat = 5) {
        self.lineWidth = lineWidth
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        let rect = self.bounds
        let path = UIBezierPath(ovalIn: rect)
        shapeLayer.path = path.cgPath
    }
    
    private func animateStroke() {
        let startAnimation = StrokeAnimation(type: .start, beginTime: 0.25)
        let endAnimation = StrokeAnimation(type: .end, beginTime: 0.0)
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.animations = [startAnimation, endAnimation]
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        
        shapeLayer.add(strokeAnimationGroup, forKey: nil)
        self.layer.addSublayer(shapeLayer)
    }
    
    private func animateRotation() {
        let rotationAnimation = RotationAnimation(
            fromValue: 0,
            toValue: CGFloat.pi * 2,
            duration: 2,
            repeatCount: .greatestFiniteMagnitude
        )
        self.layer.add(rotationAnimation, forKey: nil)
    }
}
