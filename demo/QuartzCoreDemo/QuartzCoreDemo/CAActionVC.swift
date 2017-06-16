import UIKit

class MyLayer : CALayer {

    /// 设置层在添加内容时响应从左侧自动推送的效果 layer whose response to contents setting is automatic push from left
    override class func defaultAction(forKey key: String) -> CAAction? {
        if key == "contents" {
            let tr = CATransition()
            tr.type = kCATransitionPush
            tr.subtype = kCATransitionFromLeft
            return tr
        }
        return super.defaultAction(forKey:key)
    }

    /// 方法 1: layer whose implicit 隐式 position animation can be turned off
    override func action(forKey key: String) -> CAAction? {
        if key == "position" {
            if self.value(forKey:"suppressPositionAnimation") != nil {
                return nil
            }
        }
        return super.action(forKey:key)
    }

    override func removeFromSuperlayer() {
        print("I'm being removed from my superlayer")
        super.removeFromSuperlayer()
    }

}


/*
 # CAAction
 允许对象响应由CALayer触发的动作的界面。
 当查询动作标识符（关键路径，外部动作名称或预定义的动作标识符）时，图层返回相应的动作对象（必须实现CAAction协议），并向其发送一个运行（forKey：object：arguments :) 信息。
 */
class MyAction : NSObject, CAAction {
    func run(forKey event: String, object anObject: Any,
        arguments dict: [AnyHashable : Any]?) {
            let anim = CABasicAnimation(keyPath: event)
            anim.duration = 5
            let lay = anObject as! CALayer
            let newP = lay.value(forKey:event)
            let oldP = lay.presentation()!.value(forKey:event)
            print("from \(String(describing: oldP)) to \(String(describing: newP))")
            lay.add(anim, forKey:nil)
    }
}


class MyWagglePositionAction : NSObject, CAAction {
    func run(forKey event: String, object anObject: Any,
        arguments dict: [AnyHashable : Any]?) {
            let lay = anObject as! CALayer
            let newP = lay.value(forKey:event) as! CGPoint
            let oldP = lay.presentation()!.value(forKey:event) as! CGPoint

            let d = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2))
            let r = Double(d/3.0)
            let theta = Double(atan2(newP.y - oldP.y, newP.x - oldP.x))
            let wag = 10 * .pi/180.0
            let p1 = CGPoint(
                oldP.x + CGFloat(r*cos(theta+wag)),
                oldP.y + CGFloat(r*sin(theta+wag)))
            let p2 = CGPoint(
                oldP.x + CGFloat(r*2*cos(theta-wag)),
                oldP.y + CGFloat(r*2*sin(theta-wag)))
            let anim = CAKeyframeAnimation(keyPath: event)
            anim.values = [oldP,p1,p2,newP]
            anim.calculationMode = kCAAnimationCubic
            
            lay.add(anim, forKey:nil)
    }
}


class CAActionVC : UIViewController {
    var layer : CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(which)
        
        let layer = MyLayer()
        layer.frame = CGRect(50,80,60,60)
        CATransaction.setDisableActions(true) //prevent MyLayer automatic contents animation on next line
        layer.contents = UIImage(named:"tree")!.cgImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        self.view.layer.addSublayer(layer)
        self.layer = layer
    }

    var which = 3 // 1...10
    @IBAction func doButton(_ sender: Any?) {
        let layer = self.layer!
        let layer1 = CALayer()

        title = String(which)
        switch which {
        case 1:
            layer.position = CGPoint(100,100)
        case 2: /// 通过 方法 1 关闭此图层的位置动画 turn off position animation for this layer
            layer.setValue(true, forKey:"suppressPositionAnimation")
            layer.position = CGPoint(200,100)
        case 3: // put a "position" entry into the layer's actions dictionary
            let ba = CABasicAnimation()
            ba.duration = 5
            layer.actions = ["position": ba]
            layer.delegate = nil // use actions dictionary, not delegate
            
            // use implicit property animation
            let newP = CGPoint(100,200)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            
        case 4: // put a much more powerful "position" entry into the layer's actions dictionary
            layer.actions = ["position": MyAction()]
            layer.delegate = nil

            // use implicit property animation
            let newP = CGPoint(100,100)
            CATransaction.setAnimationDuration(1.5)
            layer.position = newP
            // the animation still has a 2-second duration

        case 5: //摇摆 waggle
            layer.delegate = nil
            layer.actions = ["position": MyWagglePositionAction()]
            
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPoint(200,200)
            
        case 6: // 摇摆 waggle by the delegate
            layer.delegate = self
            CATransaction.setAnimationDuration(0.4)
            layer.position = CGPoint(100,100)
            
        case 7: // layer automatically turns this into a push-from-left transition
            layer.contents = UIImage(named:"Swift")!.cgImage

        case 8: // the delegate (me) will "pop" the layer as it appears
            layer1.frame = CGRect(200,180,60,60)
            layer1.contentsGravity = kCAGravityResizeAspectFill
            layer1.contents = UIImage(named:"tree")!.cgImage
            layer1.delegate = self
            self.view.layer.addSublayer(layer1)

        case 9: // the delegate (me) will "shrink" the layer as it disappears
            // FIXME: layer1 没消失！
            layer1.delegate = self
            CATransaction.setCompletionBlock({
                layer1.removeFromSuperlayer()
                })
            CATransaction.setValue("", forKey:"bye")
            layer1.opacity = 0

        case 10: // the delegate will "shrink" the layer and remove it
            layer.delegate = self
            layer.setValue("", forKey:"farewell")

        default: break
        }
        which = which < 10 ? which + 1 : 3
    }
}


extension CAActionVC : CALayerDelegate, CAAnimationDelegate {
    
    /// on implicit "position" animation, do a little waggle
    func action(for layer: CALayer, forKey key: String) -> CAAction? {
        if key == "position" {
            return MyWagglePositionAction()
        }
        
        /// on layer addition (addSublayer this layer), "pop" into view
        if key == kCAOnOrderIn {
            let anim1 = CABasicAnimation(keyPath:"opacity")
            anim1.fromValue = 0.0
            anim1.toValue = layer.opacity
            let anim2 = CABasicAnimation(keyPath:"transform")
            anim2.toValue = CATransform3DScale(layer.transform, 1.2, 1.2, 1.0)
            anim2.autoreverses = true
            anim2.duration = 0.1
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.2
            return group
        }
        
        /// on opacity change with "bye" key, "pop" out of sight
        if key == "opacity" {
            if CATransaction.value(forKey:"bye") != nil {
                let anim1 = CABasicAnimation(keyPath:"opacity")
                anim1.fromValue = layer.opacity
                anim1.toValue = 0.0
                let anim2 = CABasicAnimation(keyPath:"transform")
                anim2.toValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
                let group = CAAnimationGroup()
                group.animations = [anim1, anim2]
                group.duration = 0.2
                return group
            }
        }
        
        // on "farewell" key setting, "pop" out of sight and remove from superlayer
        // supersedes previous
        if key == "farewell" {
            let anim1 = CABasicAnimation(keyPath:"opacity")
            anim1.fromValue = layer.opacity
            anim1.toValue = 0.0
            let anim2 = CABasicAnimation(keyPath:"transform")
            anim2.toValue = CATransform3DScale(layer.transform, 0.1, 0.1, 1.0)
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = 0.2
            group.delegate = self // this will cause animationDidStop to be called
            group.setValue(layer, forKey:"remove") // both identifier and removal target
            layer.opacity = 0
            return group
        }
        return nil
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey:"remove") as? CALayer {
            layer.removeFromSuperlayer()
        }
    }
    
}
