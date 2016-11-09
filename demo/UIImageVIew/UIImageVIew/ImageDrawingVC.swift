//
//  ImageDrawingVC.swift
//  UIImageVIew
//
//  Created by wangkan on 2016/11/9.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ImageDrawingVC : UIViewController {
    
    @IBOutlet var iv1 : UIImageView!
    @IBOutlet var iv2 : UIImageView!
    @IBOutlet var iv3 : UIImageView!
    @IBOutlet var iv4 : UIImageView!
    @IBOutlet var iv5 : UIImageView!
    @IBOutlet var iv6 : UIImageView!
    @IBOutlet var iv7 : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*2, height: sz.height), false, 0)
            mars.draw(at: CGPoint(x: 0,y: 0))
            mars.draw(at: CGPoint(x: sz.width,y: 0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv1.image = im
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*2, height: sz.height*2), false, 0)
            mars.draw(in: CGRect(x: 0,y: 0,width: sz.width*2, height: sz.height*2))
            mars.draw(in: CGRect(x: sz.width/2.0, y: sz.height/2.0, width: sz.width, height: sz.height), blendMode: .multiply, alpha: 1.0)
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv2.image = im
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width/2.0, height: sz.height), false, 0)
            mars.draw(at: CGPoint(x: -sz.width/2.0,y: 0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.iv3.image = im
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let marsCG = mars.cgImage
            let sz = mars.size
            let marsLeft = marsCG?.cropping(to: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
            let marsRight = marsCG?.cropping(to: CGRect(x: sz.width/2.0,y: 0,width: sz.width/2.0,height: sz.height))
            // draw each CGImage
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*1.5, height: sz.height), false, 0)
            let con = UIGraphicsGetCurrentContext()!
            con.draw(marsLeft!, in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
            con.draw(marsRight!, in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv4.image = im
            // flipped!
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            // extract each half as CGImage
            let sz = mars.size
            let marsCG = mars.cgImage
            let marsLeft = marsCG?.cropping(to: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
            let marsRight = marsCG?.cropping(to: CGRect(x: sz.width/2.0,y: 0,width: sz.width/2.0,height: sz.height))
            // draw each CGImage flipped
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*1.5, height: sz.height), false, 0)
            let con = UIGraphicsGetCurrentContext()!
            con.draw(flip(marsLeft!), in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
            con.draw(flip(marsRight!), in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv5.image = im
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.cgImage
            let szCG = CGSize(width: CGFloat((marsCG?.width)!), height: CGFloat((marsCG?.height)!))
            let marsLeft =
                marsCG?.cropping(to: CGRect(x: 0,y: 0,width: szCG.width/2.0,height: szCG.height))
            let marsRight =
                marsCG?.cropping(to: CGRect(x: szCG.width/2.0,y: 0,width: szCG.width/2.0,height: szCG.height))
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*1.5, height: sz.height), false, 0)
            // the rest as before, draw each CGImage flipped
            let con = UIGraphicsGetCurrentContext()!
            con.draw(flip(marsLeft!), in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
            con.draw(flip(marsRight!), in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv6.image = im
        }

        // ======

        do {
            let mars = UIImage(named:"Mars")!
            let sz = mars.size
            let marsCG = mars.cgImage
            let szCG = CGSize(width: CGFloat((marsCG?.width)!), height: CGFloat((marsCG?.height)!))
            let marsLeft =
                marsCG?.cropping(to: CGRect(x: 0,y: 0,width: szCG.width/2.0,height: szCG.height))
            let marsRight =
                marsCG?.cropping(to: CGRect(x: szCG.width/2.0,y: 0,width: szCG.width/2.0,height: szCG.height))
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: sz.width*1.5, height: sz.height), false, 0)
            // instead of calling flip, pass through UIImage
            UIImage(cgImage: marsLeft!, scale: mars.scale,
                    orientation: mars.imageOrientation)
                .draw(at: CGPoint(x: 0,y: 0))
            UIImage(cgImage: marsRight!, scale: mars.scale,
                    orientation: mars.imageOrientation)
                .draw(at: CGPoint(x: sz.width,y: 0))
            let im = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // no memory management
            self.iv7.image = im
        }

    }

}

func flip (_ im: CGImage) -> CGImage {
    let sz = CGSize(width: CGFloat(im.width), height: CGFloat(im.height))
    UIGraphicsBeginImageContextWithOptions(sz, false, 0)
    UIGraphicsGetCurrentContext()!.draw(im, in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))
    let result = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
    UIGraphicsEndImageContext()
    return result!
}

