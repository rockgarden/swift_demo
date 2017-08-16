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


// MARK: - CheckAccess func for workspace
import MediaPlayer
import AVFoundation
import Photos

func checkForMusicLibraryAccess(andThen f:(()->())? = nil) {
    if #available(iOS 9.3, *) {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            f?()
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        f?()
                    }
                }
            }
        case .restricted:
            // do nothing
            break
        case .denied:
            // do nothing, or beg the user to authorize us in Settings
            break
        }
    } else {
        // Fallback on earlier versions
    }
    
}

func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}

func checkForMicrophoneCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(forMediaType:AVMediaTypeAudio) { granted in
            if granted {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        let alert = UIAlertController(
            title: "Need Authorization",
            message: "Wouldn't you like to authorize this app " +
            "to use the microphone?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "No", style: .cancel))
        alert.addAction(UIAlertAction(
        title: "OK", style: .default) {
            _ in
            let url = URL(string:UIApplicationOpenSettingsURLString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
        })
        UIApplication.shared.delegate!.window!!.rootViewController!.present(alert, animated:true)
    }
}

func checkForMovieCaptureAccess(andThen f:(()->())? = nil) {
    let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeVideo)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        AVCaptureDevice.requestAccess(forMediaType:AVMediaTypeVideo) { granted in
            if granted {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        let alert = UIAlertController(
            title: "Need Authorization",
            message: "Wouldn't you like to authorize this app " +
            "to use the camera?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "No", style: .cancel))
        alert.addAction(UIAlertAction(
        title: "OK", style: .default) {
            _ in
            let url = URL(string:UIApplicationOpenSettingsURLString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
        })
        UIApplication.shared.delegate!.window!!.rootViewController!.present(alert, animated:true)
    }
}


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
    class func animateWithTimes(_ times: Int,
                                duration dur: TimeInterval,
                                delay del: TimeInterval,
                                options opts: UIViewAnimationOptions,
                                animations anim: @escaping () -> Void,
                                completion comp: ((Bool) -> Void)?) {
        func helper(_ t: Int,
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
                                    helper(t - 1, dur, del, opt, anim, com)
                                }
                            }
            })
        }
        helper(times - 1, dur, del, opts, anim, comp)
    }
    
//    class func animate(times:Int,
//                       duration dur: TimeInterval,
//                       delay del: TimeInterval,
//                       options opts: UIViewAnimationOptions,
//                       animations anim: @escaping () -> Void,
//                       completion comp: ((Bool) -> Void)?) {
//        func helper(_ t:Int,
//                    _ dur: TimeInterval,
//                    _ del: TimeInterval,
//                    _ opt: UIViewAnimationOptions,
//                    _ anim: @escaping () -> Void,
//                    _ com: ((Bool) -> Void)?) {
//            UIView.animate(withDuration: dur,
//                           delay: del, options: opt,
//                           animations: anim, completion: {
//                            done in
//                            if com != nil {
//                                com!(done)
//                            }
//                            if t > 0 {
//                                delay(0) {
//                                    helper(t-1, dur, del, opt, anim, com)
//                                }
//                            }
//            })
//        }
//        helper(times-1, dur, del, opts, anim, comp)
//    }
}


extension Array {
    mutating func remove(at ixs:Set<Int>) -> () {
        for i in Array<Int>(ixs).sorted(by:>) {
            self.remove(at:i)
        }
    }
}


extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        //self(cgImage: (image?.cgImage!)!)
    }
    
    convenience init(color: UIColor, rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}


/// https://github.com/devxoul/Then
public protocol Then {}
extension Then where Self: Any {
    
    /// Makes it available to set properties with closures just after initializing and copying the value types.
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    public func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do`(_ block: (Self) -> Void) {
        block(self)
    }
}
extension Then where Self: AnyObject {
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///       $0.textAlignment = .Center
    ///       $0.textColor = UIColor.blackColor()
    ///       $0.text = "Hello, World!"
    ///     }
    public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}

