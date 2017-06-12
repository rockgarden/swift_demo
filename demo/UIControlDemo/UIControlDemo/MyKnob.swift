
import UIKit

class MyKnob: UIControl {
    var angle : CGFloat = 0 {
        didSet {
            if angle < 0 {
                angle = 0
            }
            if angle > 5 {
                angle = 5
            }
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    var isContinuous = false
    private var initialAngle : CGFloat = 0

    func pToA (_ t:UITouch) -> CGFloat {
        let loc = t.location(in: self)
        let c = CGPoint(self.bounds.midX, self.bounds.midY)
        return atan2(loc.y - c.y, loc.x - c.x)
    }
    
    override func beginTracking(_ t: UITouch, with _: UIEvent?) -> Bool {
        initialAngle = pToA(t)
        return true
    }
    
    override func continueTracking(_ t: UITouch, with _: UIEvent?) -> Bool {
        let ang = pToA(t) - initialAngle
        let absoluteAngle = angle + ang
        // 在switch中实现不平等
        switch absoluteAngle {
        case -CGFloat.infinity...0:
            angle = 0
            sendActions(for: .valueChanged)
            return false
        case 5...CGFloat.infinity:
            angle = 5
            sendActions(for: .valueChanged)
            return false
        default:
            angle = absoluteAngle
            if isContinuous {
                sendActions(for: .valueChanged)
            }
            return true
        }

        //self.transform = self.transform.rotated(by: ang)
    }
    
    override func endTracking(_: UITouch?, with _: UIEvent?) {
        sendActions(for: .valueChanged)
    }
    
    override func draw(_ rect: CGRect) {
        UIImage(named:"knob")!.draw(in: rect)
    }
    
}
