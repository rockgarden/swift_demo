//
//  AppDelegate.swift
//  CoreImageDemo
//
//  Created by wangkan on 2017/6/4.
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


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func imageFromContextOfSize(_ size: CGSize, closure: @escaping(_ size:CGSize) -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure(size)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

func imageOfSize(_ size: CGSize, closure: @escaping (_ size:CGSize) -> ()) -> UIImage {
    if #available(iOS 10.0, *) {
        let r = UIGraphicsImageRenderer(size:size)
        return r.image {
            _ in closure(size)
        }
    } else {
        return imageFromContextOfSize(size, closure: closure)
    }
}
