//
//  ViewController.swift
//  UniversalDemo
//
//  Created by wangkan on 2017/7/3.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()

        let iv = UIImageView(image: UIImage(named:"Image")!)
        iv.frame.origin = CGPoint(x:10,y:150)
        self.view.addSubview(iv)

        let device = self.traitCollection.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        print(device)

        let d = Dog()
        let dd = d //breakpoint here and hover over d
        print(dd)
    }

}


private class Dog {

    @objc func debugQuickLookObject() -> Any {
        // displaying a dog as a square
        return UIBezierPath(rect: CGRect(x:0, y:0, width:100, height:100))
    }

}
