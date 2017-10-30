/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 The `TabBarController` maintains the state of the tabs across app launches.
 */
import UIKit

/**
 Saves the current state of the tab so that the app will always open to the
 appropriate tab on launch.
 */
class TabBarController: UITabBarController {
    // MARK: Types
    
    static let startingTabIndexKey = "TabBarController-StartingTabIndexKey"
    
    // MARK: View Methods
    
    // Load the current tab from `NSUserDefaults`.
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        
        let startingIndex = userDefaults.object(forKey: TabBarController.startingTabIndexKey) as? Int ?? 2

        selectedIndex = startingIndex
    }
    
    // MARK: Tab Bar Methods
    
    /// Save the current selected tab into defaults.
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBarItems = tabBar.items, let index = tabBarItems.index(of: item) {

            let userDefaults = UserDefaults.standard
            
            userDefaults.set(index, forKey: TabBarController.startingTabIndexKey)
        }
    }
}
