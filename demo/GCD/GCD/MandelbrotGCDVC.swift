//
//  MandelbrotGCDVC.swift
//  GCD
//
//  Created by wangkan on 2016/11/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import AVFoundation

struct Oncer2 {
    private static var once : Void = {
        print("I did it too!")
    }()
    func doThisOnce() {
        _ = type(of:self).once
    }
}
let oncer2 = Oncer2()


class MandelbrotGCDVC: UIViewController {

    @IBOutlet var mv: MandelbrotGCD!

    @IBAction func doButton (_ sender: Any!) {
        mv.drawThatPuppy()
    }

    struct Oncer {
        private static var once : Void = {
            print("I did it!")
        }()
        func doThisOnce() {
            _ = type(of:self).once
        }
    }
    let oncer = Oncer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testOnce()
        self.testDispatchGroups()
    }

    func testOnce() {
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
    }

    func testDispatchGroups() {
        DispatchQueue.global(qos: .background).async {
            let queue = DispatchQueue(label:"com.rockgarden.GCD", attributes:.concurrent)
            let group = DispatchGroup()

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 1")
                    group.leave()
                }
            }

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 2")
                    group.leave()
                }
            }

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 3")
                    group.leave()
                }
            }

            group.notify(queue: DispatchQueue.main) {
                print("All async calls were run!")
            }
        }
    }
}

// not used, just testing syntax

class AssetTester : NSObject {
    let assetQueue = DispatchQueue(label: "testing.testing")
    func getAssetInternal() -> AVAsset {
        return AVAsset()
    }
    func asset() -> AVAsset? {
        var theAsset : AVAsset!
        self.assetQueue.sync {
            theAsset = self.getAssetInternal().copy() as! AVAsset
        }
        return theAsset
    }
}


//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone
import UIKit

//TODO: 要 @IBOutlet 所以无法 private ?
class MandelbrotGCD: UIView {

    let MANDELBROT_STEPS = 1000

    var bitmapContext: CGContext!
    let draw_queue : DispatchQueue = {
        let q = DispatchQueue(label: "com.neuburg.mandeldraw")
        return q
    }()

    var odd = false

    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        // self.makeBitmapContext(CGSize.zero) // test "wrong thread" assertion
        // to test backgrounding, increase MANDELBROT_STEPS and suspend while calculating
        var bti: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bti = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(bti)
        }
        guard bti != UIBackgroundTaskInvalid else { return }
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        self.draw_queue.async {
            let bitmap = self.makeBitmapContext(size: self.bounds.size)
            self.draw(center: center, zoom:1, context:bitmap)
            DispatchQueue.main.async {
                // testing crash
                //self.assertOnBackgroundThread()
                self.bitmapContext = bitmap
                self.setNeedsDisplay()
                UIApplication.shared.endBackgroundTask(bti)
            }
        }
    }

    // ==== this material is called on background thread

    func assertOnBackgroundThread() {
        //let s = DispatchQueue.getSpecific(key: qKey)
        //assert(s == qVal)

        // woohoo! much nicer way to do this, we can drop use of setSpecific and getSpecific
        dispatchPrecondition(condition: .onQueue(self.draw_queue))
    }


    // create and return context
    func makeBitmapContext(size:CGSize) -> CGContext { // *
        self.assertOnBackgroundThread()

        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
        return context!
    }

    // NB do NOT refer to self.bitmapContext here!
    func draw(center:CGPoint, zoom:CGFloat, context:CGContext) {

        func isInMandelbrotSet(_ re:Float, _ im:Float) -> Bool {
            var fl = true
            var (x, y, nx, ny) : (Float, Float, Float, Float) = (0,0,0,0)
            for _ in 0 ..< MANDELBROT_STEPS {
                nx = x*x - y*y + re
                ny = 2*x*y + im
                if nx*nx + ny*ny > 4 {
                    fl = false
                    break
                }
                x = nx
                y = ny
            }
            return fl
        }


        self.assertOnBackgroundThread()

        context.setAllowsAntialiasing(false)
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
        var re : CGFloat
        var im : CGFloat
        let maxi = Int(self.bounds.size.width) // really shouldn't be doing these...
        let maxj = Int(self.bounds.size.height) // ...on background thread?
        for i in 0 ..< maxi {
            for j in 0 ..< maxj {
                re = (CGFloat(i) - 1.33 * center.x) / 160
                im = (CGFloat(j) - 1.0 * center.y) / 160

                re /= zoom
                im /= zoom

                if (isInMandelbrotSet(Float(re), Float(im))) {
                    context.fill (CGRect(CGFloat(i), CGFloat(j), 1.0, 1.0))
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
            self.backgroundColor = self.odd ? .green : .red
        }
    }
    
}

