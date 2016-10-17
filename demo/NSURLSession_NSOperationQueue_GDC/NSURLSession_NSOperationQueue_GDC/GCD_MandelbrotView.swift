//
//  GCD_MandelbrotView.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit

class SomeClass {
    private lazy var __once: () = {
            // this code will run just once in the life of this object
        }()
    var once_token: Int = 0
    func test() {
        _ = self.__once
    }
}

let qkeyString = "label" as NSString
let QKEY = DispatchSpecificKey<String>() //qkeyString.utf8String
let qvalString = "com.neuburg.mandeldraw" as NSString
//???
var QVAL = String(describing: qvalString.utf8String)

class GCD_MandelbrotView: UIView {
    
    // best to run on device, because we want a slow processor in order to see the delay
    // you can increase the size of MANDELBROT_STEPS to make even more of a delay
    // but on my device, there's plenty of delay as is!
    
    let MANDELBROT_STEPS = 200
    
    var bitmapContext: CGContext!
    let draw_queue: DispatchQueue = {
        let q = DispatchQueue(label: QVAL, attributes: [])
        q.setSpecific(key: /*Migrator FIXME: Use a variable of type DispatchSpecificKey*/ QKEY, value: QVAL)
        return q
    }()
    
    var odd = false
    
    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        // self.makeBitmapContext(CGSizeZero) // test "wrong thread" assertion
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        // to test, increase MANDELBROT_STEPS and suspend while still calculating
        var bti: UIBackgroundTaskIdentifier = 0
        bti = UIApplication.shared
            .beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(bti)
            })
        if bti == UIBackgroundTaskInvalid {
            return
        }
        self.draw_queue.async {
            let bitmap = self.makeBitmapContext(self.bounds.size)
            self.drawAtCenter(center, zoom: 1, context: bitmap)
            DispatchQueue.main.async {
                self.bitmapContext = bitmap
                self.setNeedsDisplay()
                UIApplication.shared.endBackgroundTask(bti)
            }
        }
    }
    
    // ==== this material is called on background thread
    
    func assertOnBackgroundThread() {
        let s = DispatchQueue.getSpecific(key: QKEY)
        assert(s == QVAL)
    }
    
    // create and return context
    func makeBitmapContext(_ size: CGSize) -> CGContext { // *
        self.assertOnBackgroundThread()
        
        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
        return context!
    }
    
    // NB do NOT refer to self.bitmapContext here!
    func drawAtCenter(_ center: CGPoint, zoom: CGFloat, context: CGContext) {
        
        func isInMandelbrotSet(_ re: Float, _ im: Float) -> Bool {
            var fl = true
            var (x, y, nx, ny): (Float, Float, Float, Float) = (0, 0, 0, 0)
            for _ in 0 ..< MANDELBROT_STEPS {
                nx = x * x - y * y + re
                ny = 2 * x * y + im
                if nx * nx + ny * ny > 4 {
                    fl = false
                    break
                }
                x = nx
                y = ny
            }
            return fl
        }
        
        self.assertOnBackgroundThread()
        
        context.setAllowsAntialiasing(false) // *
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1) // *
        var re: CGFloat
        var im: CGFloat
        let maxi = Int(self.bounds.size.width) // really shouldn't be doing these...
        let maxj = Int(self.bounds.size.height) // ...on background thread?
        for i in 0 ..< maxi {
            for j in 0 ..< maxj {
                re = (CGFloat(i) - 1.33 * center.x) / 160
                im = (CGFloat(j) - 1.0 * center.y) / 160
                
                re /= zoom
                im /= zoom
                
                if (isInMandelbrotSet(Float(re), Float(im))) {
                    context.fill (CGRect(x: CGFloat(i), y: CGFloat(j), width: 1.0, height: 1.0)) // *
                }
            }
        }
    }
    
    // ==== end of material called on background thread
    
    // turn pixels of self.bitmapContext into CGImage, draw into ourselves
    
    override func draw(_ rect: CGRect) {
        if self.bitmapContext != nil {
            let context = UIGraphicsGetCurrentContext()!
            let im = self.bitmapContext.makeImage()
            context.draw(im!, in: self.bounds)
            self.odd = !self.odd
            self.backgroundColor = self.odd ? UIColor.green : UIColor.red
        }
    }
    
}

