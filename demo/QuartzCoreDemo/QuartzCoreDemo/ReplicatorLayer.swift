//
//  ReplicatorView.swift
//  CALayer
//
//  Created by wangkan on 2017/1/3.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

// FIXME: can't init
class ReplicatorLayer : CAReplicatorLayer {

    let bar = CALayer()
    var didSetup = false

    override init() {
        super.init()
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }

    func setup() {
        self.frame = CGRect(0,0,100,20)
        bar.frame = CGRect(0,0,10,20)
        bar.backgroundColor = UIColor.red.cgColor
        self.addSublayer(bar)
        self.instanceCount = 5
        self.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        bar.add(anim, forKey: nil)
        self.instanceDelay = anim.duration / Double(self.instanceCount)
    }
}
