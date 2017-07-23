
import UIKit

// view exists solely to host layer
class CompassView : UIView {
    override class var layerClass : AnyClass {
        return CompassLayer.self
    }
}

class BaseCompassView : UIView {
    
    override class var layerClass : AnyClass {
        return BaseCompassLayer.self
    }

    // view makes layer tappable
    @IBAction func tapped(_ t:UITapGestureRecognizer) {
        let p = t.location(ofTouch:0, in: self.superview)
        let hitLayer = layer.hitTest(p)
        let arrow = (layer as! BaseCompassLayer).arrow!
        if hitLayer == arrow { // respond to touch
            arrow.transform = CATransform3DRotate(
                arrow.transform, .pi/4.0, 0, 0, 1)
        }
    }
}


class BaseCompassLayer : CALayer, CALayerDelegate {
    var arrow : CALayer?
    var rotationLayer : CALayer!
    var didSetup = false

    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }

    /// ??? do what?
    override func hitTest(_ p: CGPoint) -> CALayer? {
        var lay = super.hitTest(p)
        if lay == self.arrow {
            // 人为地将接触性限制在大致的轴/点区域, artificially restrict touchability to roughly the shaft/point area
            let pt = self.arrow?.convert(p, from:superlayer)
            let path = CGMutablePath()
            path.addRect(CGRect(10,20,20,80))
            path.move(to:CGPoint(0,25))
            path.addLine(to:CGPoint(20,0))
            path.addLine(to:CGPoint(40,25))
            path.closeSubpath()
            if !path.contains(pt!, using: .winding) {
                lay = nil
            }
            let result = lay != nil ? "hit" : "missed"
            debugPrint("\(result) arrow at \(String(describing: pt))")
        }
        return lay
    }

    func setup () {
        debugPrint("setup")

        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [
            UIColor.black.cgColor,
            UIColor.red.cgColor
        ]
        g.locations = [0.0,1.0]
        self.addSublayer(g) //

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        self.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center

        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.characters.enumerated() {
            let t = CATextLayer()
            t.contentsScale = UIScreen.main.scale
            t.string = String(c)
            t.bounds = CGRect(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(0.5, vert)
            //print(t.anchorPoint)
            t.alignmentMode = kCAAlignmentCenter
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(CGAffineTransform(rotationAngle:CGFloat(ix) * .pi/2.0))
            circle.addSublayer(t)
        }


        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(0, 0, 40, 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(0.5, 0.8)
        arrow.delegate = self // we will draw the arrow in the delegate method
        // in Swift, not a property:
        arrow.setAffineTransform(CGAffineTransform(rotationAngle:.pi/5.0))
        self.addSublayer(arrow)
        arrow.setNeedsDisplay() // draw, please

        self.arrow = arrow

    }

    func draw(_ layer: CALayer, in con: CGContext) {
        print("drawLayer:inContext: for arrow")

        // punch triangular hole in context clipping region
        con.move(to: CGPoint(10,100))
        con.addLine(to: CGPoint(20,90))
        con.addLine(to: CGPoint(30,100))
        con.closePath()
        con.addRect(con.boundingBoxOfClipPath)
        con.clip(using: .evenOdd)

        // draw the vertical line, add its shape to the clipping region
        con.move(to: CGPoint(20,100))
        con.addLine(to: CGPoint(20,19))
        con.setLineWidth(20)
        con.strokePath()

        // draw the triangle, the point of the arrow
        let stripes = imageOfSize(CGSize(4,4)) {
            ctx in
            let imcon = UIGraphicsGetCurrentContext()!
            imcon.setFillColor(UIColor.red.cgColor)
            imcon.fill(CGRect(0,0,4,4))
            imcon.setFillColor(UIColor.blue.cgColor)
            imcon.fill(CGRect(0,0,4,2))
        }

        let stripesPattern = UIColor(patternImage:stripes)

        UIGraphicsPushContext(con)
        do {
            stripesPattern.setFill()
            let p = UIBezierPath()
            p.move(to:CGPoint(0,25))
            p.addLine(to:CGPoint(20,0))
            p.addLine(to:CGPoint(40,25))
            p.fill()
        }
        UIGraphicsPopContext()
    }
}


class CompassLayer : BaseCompassLayer {
    var circle : CAShapeLayer?
    var gradientLayer: CAGradientLayer!
    var which = 1

    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
            delay(2) {
                self.doRotate ()
            }
        }
    }

    override func setup () {
        print("setup")

        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [
            UIColor.black.cgColor,
            UIColor.red.cgColor
        ]
        g.locations = [0.0,1.0]
        self.addSublayer(g)
        self.gradientLayer = g

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        self.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center

        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.characters.enumerated() {
            let t = CATextLayer()
            t.contentsScale = UIScreen.main.scale
            t.string = String(c)
            t.bounds = CGRect(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(0.5, vert)
            //print(t.anchorPoint)
            t.alignmentMode = kCAAlignmentCenter
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(CGAffineTransform(rotationAngle:CGFloat(ix) * .pi/2.0))
            circle.addSublayer(t)
        }

        self.circle = circle


        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(0, 0, 40, 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(0.5, 0.8)
        arrow.delegate = self // we will draw the arrow in the delegate method
        // in Swift, not a property:
        arrow.setAffineTransform(CGAffineTransform(rotationAngle:.pi/5.0))
        self.addSublayer(arrow)
        arrow.setNeedsDisplay()

        // uncomment next line (only) for contentsCenter and contentsGravity
        delay (1) {self.resizeArrowLayer(arrow)}

        // uncomment next line (only) for layer mask
        self.mask(arrow:arrow)

        self.arrow = arrow
    }

    func resizeArrowLayer(_ arrow:CALayer) {
        print("resize arrow")
        arrow.needsDisplayOnBoundsChange = false
        arrow.contentsCenter = CGRect(0.0, 0.4, 1.0, 0.6)
        arrow.contentsGravity = kCAGravityResizeAspect
        arrow.bounds = arrow.bounds.insetBy(dx: -20, dy: -20)
    }

    func mask(arrow:CALayer) {
        let mask = CAShapeLayer()
        mask.frame = arrow.bounds
        let path = CGMutablePath()
        path.addEllipse(in: mask.bounds.insetBy(dx: 10, dy: 10))
        mask.strokeColor = UIColor(white:0.0, alpha:0.5).cgColor
        mask.lineWidth = 20
        mask.path = path
        arrow.mask = mask
    }

    /// test layerDepth
    func doRotate () {
        print("rotate")

        arrow?.removeFromSuperlayer()
        circle?.removeFromSuperlayer()
        gradientLayer.addSublayer(circle!) //for test layerDepth
        gradientLayer.addSublayer(arrow!) //for test layerDepth
        rotationLayer = gradientLayer //for test layerDepth

        switch which {
        case 1:
            self.rotationLayer.anchorPoint = CGPoint(1,0.5)
            self.rotationLayer.position = CGPoint(self.bounds.maxX, self.bounds.midY)
            self.rotationLayer.transform = CATransform3DMakeRotation(.pi/4.0, 0, 1, 0)
        case 2:
            self.rotationLayer.anchorPoint = CGPoint(1,0.5)
            self.rotationLayer.position = CGPoint(self.bounds.maxX, self.bounds.midY)
            self.rotationLayer.transform = CATransform3DMakeRotation(.pi/4.0, 0, 1, 0)

            var transform = CATransform3DIdentity
            transform.m34 = -1.0/1000.0
            self.sublayerTransform = transform
        default: break
        }
        which = which < 2 ? which+1 : 1
    }
    
    
}
