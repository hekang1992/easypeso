//
//  SPAnimationPotocol.swift
//  EasePeso
//
//  Created by apple on 2024/3/28.
//

import UIKit

protocol SPAnimationPotocol {
    func addOpacityAnimation(duration: CFTimeInterval)
    func addPositionAnimation(duration: CFTimeInterval)
}

extension SPAnimationPotocol where Self: UIView {
    func addOpacityAnimation(duration: CFTimeInterval) {
        let opKeyAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opKeyAnimation.values = [1, 1, 0.5, 1]
        opKeyAnimation.duration = duration
        opKeyAnimation.repeatCount = Float.greatestFiniteMagnitude
        opKeyAnimation.beginTime = CFTimeInterval(Double(arc4random_uniform(90)) / 90.0)
        self.layer.add(opKeyAnimation, forKey: nil)
    }
    
    func addPositionAnimation(duration: CFTimeInterval) {
        let alAnima = CABasicAnimation(keyPath: "position.y")
        alAnima.fromValue = self.frame.maxY
        alAnima.toValue = self.frame.maxY + 3
        alAnima.duration = duration
        alAnima.repeatCount = Float.greatestFiniteMagnitude
        alAnima.autoreverses = true
        alAnima.beginTime = CFTimeInterval(Double(arc4random_uniform(30)) / 30.0)
        alAnima.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(alAnima, forKey: nil)
    }
}

extension UIView: SPAnimationPotocol {}
