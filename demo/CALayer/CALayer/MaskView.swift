//
//  ViewController.swift
//  CALayer
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MaskView : UIViewController {
    @IBOutlet fileprivate var box: UIView!
    
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

        setupBox()
    }
    
    func setupBox() {
        // Creating rounder corners
        box.layer.cornerRadius = 10
        
        // Adding shadow effects
        box.layer.shadowOffset = CGSize(width: 5, height: 5) //偏移量 右侧 5 个点以及下方 5 个点
        box.layer.shadowOpacity = 0.7
        box.layer.shadowRadius = 5
        box.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        
        // Applying borders
        box.layer.borderColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        box.layer.borderWidth = 3
        
        // Display images
        box.layer.contents = UIImage(named: "tree.jpg")?.cgImage //使用文件名 tree.jpg 创建了一个 UIImage 对象，然后把它传给了图层的 contents 属性。
        box.layer.contentsGravity = kCAGravityResize //设置图层的内容重心来调整大小，这意味着图层中的所有内容将被调整大小以便完美地适应图层的尺寸。
        box.layer.masksToBounds = true //以便图层中任何延伸到边界外的子图层都会在边界处被剪裁。
    }
}


