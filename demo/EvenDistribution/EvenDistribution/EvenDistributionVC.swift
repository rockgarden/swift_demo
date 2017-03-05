//
//  ViewController.swift
//  EvenDistribution
//
//  Created by wangkan on 2016/11/4.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class EvenDistributionVC: UIViewController {
    @IBOutlet var views : [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here") // put breakpoint here so we can pause and examine layout
    }

}

