//
//  AppDelegate.swift
//  CoreLocation_MapKit
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func lend<T> (_ closure: (T)->()) -> T where T:NSObject {
    let orig = T()
    closure(orig)
    return orig
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }


}

