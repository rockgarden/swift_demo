

import UIKit


// hit-testing on the non-transparent portion of a drawing
// (here, it's the black ellipse)

class HitTestDistortedLayerView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let lay = CALayer()
        lay.frame = self.layer.bounds
        self.layer.addSublayer(lay)
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(t)
    }
    
    @objc func tap() {
        print("tap")
    }
    
    override func draw(_ rect: CGRect) {
        guard let subs = self.layer.sublayers else {return}
        let lay = subs[subs.count-1]
        let im = imageOfSize(self.bounds.size) {
            let con = UIGraphicsGetCurrentContext()!
            let r = self.bounds.insetBy(dx: 30, dy: 30)
            con.saveGState()
            con.translateBy(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
            con.rotate(by: .pi/10.0)
            con.translateBy(x: -self.bounds.size.width/2.0, y: -self.bounds.size.height/2.0)
            con.fillEllipse(in:r)
            con.restoreGState()
        }
        lay.contents = im.cgImage
    }
    
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        let inside = self.point(inside:point, with:e)
        if !inside { return nil }
        
        guard let subs = self.layer.sublayers else {return nil}
        let im = imageOfSize(self.bounds.size) {
            let con = UIGraphicsGetCurrentContext()!
            let lay = subs[subs.count-1]
            lay.render(in:con)
        }
        
        let info = CGImageAlphaInfo.alphaOnly.rawValue
        let pixel = UnsafeMutablePointer<UInt8>.allocate(capacity:1)
        defer {
            pixel.deinitialize(count: 1)
            pixel.deallocate(capacity:1)
        }
        pixel[0] = 0
        let sp = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixel,
            width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 1,
            space: sp, bitmapInfo: info)!
        UIGraphicsPushContext(context)
        im.draw(at:CGPoint(-point.x, -point.y))
        UIGraphicsPopContext()
        let p = pixel[0]
        let alpha = Double(p)/255.0
        let transparent = alpha < 0.01
        return transparent ? nil : self
    }
    
}
