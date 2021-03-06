//
//  ViewController.swift
//  UINavigationBar
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class TestCustomNavBarVC: UIViewController {
    @IBOutlet var navbar : UINavigationBar!
    @IBOutlet var navbarA : UINavigationBar!

    @IBOutlet var toolbar : UIToolbar!

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

        view.backgroundColor = .yellow //证明navBar半透明度 demonstrate translucency

        /// 自定义 UINavigationBar 返回图标: new iOS 7 feature: replace the left-pointing chevron
        do {
            let sz = CGSize(10,20)

            self.navbar.backIndicatorImage = imageOfSize(sz) {
                UIGraphicsGetCurrentContext()!.fill(CGRect(x: 6,y: 0,width: 4,height: 20))
            }
            self.navbar.backIndicatorTransitionMaskImage = imageOfSize(sz) {}
        }

        // shadow, as in previous example
        do {
            let sz = CGSize(width: 20,height: 20)
            self.navbar.setBackgroundImage(imageOfSize(sz) {
                UIColor(white:0.95, alpha:0.85).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,20,20))
            }, for:.any, barMetrics: .default)
            self.toolbar.setBackgroundImage(imageOfSize(sz) {
                UIColor(white:0.95, alpha:0.85).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,20,20))
            }, forToolbarPosition:.any, barMetrics: .default)
        }

        do {
            let sz = CGSize(width: 4,height: 4)
            self.navbar.shadowImage = imageOfSize(sz) {
                let ctx = UIGraphicsGetCurrentContext()!
                UIColor.gray.withAlphaComponent(0.3).setFill()
                ctx.fill(CGRect(0,0,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                ctx.fill(CGRect(0,2,4,2))
            }
            self.toolbar.setShadowImage( imageOfSize(sz) {
                UIColor.gray.withAlphaComponent(0.3).setFill()
                let ctx = UIGraphicsGetCurrentContext()!
                ctx.fill(CGRect(0,2,4,2))
                UIColor.gray.withAlphaComponent(0.15).setFill()
                ctx.fill(CGRect(0,0,4,2))
            }, forToolbarPosition:.any )
        }

        self.navbar.isTranslucent = true
        self.toolbar.isTranslucent = true

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
        let s = oldb.title!
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
        switch true {
        case bar === self.navbar: return .topAttached
        case bar === self.navbarA: return .bottom
        default: return .any
        }
    }
}
