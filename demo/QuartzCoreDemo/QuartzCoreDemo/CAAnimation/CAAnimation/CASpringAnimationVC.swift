import UIKit

class CASpringAnimationVC: UIViewController {

    @IBOutlet var v : UIView!

    @IBAction func doButton(_ sender: Any?) {
        // new in iOS 9, springing is exposed at layer level
        CATransaction.setDisableActions(true)
        self.v.layer.position.y += 100
        let anim = CASpringAnimation(keyPath: #keyPath(CALayer.position))
        anim.damping = 0.7
        anim.initialVelocity = 20
        anim.mass = 0.04
        anim.stiffness = 4
        anim.duration = 1 //ignored, but you need to supply something
        print(anim.settlingDuration)
        self.v.layer.add(anim, forKey: nil)
    }
}
