//
//  ViewController.swift
//  BundleResource
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iv3: UIImageView!
    @IBOutlet weak var iv4: UIImageView!
    @IBOutlet weak var iv5: UIImageView!
    @IBOutlet weak var iv6: UIImageView!

    @IBOutlet weak var iv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.iv.image!.scale)

        self.iv3.image = UIImage(named:"one")
        self.iv4.image = UIImage(named:"uno")

        if let s = Bundle.main.path(forResource: "one", ofType: "png") {
            self.iv5.image = UIImage(contentsOfFile: s)
        }
        if let s2 = Bundle.main.path(forResource: "uno", ofType: "png") {
            self.iv6.image = UIImage(contentsOfFile: s2)
        } else {
            print("looking for smiley")
            self.iv6.image = UIImage(named:"smiley")
        }

    }
    
}

