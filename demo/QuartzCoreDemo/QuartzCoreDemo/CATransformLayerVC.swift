
import UIKit

/// CATransformLayer对象用于创建真正的3D图层层次结构，而不是其他CALayer类使用的展平层次渲染模型。
/// 与普通层不同，变换层在Z = 0时不会将它们的子层平坦化到平面内。 因此，它们不支持CALayer类合成模型的许多功能：
/// 只渲染变换层的子层。 由层渲染的CALayer属性将被忽略，包括：backgroundColor，内容，边框样式属性，笔触样式属性等。
/// 假设2D图像处理的属性也被忽略，包括：filters，backgroundFilter，compositingFilter，mask，masksToBounds和阴影样式属性。
/// 不透明度属性分别应用于每个子层，变换层不形成合成组。
/// hitTest：方法不应该在变换层上调用，因为它们没有可以映射点的2D坐标空间。
class CATransformLayerVC : UIViewController {
    
    let which = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        var lay1 = CALayer()
        switch which {
        case 1: break
        case 2:
            lay1 = CATransformLayer()
        default: break
        }

        lay1.frame = view.layer.bounds
        view.layer.addSublayer(lay1)

        let f = CGRect(0,80,100,100)

        let lay2 = CALayer()
        lay2.frame = f
        lay2.backgroundColor = UIColor.blue.cgColor
        lay1.addSublayer(lay2)
        let lay3 = CALayer()
        lay3.frame = f.offsetBy(dx: 20, dy: 30)
        lay3.backgroundColor = UIColor.green.cgColor
        lay3.zPosition = 10
        lay1.addSublayer(lay3)

        delay(2) {
            lay1.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        }

        let c = CompassView_3D(frame: CGRect(60,280,200,200))
        view.addSubview(c)
    }
    
}
