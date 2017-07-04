
import UIKit


class FrozenAnimationVC: UIViewController {
    
    @IBOutlet var v: UIView!
    var shape : CAShapeLayer!
    
    var which = 1 // 1 for layer freeze, 2 for animation freeze
    
    override func viewDidLoad() {
        let shape = CAShapeLayer()
        shape.frame = v.bounds
        v.layer.addSublayer(shape)
        
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor

        /// 创建一个不可变的矩形路径。
        /// 这是一个便利函数，它创建一个矩形的路径。 使用这种便利功能比创建可变路径并向其添加一个矩形更有效。
        /// 调用此函数相当于使用minX和相关函数找到矩形的角，然后使用moveTo（_：x：y :)，addLineTo（_：x：y :)和closeSubpath（）函数绘制 长方形。
        let path = CGPath(rect:shape.bounds, transform:nil)
        shape.path = path

        /// ellipseIn 创建一个不可变的椭圆路径。
        /// 这是一个创建椭圆路径的便利函数。使用这个便利功能比创建一个可变路径并向它添加一个椭圆更有效。
        /// 椭圆是由一系列的Bézier曲线近似é。它的中心是由矩形参数定义的矩形的中点。如果矩形是正方形，则椭圆是圆形的，半径等于矩形的宽度（或高度）的一半。如果矩形参数指定的矩形，然后椭圆的长轴和短轴是由矩形的宽度和高度的确定。
        /// 椭圆形成一个完整的路径，路径的椭圆的绘制从一个移动到手术结束关闭子路径的操作，用顺时针方向移动。如果你提供一个仿射变换，然后构建Bézier曲线定义椭圆转化之前将它们添加到路径。
        let path2 = CGPath(ellipseIn:shape.bounds, transform:nil)
        let ba = CABasicAnimation(keyPath:#keyPath(CAShapeLayer.path))
        ba.duration = 1
        ba.fromValue = path
        ba.toValue = path2
        
        switch which {
        case 1:
            shape.speed = 0
            shape.timeOffset = 0
        case 2:
            ba.speed = 0
            ba.timeOffset = 0
        default:break
        }
        shape.add(ba, forKey:#keyPath(CAShapeLayer.path))
        
        self.shape = shape
    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        switch which {
        case 1:
            self.shape.timeOffset = Double(slider.value)
        case 2:
            // this seems to be how a property animator does it
            let anim = self.shape.animation(forKey:#keyPath(CAShapeLayer.path))
            let anim2 = anim?.copy() as! CAAnimation
            anim2.timeOffset = Double(slider.value)
            self.shape.add(anim2, forKey:#keyPath(CAShapeLayer.path))
        default:break
        }
    }

}

