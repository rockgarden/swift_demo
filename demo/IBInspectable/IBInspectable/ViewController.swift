//
//  ViewController.swift
//  IBInspectable
//
//  Created by wangkan on 2016/9/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rb: RedButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rb?.borderColor = UIColor.brownColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

