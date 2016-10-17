//
//  ViewController.swift
//  UINavigationBar
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
func imageOfSize(size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var navbarA : UINavigationBar!
    var queryButton: UIButton {
        let button = UIButton(type: .Custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "manny"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "moe"), forState: .Selected)
        button.showsTouchWhenHighlighted = true
        button.addTarget(nil, action: #selector(pushNext), forControlEvents: .TouchUpInside)
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(pushNext))
        gr.minimumPressDuration = 1
        button.addGestureRecognizer(gr)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellowColor() // demonstrate translucency
        
        // new iOS 7 feature: replace the left-pointing chevron
        // very simple example
        
        self.navbar.backIndicatorImage =
            imageOfSize(CGSizeMake(10,20)) {
                CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(6,0,4,20))
        }
        self.navbar.backIndicatorTransitionMaskImage =
            imageOfSize(CGSizeMake(10,20)) {}
        
        // shadow, as in previous example
        
        let sz = CGSizeMake(20,20)
        
        self.navbar.setBackgroundImage(imageOfSize(sz) {
            UIColor(white:0.95, alpha:0.85).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(0,0,20,20))
            }, forBarPosition:.Any, barMetrics: .Default)
        
        do {
            let sz = CGSizeMake(4,4)
            self.navbar.shadowImage = imageOfSize(sz) {
                UIColor.grayColor().colorWithAlphaComponent(0.3).setFill()
                CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(0,0,4,2))
                UIColor.grayColor().colorWithAlphaComponent(0.15).setFill()
                CGContextFillRect(UIGraphicsGetCurrentContext()!, CGRectMake(0,2,4,2))
            }
        }
        
        self.navbar.translucent = true
        
        // set up initial state of nav item
        let item = UIBarButtonItem(customView: queryButton)
        let niA = UINavigationItem()
        niA.rightBarButtonItem = item
        self.navbarA.items = [niA]
        let ni = UINavigationItem(title: "Tinker")
        let b = UIBarButtonItem(title: "Evers", style: .Plain, target: self, action: #selector(pushNext))
        ni.rightBarButtonItem = b
        self.navbar.items = [ni]
    }
    
    func pushNext(sender:AnyObject) {
        let oldb = sender as! UIBarButtonItem
        let s = oldb.title! // *
        let ni = UINavigationItem(title:s)
        if s == "Evers" {
            let b = UIBarButtonItem(
                title:"Chance", style: .Plain, target:self, action:#selector(pushNext))
            ni.rightBarButtonItem = b
        }
        self.navbar.pushNavigationItem(ni, animated:true)
    }
}

extension ViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}