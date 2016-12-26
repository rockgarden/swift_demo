//
//  ViewController.swift
//  UINavigationBar
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}

class TestCustomNavBarVC: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var navbarA : UINavigationBar!
    var queryButton: UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "manny"), for: UIControlState())
        button.setBackgroundImage(UIImage(named: "moe"), for: .selected)
        button.showsTouchWhenHighlighted = true
        button.addTarget(nil, action: #selector(pushNextA), for: .touchUpInside)
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(pushNextA_lp))
        gr.minimumPressDuration = 1
        button.addGestureRecognizer(gr)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow // demonstrate translucency
        
        // new iOS 7 feature: replace the left-pointing chevron
        // very simple example

        do {
            let sz = CGSize(10,20)
            if #available(iOS 10.0, *) {
                self.navbar.backIndicatorImage =
                    UIGraphicsImageRenderer(size:sz).image { ctx in
                        ctx.fill(CGRect(6,0,4,20))
                }
                self.navbar.backIndicatorTransitionMaskImage =
                    UIGraphicsImageRenderer(size:sz).image {_ in}
            } else {
                self.navbar.backIndicatorImage =
                    imageOfSize(CGSize(width: 10,height: 20)) {
                        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 6,y: 0,width: 4,height: 20))
                }
                self.navbar.backIndicatorTransitionMaskImage =
                    imageOfSize(CGSize(width: 10,height: 20)) {}
            }
        }

        
        // shadow, as in previous example
        
        let sz = CGSize(width: 20,height: 20)
        if #available(iOS 10.0, *) {
            self.navbar.setBackgroundImage(UIGraphicsImageRenderer(size:sz).image { ctx in
                UIColor(white:0.95, alpha:0.85).setFill()
                ctx.fill(CGRect(0,0,20,20))
            }, for:.any, barMetrics: .default)
        } else {
            self.navbar.setBackgroundImage(imageOfSize(sz) {
                UIColor(white:0.95, alpha:0.85).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0,y: 0,width: 20,height: 20))
            }, for:.any, barMetrics: .default)
        }
        
        do {
            let sz = CGSize(width: 4,height: 4)

            if #available(iOS 10.0, *) {
                self.navbar.shadowImage = UIGraphicsImageRenderer(size:sz).image { ctx in
                    UIColor.gray.withAlphaComponent(0.3).setFill()
                    ctx.fill(CGRect(0,0,4,2))
                    UIColor.gray.withAlphaComponent(0.15).setFill()
                    ctx.fill(CGRect(0,2,4,2))
                }
            } else {
                self.navbar.shadowImage = imageOfSize(sz) {
                    UIColor.gray.withAlphaComponent(0.3).setFill()
                    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0,y: 0,width: 4,height: 2))
                    UIColor.gray.withAlphaComponent(0.15).setFill()
                    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0,y: 2,width: 4,height: 2))
                }
            }
        }
        
        self.navbar.isTranslucent = true
        
        // set up initial state of nav item
        let item = UIBarButtonItem(customView: queryButton)
        let niA = UINavigationItem(title: "")
        niA.rightBarButtonItem = item
        self.navbarA.items = [niA]

        let ni = UINavigationItem(title: "Tinker")
        let b = UIBarButtonItem(title: "Evers", style: .plain, target: self, action: #selector(pushNext))
        ni.rightBarButtonItem = b
        self.navbar.items = [ni]
    }
    
    func pushNext(_ sender: Any) {
        debugPrint(sender)
        let oldb = sender as! UIBarButtonItem
        let s = oldb.title! // *
        let ni = UINavigationItem(title: s)
        if s == "Evers" {
            let b = UIBarButtonItem(
                title:"Chance", style: .plain, target:self, action:#selector(pushNext))
            ni.rightBarButtonItem = b
        }
        self.navbar.pushItem(ni, animated:true)
    }

    func pushNextA(_ sender: Any) {
        debugPrint(sender)
        let oldb = sender as! UIButton
        let s = oldb.title(for: .normal) ?? "No title"
        let ni = UINavigationItem(title: s)
        if s == "Evers" {
            let b = UIBarButtonItem(
                title:"Chance", style: .plain, target:self, action:#selector(pushNextA))
            ni.rightBarButtonItem = b
        }
        self.navbarA.pushItem(ni, animated:true)
    }

    func pushNextA_lp(_ sender: Any) {
        debugPrint(sender)
        let lp = sender as! UILongPressGestureRecognizer
        let oldb = lp.view as! UIButton
        let s = oldb.title(for: .selected) ?? "No title"
        let ni = UINavigationItem(title: s)
        if s == "Evers" {
            let b = UIBarButtonItem(
                title:"Chance", style: .plain, target:self, action:#selector(pushNextA))
            ni.rightBarButtonItem = b
        }
        self.navbarA.pushItem(ni, animated:true)
    }
}

extension TestCustomNavBarVC : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
