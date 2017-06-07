//
//  AppNavigationVC.swift
//  UISearchBar
//
//  Created by wangkan on 2017/6/7.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class AppNavigationVC: UINavigationController {

    override var prefersStatusBarHidden : Bool {
        return topViewController?.prefersStatusBarHidden ?? true
    }

}
