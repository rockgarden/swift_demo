//
//  ViewController.swift
//  Func
//
//  Created by wangkan on 2016/11/14.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Local IP \(get_ifaddrs_list())")
        print("Remote IP \(remoteIP("http://www.open-open.com/news/view/54640313"))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

