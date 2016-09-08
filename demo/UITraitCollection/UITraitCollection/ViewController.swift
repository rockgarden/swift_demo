//
//  ViewController.swift
//  UITraitCollection
//
//  Created by wangkan on 16/9/8.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // simple example of lying to a child view controller about its trait environment
    // notice that the embedded version of ViewController2 is missing the Dismiss button!
    // that's because it thinks it has a Compact horizontal size class...
    // ...which is configured with a different interface in the storyboard
    
    override func viewDidLoad() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CompactHorizontalVC")
        self.addChildViewController(vc) // "will" called for us
        //let tc = UITraitCollection(horizontalSizeClass: .Compact)
        let tc = UITraitCollection(displayScale: 0.4)
        self.setOverrideTraitCollection(tc, forChildViewController: vc)
        vc.view.frame = CGRectMake(100, 100, 200, 200)
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }

}

