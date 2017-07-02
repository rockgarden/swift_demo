
import UIKit


class FrozenAnimationVC: UIViewController {
    @IBOutlet weak var v: UIView!
    var anim : UIViewPropertyAnimator!
    @IBOutlet weak var slider: UISlider!
    var didConfig = false
    var pTarget = CGPoint.zero
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didConfig {
            didConfig = true
            let b = self.slider.bounds
            do {
                /// thumbRect 返回滑块缩略图的绘图矩形。你不直接调用这个方法。 相反，当您要自定义缩略图的绘图矩形，返回一个不同的矩形时，您可以覆盖它。 您返回的矩形必须反映您的拇指图像的大小及其当前位置在滑块的轨道上。
                /// value The current value of the slider.
                /// trackRect 返回滑块轨迹的绘图矩形。你不直接调用这个方法。 相反，当您要自定义轨道矩形，返回一个不同的矩形时，您可以覆盖它。 返回的矩形用于在绘图期间缩放轨迹和缩略图像。
                let r = self.slider.thumbRect(forBounds: b, trackRect: self.slider.trackRect(forBounds: b), value: 0)
                let c = CGPoint(r.midX, r.midY)
                let c2 = view.convert(c, from:self.slider)
                self.v.center.x = c2.x
            }
            do {
                let r = self.slider.thumbRect(forBounds: b, trackRect: self.slider.trackRect(forBounds: b), value: 1)
                let c = CGPoint(r.midX, r.midY)
                let c2 = self.view.convert(c, from:self.slider)
                self.pTarget = c2
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.v.center.x = self.pTarget.x
            self.v.backgroundColor = .green
        }

    }
    
    @IBAction func doSlider(_ slider: UISlider) {
        self.anim.fractionComplete = CGFloat(slider.value)
    }

}

