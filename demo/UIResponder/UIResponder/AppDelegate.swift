//
//  AppDelegate.swift
//  UIResponder
//
//  Created by wangkan on 2016/11/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    /// 返回一个布尔值，指示接收者是否实现或继承可以响应指定消息的方法。
    /// 应用程序负责确定错误响应是否应被视为错误。
    /// 您无法通过使用super关键字向对象发送respond（to :)来测试对象是否从其超类继承方法。 这种方法仍然将测试对象作为一个整体，而不仅仅是超类的实现。 因此，发送响应（对:)到超级相当于将其发送给自己。 相反，您必须直接在对象的超类上调用NSObject类方法instancesRespond（to :).
    /// 您不能简单地使用[[self superclass] instancesRespondToSelector：@selector（aMethod）]，因为如果子类调用该方法可能会导致该方法失败。
    /// 请注意，如果接收方能够将aSelector消息转发到另一个对象，则即使该方法返回false，也可以间接响应该消息。
    override func responds(to aSelector: Selector) -> Bool {
        print(aSelector)
        return super.responds(to: aSelector)
    }

}


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
