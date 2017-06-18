

import UIKit


class HitTestDuringAnimationVC : UIViewController {

    @IBOutlet var button : UIButton!
    @IBOutlet var button1 : UIButton!
    var oldButtonCenter : CGPoint!
    var oldButtonCenter1 : CGPoint!
    let goal = CGPoint(100,300)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldButtonCenter = self.button.center // so we can test repeatedly
        self.oldButtonCenter1 = self.button1.center

        if #available(iOS 10.0, *) {
            _ = self.configAnimator()
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 10.0, *) {
            let p = UIPanGestureRecognizer(target: self, action: #selector(pan))
            self.button1.addGestureRecognizer(p)
        } else {
            // Fallback on earlier versions
        }

    }

    @available(iOS 10.0, *)
    func configAnimator() -> UIViewPropertyAnimator {
        let anim = UIViewPropertyAnimator(duration: 10, curve: .linear) {}
        anim.addAnimations {
            self.button1.center = self.goal
        }
        return anim
    }

    @IBAction func tapme(_ sender: Any?) {
        print("tap! (the button's action method)")
    }
    
    var which = 1
    @IBAction func start(_ sender: Any?) {
        print("you tapped Start")
        let goal = CGPoint(100,200)
        self.button.center = self.oldButtonCenter
        
        switch which {
        case 1:
            let opt = UIViewAnimationOptions.allowUserInteraction
            UIView.animate(withDuration:10, delay: 0, options: opt,
                animations: {
                    self.button.center = goal
                })
        case 2:
            let ba = CABasicAnimation(keyPath:"position")
            ba.duration = 10
            ba.fromValue = self.oldButtonCenter
            ba.toValue = goal
            self.button.layer.add(ba, forKey:nil)
            self.button.layer.position = goal
        default: break
        }
        which = which < 2 ? 2 : 1
    }

    @available(iOS 10.0, *)
    @IBAction func start1(_ sender: Any?) {
        print("you tapped Start1")
        let anim = configAnimator()
        if anim.state == .active {
            anim.stopAnimation(false)
            anim.finishAnimation(at: .current)
        }
        self.button1.center = self.oldButtonCenter1
        _ = self.configAnimator()
        anim.startAnimation()
    }

    @available(iOS 10.0, *)
    func pan(_ p: UIPanGestureRecognizer) {
        let v = p.view!
        let anim = self.configAnimator()

        switch p.state {
        case .began:
            if anim.state == .inactive {
                _ = self.configAnimator()
            }
            if anim.state == .active {
                anim.stopAnimation(true)
            }
            fallthrough
        case .changed:
            // normal draggability
            let delta = p.translation(in:v.superview)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(.zero, in: v.superview)
        case .ended:
            // how far are we from the goal relative to original distance?
            func pyth(_ pt1:CGPoint, _ pt2:CGPoint) -> CGFloat {
                let x = pt1.x - pt2.x
                let y = pt1.y - pt2.y
                return sqrt(x*x + y*y)
            }
            let origd = pyth(self.oldButtonCenter1, self.goal)
            let curd = pyth(v.center, self.goal)
            let factor = curd/origd
            anim.addAnimations {
                self.button1.center = self.goal
            }
            anim.startAnimation()
            anim.pauseAnimation()
            anim.continueAnimation(withTimingParameters: anim.timingParameters, durationFactor: factor)
        default: break
        }
    }

}


class MyView_hTDA : UIView {
    @IBOutlet var v : UIView! // the animated subview Button

    override func awakeFromNib() {
        super.awakeFromNib()
        let t = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.v.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
        // "swallows the touch" while animating
        // self.v.removeGestureRecognizer(t)
    }

    func tap(_ g:UIGestureRecognizer!) {
        print("tap! (gesture recognizer)")
    }

}


class MyButton_hTDA: UIButton {

    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        /*
         返回代表当前显示在屏幕上的图层状态的表示层对象的副本。
         此方法返回的层对象提供了当前正在屏幕上显示的层的近似近似值。 动画正在进行中，您可以检索该对象，并使用它来获取这些动画的当前值。
         返回的层的子层，掩码和超层属性从呈现树（而不是模型树）返回相应的对象。 此模式也适用于任何只读层方法。 例如，返回对象的hitTest（_ :)方法查询演示树中的图层对象。
         */
        let pres = self.layer.presentation()!
        /// 将一个点从当前对象的坐标空间转换为指定的坐标空间。sub -> super
        let suppt = self.convert(point, to: self.superview!)
        /// 将一个点从当前对象的坐标空间转换为指定的坐标空间。super -> presentation layer
        let prespt = self.superview!.layer.convert(suppt, to: pres)
        return super.hitTest(prespt, with: e)
    }
    
}

