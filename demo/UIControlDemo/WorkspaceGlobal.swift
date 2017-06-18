//
//  WorkspaceGlobal.swift
//
//
//  Created by wangkan on 2017/6/6.
//
//

import UIKit


// MARK: - Global func for workspace

func lend<T> (_ closure: (T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}

func dictionaryOfNames(_ arr:UIView...) -> [String:UIView] {
    var d = [String:UIView]()
    for (ix,v) in arr.enumerated() {
        d["v\(ix+1)"] = v
    }
    return d
}

func imageOfSize(_ size:CGSize, opaque:Bool = false, closure:@escaping () -> () ) -> UIImage {
    if #available(iOS 10.0, *) {
        let f = UIGraphicsImageRendererFormat.default()
        f.opaque = opaque
        let r = UIGraphicsImageRenderer(size: size, format: f)
        /// r.image 会传入 ctx = UIGraphicsImageRendererContext
        // TODO: ctx in let con = ctx.cgContext 与 UIGraphicsGetCurrentContext() 的区别.
        return r.image { _ in closure() }
    } else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        closure()
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}

func delay(_ delay: Double, closure: @escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func imageOfSizeClosure(_ size: CGSize, closure: @escaping (_ size: CGSize) -> () ) -> UIImage {
    if #available(iOS 10.0, *) {
        let r = UIGraphicsImageRenderer(size: size)
        return r.image { _ in closure(size) }
    } else {
        return imageFromContextOfSize(size, closure: closure)
    }
}

func imageFromContextOfSize(_ size: CGSize, closure: @escaping (_ size:CGSize) -> () ) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure(size)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

//func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
//    UIGraphicsBeginImageContextWithOptions(size, false, 0)
//    closure()
//    let result = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return result!
//}

// MARK: - Global class for workspace

class Wrapper<T> {
    let p:T
    init(_ p:T){self.p = p}
}


// MARK: - Global extension for workspace

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }

    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }

    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }

    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
    }

    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            self = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
        }
    }

    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            self = CGRect(x: x, y: newValue - height, width: width, height: height)
        }
    }

    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.x = newValue
        }
    }

    var right: CGFloat {
        get {
            return x + width
        }
        set {
            self = CGRect(x: newValue - width, y: y, width: width, height: height)
        }
    }

    var midX: CGFloat {
        get {
            return self.x + self.width / 2
        }
        set {
            self = CGRect(x: newValue - width / 2, y: y, width: width, height: height)
        }
    }

    var midY: CGFloat {
        get {
            return self.y + self.height / 2
        }
        set {
            self = CGRect(x: x, y: newValue - height / 2, width: width, height: height)
        }
    }

//    var center: CGPoint {
//        get {
//            return CGPoint(x: self.midX, y: self.midY)
//        }
//        set {
//            self = CGRect(x: newValue.x - width / 2, y: newValue.y - height / 2, width: width, height: height)
//        }
//    }

    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
}

extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }

    func sizeByDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
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

extension NSLayoutConstraint {
    class func reportAmbiguity (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared.keyWindow
        }
        for vv in v!.subviews {
            print("\(vv) \(vv.hasAmbiguousLayout)")
            if vv.subviews.count > 0 {
                self.reportAmbiguity(vv)
            }
        }
    }
    class func listConstraints (_ v:UIView?) {
        var v = v
        if v == nil {
            v = UIApplication.shared.keyWindow
        }
        for vv in v!.subviews {
            let arr1 = vv.constraintsAffectingLayout(for:.horizontal)
            let arr2 = vv.constraintsAffectingLayout(for:.vertical)
            NSLog("\n\n%@\nH: %@\nV:%@", vv, arr1, arr2);
            if vv.subviews.count > 0 {
                self.listConstraints(vv)
            }
        }
    }
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

extension Array {
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) {
            self.remove(at:i)
        }
    }
}

