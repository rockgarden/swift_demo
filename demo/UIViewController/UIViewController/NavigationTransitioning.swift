//
//  NavigationTransitioning.swift
//  UIViewController
//
//  Created by wangkan on 2017/5/15.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class NavTransition: UINavigationController {

    var anim : UIViewImplicitlyAnimating?
    var context : UIViewControllerContextTransitioning?

    // comment out this whole function to restore the default pop gesture
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self
        }
        return nil
    }

    //    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return nil
    //    }
}

// simple example of interruptibility
// user can grab image as it grows and drag it around
// we just resume when user lets go
extension NavTransition {
    func drag (_ g : UIPanGestureRecognizer) {
        let v = g.view!
        switch g.state {
        case .began:
            self.anim?.pauseAnimation()
            fallthrough
        case .changed:
            let delta = g.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            g.setTranslation(.zero, in: v.superview)
        case .ended:
            if #available(iOS 10.0, *) {
                let anim = self.anim as! UIViewPropertyAnimator

                let ctx = self.context!
                let vc2 = ctx.viewController(forKey:.to)!
                anim.addAnimations {
                    v.frame = ctx.finalFrame(for: vc2)
                }
                let factor = 1 - anim.fractionComplete
                anim.continueAnimation(withTimingParameters: nil, durationFactor: factor)
            }else {
                // Fallback on earlier versions
            }
        default:break
        }
    }
}


extension NavTransition : UIViewControllerAnimatedTransitioning {

    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {

        if self.anim != nil {
            return self.anim!
        }

        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!
        let con = ctx.containerView
        let r2end = ctx.finalFrame(for:vc2)
        let v2 = ctx.view(forKey:.to)!


        let mvc = vc1 as! UnderlappingVC
        let tv = mvc.tableView!
        let r = tv.rectForRow(at: IndexPath(row: 0, section: 0))
        let r2 = con.convert(r, from: tv)

        v2.frame = r2end

        con.addSubview(v2)

        let cm = mvc.model[mvc.lastSelection.row]
        let snapshot = UIImageView(image:UIImage(named:cm.name))
        snapshot.contentMode = .scaleAspectFill
        snapshot.clipsToBounds = true

        snapshot.frame = r2

        con.addSubview(snapshot)

        v2.alpha = 0

        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag))
        snapshot.addGestureRecognizer(pan)
        snapshot.isUserInteractionEnabled = true

        var anim: UIViewImplicitlyAnimating!
        if #available(iOS 10.0, *) {
            anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
                snapshot.frame = r2end // I'm sort of cheating; I know it will fill its superview
            }
            anim.addCompletion! { _ in
                ctx.completeTransition(true)
                v2.alpha = 1
                snapshot.removeFromSuperview()
            }
        } else {
            // Fallback on earlier versions
        }

        self.anim = anim
        print("creating animator")
        self.context = ctx

        return anim
    }

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 2
    }

    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        self.anim = nil
        self.context = nil
    }
    
}
