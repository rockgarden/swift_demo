//
//  AppDelegate.swift
//  TodayExtension
//
//  Created by wangkan on 2016/10/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

/// 要知道插件和主应用是独立的两个进程,现在可以通过AppGroup来共享数据,同属于一个group的App共同访问并修改某个数据.
/// 创建Group:选中主应用的Target，选择Capabilities，创建一个group，名字叫group.xxx，然后到插件的target勾选刚才创建的groupk.
/// NSUserDefaults.initWithSuiteName:@"group.xxx"];
/// userDefault setObject:@"nmj" forKey:@"group.huijia.nickname"];


import UIKit

//func delay(_ delay:Double, closure:@escaping ()->()) {
//    DispatchQueue.main.asyncAfter(
//        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
//}

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {        return true
    }

    /// 解析协议,进行不同的操作,分别跳转到主应用的不同页面,通过OpenUrl方法
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let scheme = url.scheme
        let host = url.host
        if scheme == "coffeetime" {
            if let host = host, let min = Int(host) {
                print("got \(min) from our today extension")
                return true
            }
        }
//        else if([action isEqualToString:@"GotoOrderPage"]) {
//            BasicHomeViewController *vc = (BasicHomeViewController*)self.window.rootViewController;
//            [vc.tabbar selectAtIndex:2];
//        }
        return false
    }

}

