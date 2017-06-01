
import UIKit

// view exists solely to host layer
class CompassView : UIView {
    override class var layerClass : AnyClass {
        return CompassLayer.self
    }
}

class CompassLayer : CALayer {
    var arrow : CALayer?
    var didSetup = false
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    func setup () {
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

        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        // CGPathAddEllipseInRect => addEllipse
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        //let transform = CGAffineTransform.identity
        //p.addRect(self.bounds.insetBy(dx: 3, dy: 3), transform: transform)
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
            t.bounds = CGRect(x: 0,y: 0,width: 40,height: 40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(x: 0.5, y: vert)
            //print(t.anchorPoint)
            t.alignmentMode = kCAAlignmentCenter
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(ix)*CGFloat(Double.pi)/2.0))
            circle.addSublayer(t)
        }
        
        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(x: 0, y: 0, width: 40, height: 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        // CALayerDelegate 默认为 self
        //arrow.delegate = self as? CALayerDelegate
        //arrow.delegate = self.delegate // we will draw the arrow in the delegate method
        // in Swift, not a property:
        arrow.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double.pi)/5.0))
        self.addSublayer(arrow)
        arrow.setNeedsDisplay() // draw, please
        
        // uncomment next line (only) for contentsCenter and contentsGravity
        // delay (0.4) {self.resizeArrowLayer(arrow)}

        // uncomment next line (only) for layer mask
        // self.mask(arrow)
        
        self.arrow = arrow
    }
    
    override func draw(in ctx: CGContext) {
        print("drawLayer:inContext: for arrow")
        
        // Questa poi la conosco pur troppo!
        
        // punch triangular hole in context clipping region
        ctx.move(to: CGPoint(x: 10, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 90))
        ctx.addLine(to: CGPoint(x: 30, y: 100))
        ctx.closePath()
        ctx.addRect(ctx.boundingBoxOfClipPath)
        ctx.clip()
        
        // draw the vertical line, add its shape to the clipping region
        ctx.move(to: CGPoint(x: 20, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 19))
        ctx.setLineWidth(20)
        ctx.strokePath()
        
        // draw the triangle, the point of the arrow
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 4,height: 4), false, 0)
        let imcon = UIGraphicsGetCurrentContext()!
        imcon.setFillColor(UIColor.red.cgColor)
        imcon.fill(CGRect(x: 0,y: 0,width: 4,height: 4))
        imcon.setFillColor(UIColor.blue.cgColor)
        imcon.fill(CGRect(x: 0,y: 0,width: 4,height: 2))
        let stripes = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let stripesPattern = UIColor(patternImage:stripes!)
        
        UIGraphicsPushContext(ctx)
        stripesPattern.setFill()
        let p = UIBezierPath()
        p.move(to: CGPoint(x: 0,y: 25))
        p.addLine(to: CGPoint(x: 20,y: 0))
        p.addLine(to: CGPoint(x: 40,y: 25))
        p.fill()
        UIGraphicsPopContext()
    }
    
    func resizeArrowLayer(_ arrow:CALayer) {
        print("resize arrow")
        arrow.needsDisplayOnBoundsChange = false
        arrow.contentsCenter = CGRect(x: 0.0, y: 0.4, width: 1.0, height: 0.6)
        arrow.contentsGravity = kCAGravityResizeAspect
        arrow.bounds.insetBy(dx: -20, dy: -20)
    }
    
    func mask(_ arrow:CALayer) {
        let mask = CAShapeLayer()
        mask.frame = arrow.bounds
        let path = CGMutablePath()
        path.addEllipse(in: mask.bounds.insetBy(dx: 10, dy: 10))
        mask.strokeColor = UIColor(white:0.0, alpha:0.5).cgColor
        mask.lineWidth = 20
        mask.path = path
        arrow.mask = mask
    }
    
}
