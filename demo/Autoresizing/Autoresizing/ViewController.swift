//
//  ViewController.swift
//  Autoresizing
//
//  Created by wangkan on 2016/11/4.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v1 = UIView(frame:CGRect(x: 100, y: 111, width: 132, height: 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView(frame:CGRect(x: 0, y: 0, width: 132, height: 10))
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView(frame:CGRect(x: v1.bounds.width-20, y: v1.bounds.height-20, width: 20, height: 20))
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(v1)
        v1.addSubview(v2)
        v1.addSubview(v3)

        v2.autoresizingMask = .flexibleWidth
        v3.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]


        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
            //            v1.frame = mainview.bounds
            //            v1.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            print(v2)
            print(v3)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

