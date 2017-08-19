import UIKit
/**
 NSTextContainer类定义了一个文本布局的区域。 NSLayoutManager使用NSTextContainer来确定在哪里断开行，布置文本的部分等等。 NSTextContainer对象通常定义矩形区域，但您可以在文本容器内定义排除路径，以创建文本不流动的区域。 您还可以子类创建具有非矩形区域的文本容器，例如圆形区域，其中具有孔的区域或与图形一起流动的区域。
 NSTextContainer，NSLayoutManager和NSTextStorage类的实例可以从主线程以外的线程访问，只要应用程序一次只保留一个线程的访问。
 */

/// CircleTextContainer
class MyTextContainer : NSTextContainer {

    // NB new in iOS 9, if we override this...
    // we should override simpleRectangularTextContainer

    override var isSimpleRectangularTextContainer : Bool { return false } // *

    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {

        var result = super.lineFragmentRect(forProposedRect:proposedRect, at:characterIndex, writingDirection:baseWritingDirection, remaining:remainingRect)

        /*
         let r = CGRect(0,0,self.size.width,self.size.height)
         let circle = UIBezierPath(ovalInRect:r)

         while !circle.containsPoint(result.origin) {
         result.origin.x += 0.1
         }

         while !circle.containsPoint(CGPoint(result.maxX, result.origin.y)) {
         result.size.width -= 0.1
         }
         */

        let r = self.size.height / 2.0
        // 转换初始y，使圆圈居中 convert initial y so that circle is centered at origin
        let y = r - result.origin.y
        let theta = asin(y/r)
        let x = r * cos(theta)
        // convert resulting x from circle centered at origin
        let offset = self.size.width / 2.0 - r
        result.origin.x = r-x+offset
        result.size.width = 2*x

        return result
    }
}
