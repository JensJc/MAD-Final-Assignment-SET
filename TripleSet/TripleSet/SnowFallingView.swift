//
//  SnowFallingView.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 17-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

import UIKit

public let kDefaultFlakeFileName               = "snowflake"
public let kDefaultFlakesCount                 = 200
public let kDefaultFlakeWidth: Float           = 40.0
public let kDefaultFlakeHeight: Float          = 46.0
public let kDefaultMinimumSize: Float          = 0.4
public let kDefaultMaximumSize: Float          = 0.8
public let kDefaultAnimationDurationMin: Float = 6.0
public let kDefaultAnimationDurationMax: Float = 12.0

public class SnowFallingView: UIView {
    
    public var flakesCount: Int?
    public var flakeFileName: String?
    public var flakeWidth: Float?
    public var flakeHeight: Float?
    public var flakeMinimumSize: Float?
    public var flakeMaximumSize: Float?
    
    public var animationDurationMin: Float?
    public var animationDurationMax: Float?
    
    public var flakesArray: [UIImageView]?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds             = true
        self.flakeFileName        = kDefaultFlakeFileName
        self.flakesCount          = kDefaultFlakesCount
        self.flakeWidth           = kDefaultFlakeWidth
        self.flakeHeight          = kDefaultFlakeHeight
        self.flakeMinimumSize     = kDefaultMinimumSize
        self.flakeMaximumSize     = kDefaultMaximumSize
        self.animationDurationMin = kDefaultAnimationDurationMin
        self.animationDurationMax = kDefaultAnimationDurationMax
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    public func createFlakes() {
        flakesArray = [UIImageView]()
        let flakeImage: UIImage = UIImage(named: flakeFileName!)!
        for _: Int in 0 ..< flakesCount! {
            var vz: Float = 1.0 * Float(arc4random()) / Float(RAND_MAX)
            vz = vz < flakeMinimumSize! ? flakeMinimumSize! : vz
            vz = vz > flakeMaximumSize! ? flakeMaximumSize! : vz
            
            let vw = flakeWidth! * vz
            let vh = flakeHeight! * vz
            
            var vx = Float(frame.size.width) * Float(arc4random()) / Float(RAND_MAX)
            var vy = Float(frame.size.height) * 1.5 * Float(arc4random()) / Float(RAND_MAX)
            
            vy += Float(frame.size.height)
            vx -= vw
            
            let imageFrame = CGRect(x: CGFloat(vx), y: CGFloat(vy), width: CGFloat(vw), height: CGFloat(vh))
            let imageView: UIImageView = UIImageView(image: flakeImage)
            imageView.frame = imageFrame
            imageView.isUserInteractionEnabled = false
            flakesArray?.append(imageView)
            addSubview(imageView)
        }
    }
    
    public func startSnow() {
        if flakesArray == nil {
            createFlakes()
        }
        backgroundColor = UIColor.clear
        
        let rotAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotAnimation.repeatCount = Float.infinity
        rotAnimation.autoreverses = false
        rotAnimation.toValue = 6.28318531
        
        let theAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        theAnimation.repeatCount = Float.infinity
        theAnimation.autoreverses = false
        
        for v: UIImageView in flakesArray! {
            var p: CGPoint = v.center
            let startypos = p.y
            let endypos = frame.size.height
            p.y = endypos
            v.center = p
            let timeInterval: Float = (animationDurationMax! - animationDurationMin!) * Float(arc4random()) / Float(RAND_MAX)
            theAnimation.duration = CFTimeInterval(timeInterval + animationDurationMin!)
            theAnimation.fromValue = -startypos
            v.layer.add(theAnimation, forKey: "transform.translation.y")
            
            rotAnimation.duration = CFTimeInterval(timeInterval)
            v.layer.add(rotAnimation, forKey: "transform.rotation.y")
        }
    }
    
    public func stopSnow() {
        for v: UIImageView in flakesArray! {
            v.layer.removeAllAnimations()
        }
        flakesArray = nil
    }
    
    deinit {
    }
}
