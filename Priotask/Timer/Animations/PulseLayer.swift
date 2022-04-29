//
//  PulseLayer.swift
//  Priotask
//
//  Created by Nikita Felicia on 27/04/22.
//

import UIKit


class PulsingLayer: CALayer {
    
    var animationGroup = CAAnimationGroup()
    
    var initialPulse: Float = 0.0
    var nextPulseAfter: TimeInterval = 0
    var animationDuration: TimeInterval = 0.3
    var radius: CGFloat = 0
    var numberOfPulses: Float = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    init(numberOfPulses: Float, radius: CGFloat, position: CGPoint, color: UIColor) {
        super.init()
    
        self.backgroundColor = color.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        DispatchQueue.main.async {
            self.setupAnimationGroup()
            self.add(self.animationGroup, forKey: "pulse")
        }
}
    
    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulse)
        scaleAnimation.toValue = 1
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.4, 1]
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = self.animationDuration
        self.animationGroup.repeatCount = numberOfPulses
        
        self.animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        
        self.animationGroup.animations = [self.createScaleAnimation(), self.createOpacityAnimation()]
    }
}

extension CAShapeLayer {
    func setFillLayerProperties(arcPath: UIBezierPath, trackColor: UIColor, isTimer: Bool) {
        self.path = arcPath.cgPath
        self.lineWidth = 8
        self.strokeColor =  trackColor.cgColor
        self.lineCap = .round
        self.strokeEnd = 0
        self.fillColor = UIColor(named: "background")?.cgColor
        if (isTimer) {
            self.strokeEnd = 1
        }
    }
    
    func setTrackLayer(arcPath: UIBezierPath, trackColor: UIColor){
        self.path = arcPath.cgPath
        self.strokeColor = trackColor.cgColor
        self.lineWidth = 8
        self.lineCap = .round
    }
    
    func setRoundFillerLayer(arcPath: UIBezierPath, trackColor: UIColor, strokeStart: CGFloat, strokeEnd: CGFloat){
        self.path = arcPath.cgPath
        self.lineWidth = 12
        self.strokeColor = trackColor.cgColor
        self.fillColor = UIColor.clear.cgColor
        self.strokeStart = strokeStart
        self.strokeEnd = strokeEnd
        self.lineCap = .round
    }
}
