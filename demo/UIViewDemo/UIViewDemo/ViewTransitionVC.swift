
import UIKit


class ViewTransitionVC : UIViewController {
    
    @IBOutlet var iv : UIImageView!
    @IBOutlet var v : MyView_T!
    @IBOutlet var outer : UIView!
    @IBOutlet var inner : UIView!
    @IBOutlet var lab : UILabel!
    
    var useAnimator = true
    
    @IBAction func doButton(_ sender: Any?) {
        switch useAnimator {
        case false:
            self.animate()
        case true:
            if #available(iOS 10.0, *) {
                let anim = UIViewPropertyAnimator(duration: 4, curve: .linear) {
                    self.animate()
                }
                anim.startAnimation()
//                delay(2) {
//                    // FIXME: Error Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[CATransition keyPath]: unrecognized selector sent to instance 0x60000003c840'
//                    anim.pauseAnimation()
//                    anim.isReversed = true
//                    anim.startAnimation()
//                }
            } else {
                self.animate()
            }
        }
    }
    
    func animate() {
        let opts : UIViewAnimationOptions = .transitionFlipFromLeft
        UIView.transition(with:self.iv, duration: 0.8, options: opts,
            animations: {
                self.iv.image = UIImage(named:"Smiley")
            })
        
        // ======
        
        self.v.reverse = !self.v.reverse
        UIView.transition(with:self.v, duration: 1, options: opts,
            animations: {
                self.v.setNeedsDisplay()
            })
        
        // ======
                
        let opts2 : UIViewAnimationOptions = [.transitionFlipFromLeft, .allowAnimatedContent]
        UIView.transition(with:self.outer, duration: 1, options: opts2,
            animations: {
                var f = self.inner.frame
                f.size.width = self.outer.frame.width
                f.origin.x = 0
                self.inner.frame = f
            })

        // ======
        let lab2 = UILabel(frame:self.lab.frame)
        lab2.text = self.lab.text == "Hello" ? "Howdy" : "Hello"
        lab2.sizeToFit()
        UIView.transition(
            from:self.lab, to: lab2,
            duration: 0.8, options: .transitionFlipFromLeft) {
                _ in
                self.lab = lab2
        }
        
    }
    
}


class MyView_T : UIView {

    var reverse = false

    override func draw(_ rect: CGRect)  {
        let f = self.bounds.insetBy(dx: 10, dy: 10)
        let con = UIGraphicsGetCurrentContext()!
        if self.reverse {
            con.strokeEllipse(in:f)
        }
        else {
            con.stroke(f)
        }
    }

}
