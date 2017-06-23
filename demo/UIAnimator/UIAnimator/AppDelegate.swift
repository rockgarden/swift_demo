//
//  AppDelegate.swift
//  UIAnimator
//
//  Created by wangkan on 2017/3/6.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
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


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


extension UIView {
    class func animate(times:Int,
                       duration dur: TimeInterval,
                       delay del: TimeInterval,
                       options opts: UIViewAnimationOptions,
                       animations anim: @escaping () -> Void,
                       completion comp: ((Bool) -> Void)?) {
        func helper(_ t:Int,
                    _ dur: TimeInterval,
                    _ del: TimeInterval,
                    _ opt: UIViewAnimationOptions,
                    _ anim: @escaping () -> Void,
                    _ com: ((Bool) -> Void)?) {
            UIView.animate(withDuration: dur,
                           delay: del, options: opt,
                           animations: anim, completion: {
                            done in
                            if com != nil {
                                com!(done)
                            }
                            if t > 0 {
                                delay(0) {
                                    helper(t-1, dur, del, opt, anim, com)
                                }
                            }
            })
        }
        helper(times-1, dur, del, opts, anim, comp)
    }
}



