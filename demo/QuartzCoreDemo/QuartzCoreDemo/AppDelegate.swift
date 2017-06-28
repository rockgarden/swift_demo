//
//  AppDelegate.swift
//  QuartzCoreDemo
//
//  Created by wangkan on 2017/6/1.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}

func getImageByContext(rect:CGRect, rad:CGFloat) -> UIImage {
    var im: UIImage!
    if #available(iOS 10.0, *) {
        let r = UIGraphicsImageRenderer(bounds:rect)
        im = r.image {
            ctx in
            let con = ctx.cgContext
            con.setFillColor(UIColor(white:0, alpha:0).cgColor)
            con.fill(rect)
            con.setFillColor(UIColor(white:0, alpha:1).cgColor)
            let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
            p.fill()
        }
    } else {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor(white:0, alpha:0).cgColor)
        con.fill(rect)
        con.setFillColor(UIColor(white:0, alpha:1).cgColor)
        let p = UIBezierPath(roundedRect:rect, cornerRadius:rad)
        p.fill()
        im = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    return im
}

func mask(size sz:CGSize, roundingCorners rad:CGFloat) -> CALayer {
    let rect = CGRect(origin:.zero, size:sz)
    let im = getImageByContext(rect: rect, rad: rad)
    let mask = CALayer()
    mask.frame = rect
    mask.contents = im.cgImage
    return mask
}

func viewMask(size sz:CGSize, roundingCorners rad:CGFloat) -> UIView {
    let rect = CGRect(origin:.zero, size:sz)
    let im = getImageByContext(rect: rect, rad: rad)
    let iv = UIImageView(frame:CGRect(origin: .zero, size: sz))
    iv.contentMode = .scaleToFill
    iv.image = im
    iv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    return iv
}
