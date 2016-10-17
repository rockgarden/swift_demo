
//  Mandelbrot drawing code based on https://github.com/ddeville/Mandelbrot-set-on-iPhone

import UIKit

class MandelbrotView: UIView {
    
    var bitmapContext: CGContext!
    var odd = false
    /// instance NSOperationQueue
    let queue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    func drawThatPuppy () {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let op = MandelbrotOperation(size: self.bounds.size, center: center, zoom: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(operationFinished), name: NSNotification.Name(rawValue: "MyMandelbrotOperationFinished"), object: op)
        self.queue.addOperation(op)
    }
    
    // warning! called on background thread
    func operationFinished(_ n: Notification) {
        if let op = n.object as? MandelbrotOperation {
            // 在主派发队列中更新UI
            DispatchQueue.main.async {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "MyMandelbrotOperationFinished"), object: op)
                self.bitmapContext = op.bitmapContext
                self.setNeedsDisplay()
            }
        }
    }
    
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
    
    deinit {
        self.queue.cancelAllOperations()
    }
    
}
