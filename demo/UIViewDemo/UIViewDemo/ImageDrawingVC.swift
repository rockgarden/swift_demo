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

        let mars = UIImage(named:"Mars")!
        /// extract each half as CGImage
        let sz = mars.size
        let marsCG = mars.cgImage!
        let marsLeft = marsCG.cropping(to:CGRect(0,0,sz.width/2.0,sz.height))!
        let marsRight = marsCG.cropping(to: CGRect(sz.width/2.0,0,sz.width/2.0,sz.height))!

        // 1 ======
        do {
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*2, sz.height))
                self.iv1.image = r.image { _ in
                    mars.draw(at:CGPoint(0,0))
                    mars.draw(at:CGPoint(sz.width,0))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width*2, height: sz.height), false, 0)
                mars.draw(at: CGPoint(x: 0,y: 0))
                mars.draw(at: CGPoint(x: sz.width,y: 0))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.iv1.image = im
            }

        }

        // 2 ======
        do {
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*2, sz.height*2))
                self.iv2.image = r.image { _ in
                    mars.draw(in:CGRect(0,0,sz.width*2,sz.height*2))
                    mars.draw(in:CGRect(sz.width/2.0, sz.height/2.0, sz.width, sz.height), blendMode: .multiply, alpha: 1.0)
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width*2, height: sz.height*2), false, 0)
                mars.draw(in: CGRect(x: 0,y: 0,width: sz.width*2, height: sz.height*2))
                mars.draw(in: CGRect(x: sz.width/2.0, y: sz.height/2.0, width: sz.width, height: sz.height), blendMode: .multiply, alpha: 1.0)
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.iv2.image = im
            }
        }

        // 3 ======
        do {
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width/2.0, sz.height))
                self.iv3.image = r.image { _ in
                    mars.draw(at:CGPoint(-sz.width/2.0,0))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width/2.0, height: sz.height), false, 0)
                mars.draw(at: CGPoint(x: -sz.width/2.0,y: 0))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.iv3.image = im
            }
        }

        // 4 ======
        do {
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height))
                self.iv4.image = r.image { ctx in
                    let con = ctx.cgContext
                    con.draw(marsLeft, in:CGRect(0,0,sz.width/2.0,sz.height))
                    con.draw(marsRight, in:
                        CGRect(sz.width,0,sz.width/2.0,sz.height))
                }
            } else {
                // draw each CGImage
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width*1.5, height: sz.height), false, 0)
                let con = UIGraphicsGetCurrentContext()!
                con.draw(marsLeft, in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
                con.draw(marsRight, in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                // no memory management
                self.iv4.image = im
            }
            // flipped!
        }

        // 5 ======
        do {
            // draw each CGImage flipped
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height))
                self.iv5.image = r.image {
                    ctx in
                    let con = ctx.cgContext
                    con.draw(flip(marsLeft), in:
                        CGRect(0,0,sz.width/2.0,sz.height))
                    con.draw(flip(marsRight), in:
                        CGRect(sz.width,0,sz.width/2.0,sz.height))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width*1.5, height: sz.height), false, 0)
                let con = UIGraphicsGetCurrentContext()!
                con.draw(flip(marsLeft), in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
                con.draw(flip(marsRight), in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.iv5.image = im
            }
        }

        // 6 ======
        do {
            UIGraphicsBeginImageContextWithOptions(
                CGSize(sz.width*1.5, sz.height), false, 0)
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height))
                self.iv6.image = r.image {
                    ctx in
                    let con = ctx.cgContext
                    con.draw(flip(marsLeft), in:
                        CGRect(0,0,sz.width/2.0,sz.height))
                    con.draw(flip(marsRight), in:
                        CGRect(sz.width,0,sz.width/2.0,sz.height))
                }
            } else {
                // the rest as before, draw each CGImage flipped
                let con = UIGraphicsGetCurrentContext()!
                con.draw(flip(marsLeft), in: CGRect(x: 0,y: 0,width: sz.width/2.0,height: sz.height))
                con.draw(flip(marsRight), in: CGRect(x: sz.width,y: 0,width: sz.width/2.0,height: sz.height))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                // no memory management
                self.iv6.image = im
            }
        }

        // 7 ======
        do {
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(sz.width*1.5, sz.height))
                self.iv7.image = r.image {
                    _ in
                    UIImage(cgImage: marsLeft, scale: mars.scale,
                            orientation: mars.imageOrientation)
                        .draw(at:CGPoint(0,0))
                    UIImage(cgImage: marsRight, scale: mars.scale,
                            orientation: mars.imageOrientation)
                        .draw(at:CGPoint(sz.width,0))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(
                    CGSize(width: sz.width*1.5, height: sz.height), false, 0)
                // instead of calling flip, pass through UIImage
                UIImage(cgImage: marsLeft, scale: mars.scale,
                        orientation: mars.imageOrientation)
                    .draw(at: CGPoint(x: 0,y: 0))
                UIImage(cgImage: marsRight, scale: mars.scale,
                        orientation: mars.imageOrientation)
                    .draw(at: CGPoint(x: sz.width,y: 0))
                let im = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                // no memory management
                self.iv7.image = im
            }
        }
    }
}

func flip (_ im: CGImage) -> CGImage {

    let sz = CGSize(CGFloat(im.width), CGFloat(im.height))

    if #available(iOS 10.0, *) {
        let r = UIGraphicsImageRenderer(size:sz)
        return r.image { ctx in
            ctx.cgContext.draw(im, in:
                CGRect(0, 0, sz.width, sz.height))
            }.cgImage!
    } else {
        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
        UIGraphicsGetCurrentContext()!.draw(im, in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        return result!
    }
}

