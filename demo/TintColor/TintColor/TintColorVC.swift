//
//  ViewController.swift
//  TintColor
//
//  Created by wangkan on 2016/12/25.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class TintColorVC: UIViewController {

    var blue = true

    @IBAction func doToggleTint(_ sender: Any) {
        self.blue = !self.blue
        self.view.tintColor = self.blue ? nil : UIColor.red
    }

    var dim = false

    @IBAction func doToggleDimming(_ sender: Any) {
        self.dim = !self.dim
        self.view.tintAdjustmentMode = self.dim ? .dimmed : .automatic
    }

}

