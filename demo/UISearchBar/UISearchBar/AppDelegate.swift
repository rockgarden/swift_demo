//
//  AppDelegate.swift
//  UISearchBar
//
//  Created by wangkan on 2016/9/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}



func prepareData(sectionNames: inout [String], cellData: inout [[String]]) {
    let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!, encoding: String.Encoding.utf8)
    let states = s.components(separatedBy:"\n")
    var previous = ""
    for aState in states {
        // get the first letter
        let c = String(aState.characters.prefix(1))
        // only add a letter to sectionNames when it's a different letter
        if c != previous {
            previous = c
            sectionNames.append(c.uppercased())
            //Add new subarray to our array of subarrays
            cellData.append([String]())
        }
        cellData[cellData.count-1].append(aState)
    }
}
