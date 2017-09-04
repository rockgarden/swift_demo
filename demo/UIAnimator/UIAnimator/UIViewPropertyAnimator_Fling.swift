//
//  UIViewPropertyAnimator_Fling.swift
//  UIAnimator
//
//  Created by wangkan on 2017/3/6.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

/// 扔动画
class UIViewPropertyAnimator_Fling: UIViewController {
    @IBOutlet weak var v: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let p = UIPanGestureRecognizer(target: self, action: #selector(dragging))
        self.v.addGestureRecognizer(p)
    }

    var which = 1

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
                // 此外，它以秒为单位进行测量, 但spring的初始速度是一个CGVector, 并且相对于动画距离来测量
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
        which = which < 2 ? which+1 : 1
    }
    
    func demo() {
        var animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut){
            self.v.center = CGPoint(0.5, 0.2)
        }
        animator.startAnimation()
        
        /// 两个控制点定义的贝塞尔曲线
        animator = UIViewPropertyAnimator(
            duration: 1.0,
            controlPoint1: CGPoint(0.1,0.5),
            controlPoint2: CGPoint(0.5, 0.2)){
                self.v.alpha = 0.0
            }
        
        /// 弹簧效果
       animator = UIViewPropertyAnimator(
            duration: 1.0,
            dampingRatio:0.4){ //dampingRatio阻尼系数
                self.v.center = CGPoint(x:0, y:0)
        }
        animator.startAnimation(afterDelay:2.5)
    }
    
    /// 我们可以通过调用`startAnimation`, `pauseAnimation` 和 `stopAnimation`轻松地与动画流交互。
    func blockDemo() {
        
        //`UIViewPropertyAnimator` 采用的是能够为动画器提供很多有趣能力的`UIViewImplicitlyAnimating`协议。例如，除了在初始化时候指定的block外，你还可以指定多个动画block。
        // Initialization
        let animator = UIViewPropertyAnimator(duration: 2.0, curve: .easeOut){
            self.v.alpha = 0.0
        }
        // Another animation block
        animator.addAnimations{
            self.v.center = CGPoint(0.5, 0.2)
        }
        animator.startAnimation()
        
        /// 动画的默认流（从起始点到结束点），可以通过`fractionComplete`属性更改。这个值表示动画完成的百分比，取值范围是0 到 1。你能够修改这个值来像你期望的那样驱动流（例如：用户可能会用滑块或滑动手势实时地修改`fraction`)。
        //animator.fractionComplete = slider.value
        
        /// `position`参数是一个 `UIViewAnimatingPosition`类型的值，它有三个枚举值，分别代表动画是在开始停止，结束后停止，还是当前位置停止。 通常你都会收到结束的枚举值。
        animator.addCompletion { (position) in
            print("Animation completed")
        }
    }
    
}


