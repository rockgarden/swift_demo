
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit

/// No thread MV
class MandelbrotView : UIView {

    // you can increase the size of MANDELBROT_STEPS to make even more of a delay
    let MANDELBROT_STEPS = 15000
    
    var bitmapContext: CGContext!
    var odd = false
    
    // jumping-off point: draw the Mandelbrot set
    func drawThatPuppy () {
        self.makeBitmapContext(size: self.bounds.size)
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        self.draw(center: center, zoom:1)
        self.setNeedsDisplay()
    }
    
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
    func draw(center: CGPoint, zoom: CGFloat) {
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


/// Manual Threading MV
class MTMandelbrotView : MandelbrotView {

    // ==== changes begin

    /// 禁止响应UI?
    override func drawThatPuppy () {
        UIApplication.shared.beginIgnoringInteractionEvents()
        self.makeBitmapContext(size:self.bounds.size)
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        let d : [AnyHashable:Any] = ["center":center, "zoom":CGFloat(1)]
        self.performSelector(inBackground: #selector(reallyDraw), with: d)
    }

    // background thread entry point
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
    // draw pixels of bitmap context
    // ==== end of material called on background thread

}


/// Operation MV
class OPMandelbrotView : MandelbrotView {

    let queue : OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()

    override func drawThatPuppy () {
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        let op = MandelbrotOperation(size: self.bounds.size, center: center, zoom: 1, step: MANDELBROT_STEPS)
        NotificationCenter.default.addObserver(self, selector: #selector(operationFinished), name: .mandelOpFinished, object: op)
        self.queue.addOperation(op)
    }

    // warning! called on background thread
    func operationFinished(_ n:Notification) {
        if let op = n.object as? MandelbrotOperation {
            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(self, name: .mandelOpFinished, object: op)
                self.bitmapContext = op.bitmapContext
                self.setNeedsDisplay()
            }
        }
    }

    deinit {
        self.queue.cancelAllOperations()
    }

}


/// GCD MV
class GCDMandelbrotView : MandelbrotView {

    let draw_queue : DispatchQueue = {
        let q = DispatchQueue(label: "com.rockgarden.mandeldraw")
        return q
    }()
    
    override func drawThatPuppy () {
        //self.makeBitmapContext(size: CGSize.zero) // test "wrong thread" assertion
        /// to test backgrounding running, increase MANDELBROT_STEPS and suspend while calculating
        var bti : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        bti = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(bti)
        }
        guard bti != UIBackgroundTaskInvalid else { return }
        let center = CGPoint(self.bounds.midX, self.bounds.midY)
        self.draw_queue.async {
            let bitmap = self.makeBitmapReturnContext(self.bounds.size)
            self.draw(center: center, zoom:1, context:bitmap)
            DispatchQueue.main.async {
                // testing crash
                // self.assertOnBackgroundThread() // crash! :)

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

        /// much nicer way to do this, we can drop use of setSpecific and getSpecific
        dispatchPrecondition(condition: .onQueue(self.draw_queue))
    }


    // create and return context
    func makeBitmapReturnContext(_ size:CGSize) -> CGContext { // *
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
    
}
