//
//  ViewController.swift
//  GCDConcurrencyThreadDemo
//
//  Created by wangkan on 2017/7/2.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class MandelbrotVC: UIViewController {

    @IBOutlet var mv : MandelbrotView!
    @IBOutlet var mtmv : MTMandelbrotView!
    @IBOutlet var opmv : OPMandelbrotView!

    @IBAction func doButton (_ sender: Any!) {
        let tag = (sender as! UIButton).tag
        switch tag {
        case 1001:
            self.mv.drawThatPuppy()
        case 1002:
            self.mtmv.drawThatPuppy()
        case 1003:
            self.opmv.drawThatPuppy()
        default:
            break
        }
    }

}

