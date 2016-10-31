//
//  ViewController.swift
//  UIVisualEffectView
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainview = self.view
        /**
         Demo for frame
         */
        let v1 = UIView(frame:CGRect(x: 113, y: 111, width: 132, height: 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView(frame:CGRect(x: 41, y: 56, width: 132, height: 194))
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView(frame:CGRect(x: 43, y: 197, width: 160, height: 230))
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        mainview?.addSubview(v1)
        v1.addSubview(v2)
        mainview?.addSubview(v3)

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blur.frame = (mainview?.bounds)!
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let vib = UIVisualEffectView(effect: UIVibrancyEffect(
            blurEffect: blur.effect as! UIBlurEffect))
        let lab = UILabel()
        lab.text = "Hello, world!"
        lab.sizeToFit()
        vib.frame = lab.frame
        vib.contentView.addSubview(lab)
        vib.center = CGPoint(x: blur.bounds.midX, y: blur.bounds.midY)
        vib.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                                .flexibleLeftMargin, .flexibleRightMargin]
        blur.contentView.addSubview(vib)
        mainview?.addSubview(blur)
    }

}



