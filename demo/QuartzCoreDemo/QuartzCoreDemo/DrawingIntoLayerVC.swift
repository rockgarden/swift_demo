import UIKit


class DrawingIntoLayerVC : UIViewController {
    @IBOutlet var views: NSArray?
    var smilers = [Smiler(), Smiler2()] // to serve as delegates
    
    @discardableResult
    func makeLayerOfClass(_ klass:CALayer.Type, andAddToView ix:Int) -> CALayer {
        let lay = klass.init()
        lay.contentsScale = UIScreen.main.scale
        //lay.contentsGravity = kCAGravityBottom
        //lay.contentsRect = CGRect(0.2,0.2,0.5,0.5)
        //lay.contentsCenter = CGRect(0.0, 0.4, 1.0, 0.6)
        let v = (self.views! as! [UIView])[ix]
        lay.frame = v.layer.bounds
        v.layer.addSublayer(lay)
        lay.setNeedsDisplay()

        // add another layer to say which view this is
        /// 一个提供简单文本布局和渲染纯文本或属性字符串的图层。第一行与层的顶部对齐。
        let tlay = CATextLayer() //
        tlay.frame = lay.bounds
        lay.addSublayer(tlay)
        tlay.string = "\(ix)"
        tlay.fontSize = 30
        tlay.alignmentMode = kCAAlignmentCenter
        tlay.foregroundColor = UIColor.green.cgColor
        
        return lay;
    }
    
    // Big change in iOS 10: CALayerDelegate is a real protocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // four ways of getting content into a layer
        // 0: delegate draws
        self.makeLayerOfClass(CALayer.self, andAddToView:0).delegate = self.smilers[0] as? CALayerDelegate
        // 1: delegate sets contents
        self.makeLayerOfClass(CALayer.self, andAddToView:1).delegate = self.smilers[1] as? CALayerDelegate
        // 2: subclass draws
        self.makeLayerOfClass(SmilerLayer.self, andAddToView:2)
        // 3: subclass sets contents
        self.makeLayerOfClass(SmilerLayer2.self, andAddToView:3)
    }

}

/// App可以实现CALayerDelegate来响应层的相关事件。您可以实现此协议的方法来提供图层的内容，处理子图层的布局，并提供自定义的动画动作来执行。 实现此协议的对象必须分配给层对象的delegate属性。
class Smiler: NSObject, CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"Swift")!.draw(at: .zero)
        UIGraphicsPopContext()
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class Smiler2: NSObject, CALayerDelegate {
    func display(_ layer: CALayer) {
        layer.contents = UIImage(named:"Swift")!.cgImage
        print("\(#function)")
        print(layer.contentsGravity)
    }
}

class SmilerLayer: CALayer {
    override func draw(in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        //[[UIImage imageNamed: @"smiley"] drawInRect:CGContextGetClipBoundingBox(ctx)];
        UIImage(named:"Swift")!.draw(at: .zero)
        UIGraphicsPopContext()
        print("\(#function)")
        print(self.contentsGravity)
    }
}

class SmilerLayer2: CALayer {
    override func display() {
        self.contents = UIImage(named:"Swift")!.cgImage
        print("\(#function)")
        print(self.contentsGravity)
    }
}

