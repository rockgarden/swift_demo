//
//  ViewController.swift
//  CALayer
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MaskView : UIViewController {
    
    func maskOfSize(_ sz:CGSize, roundingCorners rad:CGFloat) -> CALayer {
        let r = CGRect(origin:CGPoint.zero, size:sz)
        UIGraphicsBeginImageContextWithOptions(r.size, false, 0)
        let con = UIGraphicsGetCurrentContext()!
        con.setFillColor(UIColor(white:0, alpha:0).cgColor)
        con.fill(r)
        con.setFillColor(UIColor(white:0, alpha:1).cgColor)
        let p = UIBezierPath(roundedRect:r, cornerRadius:rad)
        p.fill()
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let mask = CALayer()
        mask.frame = r
        mask.contents = im?.cgImage
        return mask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainview = self.view
        let lay = CALayer()
        lay.frame = (mainview?.layer.bounds)!
        mainview?.layer.addSublayer(lay)
        
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(x: 113, y: 111, width: 132, height: 194)
        lay.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(x: 41, y: 56, width: 132, height: 194)
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(x: 43, y: 197, width: 160, height: 230)
        lay.addSublayer(lay3)
        
        let mask = self.maskOfSize(CGSize(width: 100,height: 100), roundingCorners: 20)
        mask.frame.origin = CGPoint(x: 110,y: 160)
        lay.mask = mask
        // lay.setValue(mask, forKey: "mask")
    }
    
}


