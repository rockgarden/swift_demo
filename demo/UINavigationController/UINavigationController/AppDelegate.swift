//
//  AppDelegate.swift
//  UINavigationController
//
//  Created by wangkan on 2016/9/26.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController = UITabBarController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// return exampleCodeInit()
        
        self.window!.tintColor = UIColor.orange // gag... Just proving this is inherited
        
        /// nav bar is configured (horribly) in the storyboard and now for some even more disgusting decoration
        
        let im = UIImage(named:"linen.png")!
        let sz = CGSize(width: 5,height: 34)
        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
        im.draw(at: CGPoint(x: -55,y: -55))
        let im2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let im3 = im2?.resizableImage(withCapInsets: UIEdgeInsetsMake(0,0,0,0), resizingMode:.tile)
        UIBarButtonItem.appearance().setBackgroundImage(im3, for:UIControlState(), barMetrics:.default)
        
        /// if the back button is assigned a background image, the chevron is removed entirely
        /// UIBarButtonItem.appearance().setBackButtonBackgroundImage(im3, forState: .Normal, barMetrics: .Default)
        
        /// also, note that if the back button is assigned a background image, it is not vertically resized and if it has an image, that image is resized to fit
        return true
    }
    
}

