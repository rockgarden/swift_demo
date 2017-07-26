//
//  AppDelegate.swift
//  UITraitCollection
//
//  Created by wangkan on 16/9/8.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // FIXME: 无效！
    /// Trick to work around launch incoherency to do a landscape launch but permit portrait later...
    /// don't include portrait in the _Info.plist_ but permit it here
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }

}


extension UIUserInterfaceSizeClass : CustomStringConvertible {
    public var description : String {
        if self == .compact {return "compact"}
        if self == .regular {return "regular"}
        return "unknown"
    }
}


extension UITraitCollection {
    open override var description : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
    }
    open override var debugDescription : String {
        return "\(self.horizontalSizeClass) \(self.verticalSizeClass)"
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

