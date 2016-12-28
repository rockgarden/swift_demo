//
//  TabBarVC.swift
//  TabBar
//
//  Created by wangkan on 2016/12/28.
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

class TabBarVC: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()

        // FIXME: 无效 tabBar set Background Image
        do {
            var im: UIImage?
            let sz = CGSize(20,20)
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:sz)
                im = r.image { ctx in
                    UIColor(white:0.95, alpha:0.85).setFill()
                    ctx.fill(CGRect(0,0,20,20)) }
            } else {
                im = imageOfSize(sz) {
                    UIColor(white:0.95, alpha:0.85).setFill()
                    UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz))
                }
            }
            _ = im //启用时删除
            self.tabBar.backgroundImage = im
        }

        // FIXME: 无效 tabBar add shadow
        do {
            var im: UIImage?
            let sz = CGSize(4,4)
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:sz)
                im = r.image { ctx in
                    UIColor.gray.withAlphaComponent(0.3).setFill()
                    ctx.fill(CGRect(0,0,4,2))
                    UIColor.gray.withAlphaComponent(0.15).setFill()
                    ctx.fill(CGRect(0,2,4,2))
                }
            } else {
                im = imageOfSize(sz) {
                    UIColor.gray.withAlphaComponent(0.3).setFill()
                    UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,4,2))
                    UIColor.gray.withAlphaComponent(0.15).setFill()
                    UIGraphicsGetCurrentContext()!.fill(CGRect(0,2,4,2))
                }
            }
            self.tabBar.shadowImage = im
        }
        // try false - effective only here
        self.tabBar.isTranslucent = true
    }
}

internal extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}

internal extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
            self.init(x:x, y:y, width:w, height:h)
    }
}

