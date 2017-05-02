//
//  AppDelegate.swift
//  CoreMotionDemo
//
//  Created by wangkan on 2017/5/2.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let motionManager = CMMotionManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Enumerate through the view controller hierarchy, setting the `motionManager`
        // property on those that conform to the `MotionGraphContainer` protocol.
        window?.rootViewController?.enumerateHierarchy { viewController in
            guard var container = viewController as? MotionGraphContainer else { return }
            container.motionManager = motionManager
        }
        
        return true
    }

}

