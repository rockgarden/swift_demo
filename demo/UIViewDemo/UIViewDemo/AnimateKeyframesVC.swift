import UIKit


class AnimateKeyframesVC : UIViewController {
    @IBOutlet var v : UIView!
    
    var useAnimator = true
    
    @available(iOS 10.0, *)
    @IBAction func doButton(_ sender: Any?) {
        switch useAnimator {
        case false:
            self.animate()
        case true:
            let anim = UIViewPropertyAnimator(duration: 4, curve: .easeInOut) {}
            anim.addAnimations {
                self.animate()
            }
            anim.startAnimation()
            delay(3) { // prove that we are pausable / reversible
                anim.pauseAnimation()
                anim.isReversed = true
                anim.startAnimation()
            }
        }
    }
    
    func animate() {
        var p = self.v.center
        var opts : UIViewKeyframeAnimationOptions = .calculationModeLinear
        let opt2 : UIViewAnimationOptions = .curveLinear
        opts.insert(UIViewKeyframeAnimationOptions(rawValue:opt2.rawValue))
        let dur = 0.25
        var start = 0.0
        let dx : CGFloat = 100
        let dy : CGFloat = 50
        var dir : CGFloat = 1
        UIView.animateKeyframes(withDuration:4,
            delay: 0,
            options: opts, // comment in or out
            animations: {
                self.v.alpha = 0
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur) {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    }
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur) {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    }
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur) {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    }
                start += dur; dir *= -1
                UIView.addKeyframe(withRelativeStartTime:start,
                    relativeDuration: dur) {
                        p.x += dx*dir; p.y += dy
                        self.v.center = p
                    }
            })
    }
    
}
