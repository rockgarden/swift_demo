
import UIKit

/*
 An example of how the tracking methods are useful when subclassing an existing UIControl subclass.
*/

/// Slider Bubble
class MySlider: UISlider {
    var bubbleView : UIView!
    weak var label : UILabel?

    /// NSNumberFormatter的实例格式化包含NSNumber对象的单元格的文本表示，并将数值的文本表示转换为NSNumber对象。 该表示包括整数，浮点和双精度; 浮点数和双精度可以格式化为指定的小数位。 NSNumberFormatter对象还可以对单元格可以接受的数值施加范围。
    let formatter : NumberFormatter = {
        let n = NumberFormatter()
        n.maximumFractionDigits = 1
        return n
    }()
    
    override func didMoveToSuperview() {
        bubbleView = UIView(frame:CGRect(0,0,80,60))
        let h = bubbleView.frame.height
        let w = bubbleView.frame.width

        let im = imageOfSize(CGSize(w,h)) {
            let con = UIGraphicsGetCurrentContext()!
            let p = UIBezierPath(roundedRect: CGRect(0,0,100,80), cornerRadius: 10)
            p.move(to: CGPoint(45,80))
            p.addLine(to: CGPoint(50,90))
            p.addLine(to: CGPoint(55,80))
            con.addPath(p.cgPath)
            UIColor.blue.setFill()
            con.fillPath()
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
