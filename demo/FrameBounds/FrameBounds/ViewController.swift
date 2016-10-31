//
//  ViewController.swift
//  FrameBounds
//
//  Created by wangkan on 2016/10/31.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let which = 3
    var mainview: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mainview = self.view

        switch which {
        case 1:
            let v1 = UIView(frame:CGRect(x: 113, y: 111, width: 132, height: 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview?.addSubview(v1)
            v1.addSubview(v2)

        case 2:
            let v1 = UIView(frame:CGRect(x: 113, y: 111, width: 132, height: 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview?.addSubview(v1)
            v1.addSubview(v2)

            v2.bounds.size.height += 20
            v2.bounds.size.width += 20

        case 3:
            let v1 = UIView(frame:CGRect(x: 113, y: 111, width: 132, height: 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            let v2 = UIView(frame:v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview?.addSubview(v1)
            v1.addSubview(v2)

            v1.bounds.origin.x += 10
            v1.bounds.origin.y += 10

        default: break
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

