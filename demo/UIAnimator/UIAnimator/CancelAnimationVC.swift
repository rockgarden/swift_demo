import UIKit


class CancelAnimationVC : UIViewController {

    @IBOutlet var v : UIView!
    var pOrig : CGPoint!
    var pFinal : CGPoint!
    var useAnimator = true
    var anim : UIViewPropertyAnimator!
    
    func animate2() {
        self.anim = UIViewPropertyAnimator(duration: 4, timingParameters: UICubicTimingParameters())
        self.anim.addAnimations {
            self.v.center.x += 100
        }
        self.anim.addCompletion {
            finish in
            print(finish.rawValue)
        }
        self.anim.startAnimation()
    }
    
    var which = 2
    func cancel2() {
        switch which {
        case 2: // hurry to end position
            print("hurry to end")
            self.anim.pauseAnimation()
            self.anim.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve:.easeOut), durationFactor: 0.1)
        case 3: // hurry to start position
            print("hurry to start")
            self.anim.pauseAnimation()
            self.anim.isReversed = true
            self.anim.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve:.easeOut), durationFactor: 0.1)
        case 4: // hurry to anywhere you like!
            print("hurry to somewhere else")
            self.anim.pauseAnimation()
            self.anim.addAnimations {
                self.v.center = CGPoint(-200,-200)
            }
            self.anim.continueAnimation(withTimingParameters: UICubicTimingParameters(animationCurve:.easeOut), durationFactor: 0.1)
        case 5:
            self.anim.stopAnimation(false) // means allow me to finish
            self.anim.finishAnimation(at: .current)
        default: break
        }
        which = which<5 ? which+1 : 1
    }
    
    @IBAction func doStart(_ sender: Any?) {
        self.animate2()
    }
    
    @IBAction func doStop(_ sender: Any?) {
        (sender as? UIButton)?.setTitle("stop \(which)", for: .normal)
        self.cancel2()
    }

}
