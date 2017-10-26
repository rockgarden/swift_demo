//
//  AppDelegate.swift
//  HomeKitDemo
//
//  Created by wangkan on 2017/10/26.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

/*
 https://mp.weixin.qq.com/s/neSSLxBAkCIWboLzOQ3YAQ
 https://github.com/ooper-shlab/HMCatalog-Swift3
 启用HomeKit
 1.你的App必须有签名验证，既在开发者平台配置AppID
 2.启用HomeKit在项目中，在Xcode中
 1）.选择View > Navigators > Show Project Navigator。
 2）.从Project/Targets弹出菜单中target（或者从Project/Targets的侧边栏）
 3）.点击Capabilities查看你可以添加的应用服务列表。
 4）.滑到HomeKit 所在的行并打开关。
 5）.官网上下载模拟器。
 6）.模拟器创建一个智能设备 New Accessory, 创建设备的服务并是指定随机特征 Add Service.
 基本概念
 1）.home（HMHome）
 home代表的是一个智能设备的住所，用户拥有Home的数据并通过自己的任何一台iOS设备访问，用户也可以和客户共享一个Home，但是客户的权限会有更多限制。在用户的所有home中，会有一个常用的home，即为primary home。被指定为primary home的home默认是Siri指令的对象，并且不能指定home，就是说primary home是只读的不能去设定。
 2）.room(HMRoom)
 每个Home一般有多个room，并且每个room一般会有多个智能配件。在home中，每个房间是独立的room，并具有一个有意义的名字，这个名字是唯一的。（home的名字也是唯一的）例如“卧室”或者“厨房”，这些名字可以在Siri 命令中使用。
 3）.accessory（HMAccessory）
 一个accessory代表一个家庭中的自动化设备，一个accessory的设备组成在于一个家庭，然后再指定到不同的room中，例如一个智能插座，一个智能灯具是是属于一个家庭，但是灯具可能被指定在厨房，而插座指定在卧室等。
 4）.sevice（HMSevice）
 一个sevice是accessory提供的一个实际服务，例如打开或者关闭灯泡。每个sevice中也会有多个特征（characteristic）。
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let vac = stor.instantiateViewController(withIdentifier: "ViewController")
        let nav = UINavigationController.init(rootViewController: vac)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
    
}

