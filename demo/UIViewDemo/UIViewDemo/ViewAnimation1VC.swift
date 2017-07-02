
import UIKit


/// Demo Facade adn Spring
class ViewAnimation1VC: UIViewController {
    @IBOutlet var facadeV: FacadeView!
    @IBOutlet var springV: UIView!
    
    // MyView presents a facade where its "swing" property is view-animatable
    
    @IBAction func doButton(_ sender: Any) {
        
        UIView.animate(withDuration:1) {
            self.facadeV.swing = !self.facadeV.swing // "animatable" Bool property
        }
        UIView.animate(withDuration:0.8, delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 20,
                       animations: {
                        self.springV.center.y += 100
        })

        // can use a property animator here
        if #available(iOS 10.0, *) {
//            let anim = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
//                self.facadeV.swing = !self.facadeV.swing
//            }
//            anim.startAnimation()
//            //use pause to prove it's an interruptible animation
//            delay(0.5) {
//                anim.pauseAnimation()
//            }
        } else {
            // Fallback on earlier versions
        }
    }
}


class FacadeView : UIView {
    var swing : Bool = false {
        didSet {
            var p = self.center
            p.x = self.swing ? p.x + 100 : p.x - 100
            /// this is the trick: perform actual view animation with zero duration
            // zero duration means we inherit the surrounding duration 零持续时间意味着我们继承周围的持续时间
            UIView.animate(withDuration:0) {
                self.center = p
            }
            // can use a property animator here too, but only if we generate it this way
            if #available(iOS 10.0, *) {
//                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0, delay: 0, options: [], animations: {self.center = p})
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

