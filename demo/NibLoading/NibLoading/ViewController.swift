//
//  ViewController.swift
//  NibLoading
//
//  Created by wangkan on 2016/10/27.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var coolview : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let arr = Bundle.main.loadNibNamed("View", owner: nil, options: nil)
        let v0 = arr?[0] as! UIView
        let v1 = arr?[1] as! UIView
        self.view.addSubview(v0)
        self.view.addSubview(v1)

        Bundle.main.loadNibNamed("CoolView", owner: self, options: nil)
        v1.addSubview(self.coolview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

