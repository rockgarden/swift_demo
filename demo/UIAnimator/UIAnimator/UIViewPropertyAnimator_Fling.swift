//
//  UIViewPropertyAnimator_Fling.swift
//  UIAnimator
//
//  Created by wangkan on 2017/3/6.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class UIViewPropertyAnimator_Fling: UIViewController {
    @IBOutlet weak var v: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        self.v.addGestureRecognizer(p)
    }

    let which = 1

    func dragging(_ p : UIPanGestureRecognizer) {
        let v = p.view!
        let dest = CGPoint(self.view.bounds.width/2, self.view.bounds.height - v.frame.height/2)
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(.zero, in: v.superview)
        case .ended:
            switch which {
            case 1:
                let anim = UIViewPropertyAnimator(duration: 0.4, timingParameters: UISpringTimingParameters(dampingRatio: 0.6, initialVelocity: .zero))
                anim.addAnimations {
                    v.center = dest
                }
                anim.startAnimation()
            case 2:
                let vel = p.velocity(in: v.superview!)
                // vel is a CGPoint, not a CGVector
                // moreover, it is measured in points per second
                // but a spring initial velocity is a CGVector...
                // and it is measured with respect to the animation distance
                let c = v.center
                let distx = abs(c.x - dest.x)
                let disty = abs(c.y - dest.y)
                let anim = UIViewPropertyAnimator(duration: 0.4, timingParameters: UISpringTimingParameters(dampingRatio: 0.6, initialVelocity: CGVector(vel.x/distx, vel.y/disty)))
                anim.addAnimations {
                    v.center = dest
                }
                anim.startAnimation()
            default: break
            }
        default: break
        }
    }
    
}


