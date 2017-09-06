//
//  KVOBlockDemo.swift
//  KVO_KVC
//
//  Created by wangkan on 2017/2/20.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.observeKeyPath("frame") { (target, old, new) in

        }
    }
    
}
