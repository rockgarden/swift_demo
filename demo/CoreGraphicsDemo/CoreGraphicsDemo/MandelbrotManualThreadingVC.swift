//
//  MandelbrotManualThreadingVC.swift
//  Draw
//

import UIKit

class MandelbrotManualThreadingVC: UIViewController {

    @IBOutlet var mv : MyMandelbrotViewMT!

    @IBAction func doButton (_ sender: Any!) {
        self.mv.drawThatPuppy()
    }

}

class MyMandelbrotViewMT : UIView {

    // best to run on device, because we want a slow processor in order to see the delay
    // you can increase the size of MANDELBROT_STEPS to make even more of a delay
    // but on my device, there's plenty of delay as is!

    let MANDELBROT_STEPS = 10000

    var bitmapContext: CGContext!
    var odd = false

    /*
     func drawThatPuppy () {
     self.makeBitmapContext(self.bounds.size)
     let center = CGPoint(self.bounds.midX, self.bounds.midY)
     self.drawAtCenter(center, zoom:1)
     self.setNeedsDisplay()
     }
     */

    // you can see we're now threaded, because the button unhighlights immediately

    // ==== changes begin

    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.makeBitmapContext(size:self.bounds.size)
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        let d : [AnyHashable:Any] = ["center":center, "zoom":CGFloat(1)]
        self.performSelector(inBackground: #selector(reallyDraw), with: d)
    }

    // trampoline, background thread entry point
    func reallyDraw(_ d: [AnyHashable:Any]) {
        autoreleasepool {
            self.draw(center:d["center"] as! CGPoint, zoom: d["zoom"] as! CGFloat)
            self.performSelector(onMainThread: #selector(allDone), with: nil, waitUntilDone: false)
        }
    }

    // called on main thread! background thread exit point
    func allDone() {
        self.setNeedsDisplay()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

    // ==== changes end

    // ==== this material is now called on background thread

    // create bitmap context
    func makeBitmapContext(size:CGSize) {
        var bitmapBytesPerRow = Int(size.width * 4)
        bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let prem = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
        self.bitmapContext = context
    }

    // draw pixels of bitmap context
    func draw(center:CGPoint, zoom:CGFloat) {
        func isInMandelbrotSet(_ re:Float, _ im:Float) -> Bool {
            var fl = true
            var (x, y, nx, ny) : (Float,Float,Float,Float) = (0,0,0,0)
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
        self.bitmapContext.setAllowsAntialiasing(false)
        self.bitmapContext.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
        var re : CGFloat
        var im : CGFloat
        let maxi = Int(self.bounds.size.width)
        let maxj = Int(self.bounds.size.height)
        for i in 0 ..< maxi {
            for j in 0 ..< maxj {
                re = (CGFloat(i) - 1.33 * center.x) / 160
                im = (CGFloat(j) - 1.0 * center.y) / 160
                re /= zoom
                im /= zoom
                if (isInMandelbrotSet(Float(re), Float(im))) {
                    self.bitmapContext.fill (CGRect(CGFloat(i), CGFloat(j), 1.0, 1.0))
                }
            }
        }
    }

    // ==== end of material called on background thread

    // turn pixels of bitmap context into CGImage, draw into ourselves
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
