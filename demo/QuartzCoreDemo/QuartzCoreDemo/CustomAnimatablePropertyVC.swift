
import UIKit


class CustomAnimatablePropertyVC : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var v1 : UIView!

    @IBAction func doButton1 (_ sender: Any) {
        let lay = self.v1.layer as! MyLayer1
        let cur = lay.thickness1
        let val : CGFloat = cur == 10 ? 0 : 10
        CATransaction.setDisableActions(true)
        lay.thickness1 = val
        let ba = CABasicAnimation(keyPath:#keyPath(MyLayer1.thickness1))
        ba.fromValue = cur
        lay.add(ba, forKey:nil)
    }

    @IBAction func doButton2 (_ sender: Any) {
        let lay = self.v1.layer as! MyLayer1
        let cur = lay.thickness1
        let val : CGFloat = cur == 10 ? 0 : 10
        lay.thickness1 = val // implicit animation
    }

    @IBAction func doButton (_ sender: Any) {
        let lay = self.v.layer as! CAPLayer
        let cur = lay.thickness
        let val : CGFloat = cur == 10 ? 0 : 10
        lay.thickness = val
        let ba = CABasicAnimation(keyPath:#keyPath(CAPLayer.thickness))
        ba.fromValue = cur
        lay.add(ba, forKey:nil)
    }
    
}


class MyView : UIView {
    override class var layerClass : AnyClass {
        return CAPLayer.self
    }
    override func draw(_ rect: CGRect) {} //so that layer will draw itself
}


fileprivate class CAPLayer : CALayer {

    var thickness : CGFloat = 0

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(thickness) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }

    override func draw(in con: CGContext) {
        let r = self.bounds.insetBy(dx:0, dy:0)
        con.setFillColor(UIColor.red.cgColor)
        con.fill(r)
        con.setLineWidth(self.thickness)
        con.setStrokeColor(UIColor.green.cgColor)
        con.stroke(r)
    }

}


class MyView1 : UIView {
    override class var layerClass : AnyClass {
        return MyLayer1.self
    }
    override func draw(_ rect: CGRect) {}
}

// see also Nick Lockwood's discussion http://www.objc.io/issue-12/animating-custom-layer-properties.html

/*
 // copied from Apple's example, but I don't see how it helps in this situation

 -(id)initWithLayer:(id)layer {
 self = [super initWithLayer:layer];
 if ([layer isKindOfClass:[MyLayer class]])
 self.thickness = ((MyLayer*)layer).thickness;
 return self;
 }
 */

class MyLayer1 : CALayer {

    /// @NSManaged acts as Objective-C @dynamic
    @NSManaged var thickness1 : CGFloat

    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(thickness1) {
            return true
        }
        return super.needsDisplay(forKey:key)
    }

    override func draw(in con: CGContext) {
        let r = self.bounds.insetBy(dx:20, dy:20)
        con.setFillColor(UIColor.red.cgColor)
        con.fill(r)
        con.setLineWidth(self.thickness1)
        con.setStrokeColor(UIColor.yellow.cgColor)
        con.stroke(r)
    }

    /// this plus the "dynamic" declaration is what what permits *implicit* animation, we can implicitly animate even for view's underlying layer?
    override func action(forKey key: String) -> CAAction? {
        if key == #keyPath(thickness1) {
            let ba = CABasicAnimation(keyPath: key)
            ba.fromValue = self.presentation()!.value(forKey:key)
            return ba
        }
        return super.action(forKey:key)
    }
}
