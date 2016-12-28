

import UIKit

/*
 An example of how the tracking methods are useful when subclassing an existing UIControl subclass.
*/


class MySlider: UISlider {
    var bubbleView : UIView!
    weak var label : UILabel?
    let formatter : NumberFormatter = {
        let n = NumberFormatter()
        n.maximumFractionDigits = 1
        return n
    }()
    
    override func didMoveToSuperview() {
        bubbleView = UIView(frame:CGRect(0,0,80,60))
        let h = bubbleView.frame.height
        let w = bubbleView.frame.width

        let im: UIImage
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:CGSize(w,h))
            im = r.image {
                ctx in let con = ctx.cgContext
                let p = UIBezierPath(roundedRect: CGRect(0,0,w,h-15), cornerRadius: 10)
                p.move(to: CGPoint(w/2-4,h-15))
                p.addLine(to: CGPoint(w/2,h))
                p.addLine(to: CGPoint(w/2+4,h-15))
                con.addPath(p.cgPath)
                UIColor.blue.setFill()
                con.fillPath()
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(100,90), false, 0)
            let con = UIGraphicsGetCurrentContext()!
            let p = UIBezierPath(roundedRect: CGRect(0,0,100,80), cornerRadius: 10)
            p.move(to: CGPoint(45,80))
            p.addLine(to: CGPoint(50,90))
            p.addLine(to: CGPoint(55,80))
            con.addPath(p.cgPath)
            UIColor.blue.setFill()
            con.fillPath()
            im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        let iv = UIImageView(image: im)
        self.bubbleView.addSubview(iv)
        
        let lab = UILabel(frame:CGRect(0,0,w,h-20))
        lab.numberOfLines = 1
        lab.textAlignment = .center
        lab.font = UIFont(name:"GillSans-Bold", size:20)
        lab.textColor = .white
        self.bubbleView.addSubview(lab)
        self.label = lab
        
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let r = super.thumbRect(forBounds:bounds, trackRect: rect, value: value)
        self.bubbleView?.frame.origin.x =
            r.origin.x + (r.size.width/2.0) - (self.bubbleView.frame.size.width/2.0)
        self.bubbleView?.frame.origin.y =
            r.origin.y - 85
        return r
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let bool = super.beginTracking(touch, with: event)
        if bool {
            self.addSubview(self.bubbleView)
            self.label?.text = self.formatter.string(from:self.value as NSNumber)
        }
        return bool
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let bool = super.continueTracking(touch, with:event)
        if bool {
            self.label?.text = self.formatter.string(from:self.value as NSNumber)
        }
        return bool
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.endTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        self.bubbleView?.removeFromSuperview()
        super.cancelTracking(with:event)
    }
    

}
