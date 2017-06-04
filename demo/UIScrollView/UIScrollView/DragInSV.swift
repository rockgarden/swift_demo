
import UIKit

//TODO: Use Constraint
class DragInSV : UIViewController {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var flag : UIImageView!
    @IBOutlet weak var map: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sv.contentSize = map.bounds.size
    }
    
    @IBAction func dragging (_ p: UIPanGestureRecognizer) {
        let v = p.view!
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in:v.superview!)
            v.center.x += delta.x
            v.center.y += delta.y
            p.setTranslation(.zero, in: v.superview)
            if p.state == .changed {fallthrough} // comment out to prevent autoscroll
        case .changed:
            // autoscroll
            let sv = self.sv!
            let loc = p.location(in:sv)
            let f = sv.bounds
            var off = sv.contentOffset
            let sz = sv.contentSize
            var c = v.center
            // to the right
            if loc.x > f.maxX - 30 {
                let margin = sz.width - sv.bounds.maxX
                if margin > 6 {
                    off.x += 5
                    sv.contentOffset = off
                    c.x += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the left
            if loc.x < f.origin.x + 30 {
                let margin = off.x
                if margin > 6 {
                    off.x -= 5
                    sv.contentOffset = off
                    c.x -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the bottom
            if loc.y > f.maxY - 30 {
                let margin = sz.height - sv.bounds.maxY
                if margin > 6 {
                    off.y += 5
                    sv.contentOffset = off
                    c.y += 5
                    v.center = c
                    self.keepDragging(p)
                }
            }
            // to the top
            if loc.y < f.origin.y + 30 {
                let margin = off.y
                if margin > 6 {
                    off.y -= 5
                    sv.contentOffset = off
                    c.y -= 5
                    v.center = c
                    self.keepDragging(p)
                }
            }

        default: break
        }
    }
    
    func keepDragging (_ p: UIPanGestureRecognizer) {
        // the delay here, combined with the change in offset, determines the speed of autoscrolling
        let del = 0.1
        delay(del) {
            self.dragging(p)
        }
    }
    
}

class MyFlagView : UIImageView {
    // use our hit test from chapter 5 so that user must tap actual flag drawing
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        let inside = self.point(inside: point, with:event)
        if !inside { return nil }

        var im: UIImage!

        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:self.bounds.size)
            im = r.image {
                ctx in let con = ctx.cgContext
                let lay = self.layer
                lay.render(in:con)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            let lay = self.layer
            lay.render(in:UIGraphicsGetCurrentContext()!)
            im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        let info = CGImageAlphaInfo.alphaOnly.rawValue
        let pixel = UnsafeMutablePointer<UInt8>.allocate(capacity:1)
        defer {
            pixel.deinitialize(count: 1)
            pixel.deallocate(capacity:1)
        }
        pixel[0] = 0
        let sp = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 1, space: sp, bitmapInfo: info)!
        UIGraphicsPushContext(context)
        im.draw(at:CGPoint(-point.x, -point.y))
        UIGraphicsPopContext()
        let p = pixel[0]
        let alpha = Double(p)/255.0
        let transparent = alpha < 0.01
        return transparent ? nil : self
    }
}
