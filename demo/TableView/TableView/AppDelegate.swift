//
//  AppDelegate.swift
//  TableView
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.window = UIWindow()
//        let sBoard = UIStoryboard(name: "Main", bundle: nil)
        // "UISearchControllerVC" -- table search simaple
        // "RJExpandTable" -- expand table simple
        // "DynamicTable" -- sections expand
        // "MasterViewController" -- Table With Dynamic Type
//        let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier("UISearchControllerVC")
//        self.window!.rootViewController = UINavigationController(rootViewController: vController)
//        self.window!.backgroundColor = UIColor.whiteColor()
//        self.window!.makeKeyAndVisible()
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
