//
//  AppDelegate.swift
//  UIViewController
//
//  Created by wangkan on 2017/4/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//
//  另一个 AppDelegate UINavigationControllerDelegate UIGestureRecognizerDelegate demo 在 UINavigationBar 项目中实现.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var anim : UIViewImplicitlyAnimating? //cannot be weak, vanishes before end of gesture
    var rightEdger : UIScreenEdgePanGestureRecognizer!
    var leftEdger : UIScreenEdgePanGestureRecognizer!
    
    /// 采用 UIPercentDrivenInteractiveTransition 实现
    var inter : UIPercentDrivenInteractiveTransition!

    /// 采用 UIViewControllerContextTransitioning 实现
    var interacting = false
    let useContext = true
    var context : UIViewControllerContextTransitioning? //phasing out misuse of IUO
    var r1end = CGRect.zero
    var r2start = CGRect.zero

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let tbc = self.window!.rootViewController as! UITabBarController
        tbc.delegate = self

        /// iOS 9 以前 edges have a problem : retain ref to g.r.
        let sep = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep.edges = UIRectEdge.right
        tbc.view.addGestureRecognizer(sep)
        sep.delegate = self
        rightEdger = sep

        let sep2 = UIScreenEdgePanGestureRecognizer(target:self, action:#selector(pan))
        sep2.edges = UIRectEdge.left
        tbc.view.addGestureRecognizer(sep2)
        sep2.delegate = self
        leftEdger = sep2
        
        return true
    }

    /// TODO: testing whether user can interact during animation.
    func doButton(_ sender: Any) {
        print("button tap!")
    }
}


extension AppDelegate : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interaction controller")
        
        /// no interaction if we didn't use g.r.
        let result : UIViewControllerInteractiveTransitioning? = self.interacting ? self.inter : nil
        
        /// will be nil if we didn't use g.r.
        if useContext {return self.interacting ? self : nil}
        
        return result
    }
}


extension AppDelegate : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ g: UIGestureRecognizer) -> Bool {
        let tbc = self.window!.rootViewController as! UITabBarController
        var result = false

        if (g as! UIScreenEdgePanGestureRecognizer).edges == .right {
            result = (tbc.selectedIndex < tbc.viewControllers!.count - 1)
        }
        else {
            result = (tbc.selectedIndex > 0)
        }
        return result
    }
    
    func pan_old(_ g: UIScreenEdgePanGestureRecognizer) {
        let v = g.view!
        let tbc = self.window!.rootViewController as! UITabBarController
        let delta = g.translation(in: v)
        let percent = fabs(delta.x/v.bounds.size.width)
        switch g.state {
        case .began:
            self.inter = UIPercentDrivenInteractiveTransition()
            self.interacting = true
            if g == self.rightEdger {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
        case .changed:
            self.inter.update(percent)
        case .ended:
            // self.inter.completionSpeed = 0.5
            // (try completionSpeed = 2 to see "ghosting" problem after a partial)
            // (can occur with 1 as well)
            // (setting to 0.5 seems to fix it)
            // now using delay in completion handler to solve the issue
            if percent > 0.5 {
                self.inter.finish()
            } else {
                self.inter.cancel()
            }
            self.interacting = false
        case .cancelled:
            self.inter.cancel()
            self.interacting = false
        default: break
        }
    }

    func pan(_ g: UIScreenEdgePanGestureRecognizer) {
        let v = g.view!
        // according to the docs, calling self.inter.update(percent)
        // should update the percent driver's percentComplete
        // but it doesn't; the percentComplete is always zero
        // so I have to do the calculation every time, so that .changed and .ended
        // can both see it
        let delta = g.translation(in:v)
        let percent = abs(delta.x/v.bounds.size.width)

        var vc1 : UIViewController!
        var vc2 : UIViewController!
        var r1start : CGRect!
        var r2end : CGRect!
        var v1 : UIView!
        var v2 : UIView!
        let ctx = self.context

        if #available(iOS 10.0, *) { }
        else {
            if useContext {
                if ctx != nil {
                    vc1 = ctx?.viewController(forKey:.from)!
                    vc2 = ctx?.viewController(forKey:.to)!

                    r1start = ctx?.initialFrame(for:vc1)
                    r2end = ctx?.finalFrame(for:vc2)

                    v1 = ctx?.view(forKey:.from)!
                    v2 = ctx?.view(forKey:.to)!
                }
            }
        }

        switch g.state {
        case .began:
            if useContext {self.interacting = true}

            self.inter = UIPercentDrivenInteractiveTransition()
            // see animationEnded for cleanup
            let tbc = self.window!.rootViewController as! UITabBarController
            if g.edges == .right {
                tbc.selectedIndex = tbc.selectedIndex + 1
            } else {
                tbc.selectedIndex = tbc.selectedIndex - 1
            }
            if !useContext {fallthrough}
        case .changed:
            self.inter.update(percent)

            if useContext {
                let v = g.view!
                let delta = g.translation(in:v)
                let percent = abs(delta.x/v.bounds.size.width)
                self.anim?.fractionComplete = percent
                self.context?.updateInteractiveTransition(percent)
            }
        case .ended:
            print(self.inter.percentComplete) // zero, that's a bug
            if percent > 0.5 {
                self.inter.finish()
            } else {
                self.inter.cancel()
            }

            if useContext {
                /// this is the money shot! with a property animator, the whole notion of "hurry home" is easy - including "hurry back to start"

                if #available(iOS 10.0, *) {
                    let anim = self.anim as! UIViewPropertyAnimator
                    anim.pauseAnimation()

                    if anim.fractionComplete < 0.5 {
                        anim.isReversed = true
                    }
                    anim.continueAnimation(
                        withTimingParameters:
                        UICubicTimingParameters(animationCurve:.linear),
                        durationFactor: 0.2)
                } else {
                    // Fallback on earlier versions
                    if percent > 0.5 {
                        UIView.animate(withDuration: 0.2, animations:{
                            v1.frame = self.r1end
                            v2.frame = r2end
                        }, completion: { _ in
                            ctx?.finishInteractiveTransition()
                            ctx?.completeTransition(true)
                        })
                    }
                    else {
                        UIView.animate(withDuration: 0.2, animations:{
                            v1.frame = r1start
                            v2.frame = self.r2start
                        }, completion: { _ in
                            ctx?.cancelInteractiveTransition()
                            ctx?.completeTransition(false)
                        })
                    }
                    self.interacting = false
                    self.context = nil
                }
            }
        case .cancelled:
            self.inter.cancel()

            if useContext {
                self.anim?.pauseAnimation()
                self.anim?.stopAnimation(false)
                if #available(iOS 10.0, *) {
                    self.anim?.finishAnimation(at: .start)
                } else {
                    // Fallback on earlier versions
                    v1.frame = r1start
                    v2.frame = r2start

                    ctx?.cancelInteractiveTransition()
                    ctx?.completeTransition(false)
                    self.interacting = false
                    self.context = nil
                }
            }
        default: break
        }
    }
}


/// 当 useContext 为 true 时 采用 UIViewControllerContextTransitioning 协议
extension AppDelegate : UIViewControllerInteractiveTransitioning {

    // called if we are interactive (because we now have no percent driver)
    func startInteractiveTransition(_ ctx: UIViewControllerContextTransitioning){
        print("startInteractiveTransition")
        // store transition context so the gesture recognizer can get at it
        self.context = ctx

        // store the animator so the gesture recognizer can get at it
        self.anim = self.interruptibleAnimator(using: ctx)
    }
}


extension AppDelegate : UIViewControllerAnimatedTransitioning {
    // called if we are interactive (by percent driver)
    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        print("interruptibleAnimator")

        /// the trick is that this method may be called multiple times (it won't be in this example, but I'm trying to establish a general use pattern), so we use a property self.anim to establish a singleton for the life of the animation
        if self.anim != nil {
            return self.anim!
        }

        let vc1 = ctx.viewController(forKey:.from)!
        let vc2 = ctx.viewController(forKey:.to)!

        let con = ctx.containerView

        let r1start = ctx.initialFrame(for:vc1)
        let r2end = ctx.finalFrame(for:vc2)

        // new in iOS 8, use these instead of assuming that the views are the views of the vcs
        let v1 = ctx.view(forKey:.from)!
        let v2 = ctx.view(forKey:.to)!

        // which way we are going depends on which vc is which
        // the most general way to express this is in terms of index number
        let tbc = self.window!.rootViewController as! UITabBarController
        let ix1 = tbc.viewControllers!.index(of:vc1)!
        let ix2 = tbc.viewControllers!.index(of:vc2)!
        let dir : CGFloat = ix1 < ix2 ? 1 : -1
        var r1end = r1start
        r1end.origin.x -= r1end.size.width * dir
        var r2start = r2end
        r2start.origin.x += r2start.size.width * dir
        v2.frame = r2start
        con.addSubview(v2)

        /// interaction looks much better if animation curve is linear
        let _anim: UIViewImplicitlyAnimating!
        if #available(iOS 10.0, *) {
            _anim = UIViewPropertyAnimator(duration: 0.4, curve: .linear) {
                v1.frame = r1end
                v2.frame = r2end
            }
            if useContext {
                _anim.addCompletion! { finish in
                    if finish == .end {
                        ctx.finishInteractiveTransition()
                        ctx.completeTransition(true)
                    } else {
                        ctx.cancelInteractiveTransition()
                        ctx.completeTransition(false)
                    }
                }
            } else {
                _anim.addCompletion! { _ in
                    let cancelled = ctx.transitionWasCancelled
                    ctx.completeTransition(!cancelled)
                }

                if useContext {

                }
            }
        } else {
            /// TODO: test iOS 9 code

            // record initial conditions so the gesture recognizer can get at them
            self.r1end = r1end
            self.r2start = r2start

            let opts : UIViewAnimationOptions = self.interacting ? .curveLinear : []
            if !self.interacting {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            _anim = UIView.animate(withDuration: 0.4, delay:0, options:opts, animations: {
                v1.frame = r1end
                v2.frame = r2end
            }, completion: {
                _ in
                delay (0.1) { // needed to solve "black ghost" problem after partial gesture
                    let cancelled = ctx.transitionWasCancelled
                    ctx.completeTransition(!cancelled)
                    if UIApplication.shared.isIgnoringInteractionEvents {
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
            }) as! UIViewImplicitlyAnimating
        }

        self.anim = _anim
        print("creating animator")
        return _anim
    }

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        print("transitionDuration")
        return 0.4
    }

    // called if we are not interactive
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        print("animateTransition")
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        print("animation ended")
        self.interacting = false
        self.inter = nil // * cleanup!
        self.anim = nil
        self.context = nil
    }
}


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}
