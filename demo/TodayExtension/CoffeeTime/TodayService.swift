//
//  TodayService.swift
//  TodayExtension
//
//  Created by wangkan on 2016/10/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation
let TaskServiceDataKey = "TodayData"

public struct TodayService {
    public static let TodayGroupName = "group.***"
    
    public static func addItem(title:String){
        /// -initWithSuiteName: initializes an instance of NSUserDefaults that searches the shared preferences search list for the domain 'suitename'. For example, using the identifier of an application group will cause the receiver to search the preferences for that group. Passing the current application's bundle identifier, NSGlobalDomain, or the corresponding CFPreferences constants is an error. Passing nil will search the default search list.
        let userDefault = UserDefaults(suiteName: TodayService.TodayGroupName)
        var items = self.getItems()
        items.append(title)
        userDefault?.set(items, forKey: TaskServiceDataKey)
        userDefault?.synchronize()
    }
    
    public static func removeItem(title:String){
        let items = self.getItems()
        let newItems = items.filter { (item) -> Bool in
            item != title
        }
        let userDefault = UserDefaults(suiteName: TodayService.TodayGroupName)
        userDefault?.set(newItems, forKey: TaskServiceDataKey)
        userDefault?.synchronize()
    }
    
    public static func getItems() -> [String]{
        let userDefault = UserDefaults(suiteName: TodayService.TodayGroupName)
        var tasks = [String]()
        if let array = userDefault?.stringArray(forKey: TaskServiceDataKey) {
            tasks = array
        }
        return tasks
    }
    
}
