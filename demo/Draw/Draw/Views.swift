import UIKit


class MyView1 : UIView {
    /// UIKit Draw 方式:
    /// 就是对Core Graphics方式的一种简化封装,你可以用面向对象的方式很方便的做各种绘图操作,主要是通过UIBezierPath这个类来实现的, UIBezierPath可以创建基于矢量的路径,例如各种直线,曲线,圆等等
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
        UIColor.blue.setFill()
        p.fill()
    }
}
class MyView2 : UIView {
    /// UIKit Core Graphics Draw 方式:
    override func draw(_ rect: CGRect) {
        let con = UIGraphicsGetCurrentContext()!
        con.addEllipse(in: CGRect(x: 0,y: 0,width: 100,height: 100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
    }
}
class MyView3 : UIView {
    override func draw(_ rect: CGRect) {}
    /// UIKit Draw 方式:
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        let p = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: 100,height: 100))
        UIColor.blue.setFill()
        p.fill()
        UIGraphicsPopContext()
    }
}

class MyView4 : UIView {
    /// draw rect 方法中已自动设置好了context可以直接进行UIKit方式的绘图
    override func draw(_ rect: CGRect) {}
    /// draw layer: 方法中的CGContext, 并没有被自动设置为当前环境的context, 所以不能直接进行UIKit方式的绘制
    /// in Swift2 func name is drawLayer
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        ctx.addEllipse(in: CGRect(x: 0,y: 0,width: 100,height: 100))
        ctx.setFillColor(UIColor.blue.cgColor)
        ctx.fillPath()
    }
}

class MyImageView1 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Core Graphics Draw 使用UIGraphicsBeginImageContextWithOptions创建画板&用UIKit方式绘制:
        /// 通过 UIGraphicsBeginImageContextWithOptions 创建的context会被自动设置为当前环境的context，所以这种方式下执行绘图时可以直接使用UIKit的绘图方法，不需要进行额外的操作（UIKit只能基于当前Context绘制）
        /// 创建context
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100,height: 100), false, 0)
        /// 执行绘制操作
        let p = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: 100,height: 100))
        UIColor.blue.setFill()
        p.fill()
        /// 获取UIImage对象
        let im = UIGraphicsGetImageFromCurrentImageContext()
        /// 关闭context
        UIGraphicsEndImageContext()
        self.image = im
    }
}
class MyImageView2 : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        /// 使用UIGraphicsBeginImageContextWithOptions创建画板&用Core Graphics方式绘制:
        /**
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100,height: 100), false, 0)
        let con = UIGraphicsGetCurrentContext()!
        con.addEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        con.setFillColor(UIColor.blue.cgColor)
        con.fillPath()
        let im = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = im
        */
        
        ///Core Graphics方式draw
        self.image = imageOfSize(CGSize(width: 100,height: 100)) {
            let con = UIGraphicsGetCurrentContext()!
            con.addEllipse(in: CGRect(x: 0,y: 0,width: 100,height: 100))
            con.setFillColor(UIColor.blue.cgColor)
            con.fillPath()
        }
        
    }
}

/*
NOTE: This structured dance is boring, distracting, confusing (when reading), and error-prone:

UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), false, 0)
// do stuff
let im = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()

Since the purpose is to extract the image, it would be nice to replace that with a functional architecture that clearly yields the image. Moreover, such an architecture has the advantage of isolating any local variables used within the "sandwich". In Objective-C you can at least wrap the interior in curly braces to form a scope, but Swift, with its easy closure formation, offers the opportunity for an even clearer presentation, along these lines:
*/

func imageOfSize(_ size:CGSize, _ opaque:Bool = false, _ closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}


