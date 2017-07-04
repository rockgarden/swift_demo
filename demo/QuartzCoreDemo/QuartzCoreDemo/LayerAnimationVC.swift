

import UIKit


/// CAKeyframeAnimation: Sprite and Swing
class LayerAnimationVC : UIViewController {

    @IBOutlet var compassView : CompassView!
    var which = 1

    var sprite : CALayer!
    lazy var images : [UIImage] = self.makeImages()
    let Y = UIScreen.main.bounds.height-100

    @IBAction func doButton(_ sender: Any?) {
        let c = self.compassView.layer as! BaseCompassLayer
        let arrow = c.arrow!
        
        switch which {
        case 1:
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            
        case 2:
            CATransaction.setAnimationDuration(0.8)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            
        case 3:
            let clunk = CAMediaTimingFunction(controlPoints: 0.9, 0.1, 0.7, 0.9)
            CATransaction.setAnimationTimingFunction(clunk)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)

        case 4:
            // proving that the completion block works
            CATransaction.setCompletionBlock({
                print("done")
                })
            
            // capture the start and end values
            let startValue = arrow.transform
            let endValue = CATransform3DRotate(startValue, .pi/4.0, 0, 0, 1)
            // change the layer, without implicit animation
            CATransaction.setDisableActions(true)
            arrow.transform = endValue
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 5:
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            arrow.add(anim, forKey:nil)
            
        case 6:
            // capture the start and end values
            let nowValue = arrow.transform
            let startValue = CATransform3DRotate(nowValue, .pi/40.0, 0, 0, 1)
            let endValue = CATransform3DRotate(nowValue, -.pi/40.0, 0, 0, 1)
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction = CAMediaTimingFunction(
                name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 7:
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction =
                CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)
            anim.fromValue = Float.pi/40
            anim.toValue = -Float.pi/40
            arrow.add(anim, forKey:nil)
            
        case 8:
            let rot = CGFloat.pi/4.0
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, rot, 0, 0, 1)
            // construct animation additively
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = -rot
            anim.toValue = 0
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)
            arrow.add(anim, forKey:nil)

        case 9:
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            print(values)
            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim.values = values
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
            arrow.add(anim, forKey:nil)

        case 10:
            // put them all together, they spell Mother...
            
            // capture current value, set final value
            let rot = .pi/4.0
            CATransaction.setDisableActions(true)
            let current = arrow.value(forKeyPath:"transform.rotation.z") as! Double
            arrow.setValue(current + rot, forKeyPath:"transform.rotation.z")

            // first animation (rotate and clunk)
            let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim1.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim1.timingFunction = clunk
            anim1.fromValue = current
            anim1.toValue = current + rot
            anim1.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)

            // second animation (waggle)
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            let anim2 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim2.values = values
            anim2.duration = 0.25
            anim2.isAdditive = true
            anim2.beginTime = anim1.duration - 0.1
            anim2.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)

            // group
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = anim1.duration + anim2.duration
            arrow.add(group, forKey:nil)

            
        default: break
        }
        which = which<10 ? which+1 : 1
    }

    func makeImages () -> [UIImage] {
        var arr = [UIImage]()

        for i in [0,1,2,1,0] {
            arr += [imageOfSize(CGSize(24,24)) { _ in
                UIImage(named: "sprites")!.draw(at:CGPoint(CGFloat(-(5+i)*24), -4*24))
                }]
        }
        return arr
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sprite = CALayer()
        self.sprite.frame = CGRect(30,Y,24,24)
        /// contentsScale 施加到层的比例因子。
        /// 该值定义了层的逻辑坐标空间（以点测量）与物理坐标空间（以像素为单位）之间的映射。 较高的比例因子表明，在渲染时，层中的每个点由多个像素表示。 例如，如果缩放因子为2.0，层的边界为50 x 50点，则用于呈现图层内容的位图的大小为100 x 100像素。
        /// 此属性的默认值为1.0。 对于连接到视图的图层，视图会自动将缩放因子更改为适合当前屏幕的值。 对于您创建和管理自己的图层，您必须根据屏幕的分辨率和您提供的内容自己设置此属性的值。 核心动画使用您指定的值作为提示来确定如何呈现您的内容。
        self.sprite.contentsScale = UIScreen.main.scale
        self.view.layer.addSublayer(self.sprite)
        self.sprite.contents = self.images[0].cgImage
    }

    @IBAction func doSprite(_ sender: Any?) {
        /// CALayer.contents 提供图层内容的对象。动画。此属性的默认值为nil。
        /// 如果使用图层显示静态图像，则可以将此属性设置为包含要显示的图像的CGImage。 （在macOS 10.6及更高版本中，您还可以将属性设置为NSImage对象。）为此属性分配一个值会导致图层使用图像而不是创建单独的后备存储。
        /// 如果层对象绑定到视图对象，则应避免直接设置此属性的内容。 视图和图层之间的相互作用通常会导致视图在后续更新期间替换此属性的内容。
        let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.contents))
        anim.values = self.images.map {$0.cgImage!}
        anim.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        anim.calculationMode = kCAAnimationDiscrete
        anim.duration = 1.5
        anim.repeatCount = .infinity

        let anim2 = CABasicAnimation(keyPath:#keyPath(CALayer.position))
        anim2.duration = 10
        anim2.toValue = CGPoint(350,Y)

        let group = CAAnimationGroup()
        group.animations = [anim, anim2]
        group.duration = 10

        self.sprite.add(group, forKey:nil)
    }
    
}
