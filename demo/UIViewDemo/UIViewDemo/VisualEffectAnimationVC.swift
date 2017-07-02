
import UIKit


class VisualEffectAnimationVC: AppBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UILabel(frame:CGRect(50,80,200,50))
        v.text = "Hello"
        self.view.addSubview(v)
        
        let e = UIVisualEffectView(effect: nil)
        e.frame = CGRect(50,80,200,50)
        self.view.addSubview(e)
        
        delay(3) {
            print("start")
            UIView.animate(withDuration:3, animations: {
                e.effect = UIBlurEffect(style:.light)
            }, completion: {
                _ in
                UIView.animate(withDuration:4) {
                    e.frame = CGRect(50,80,0,0)
                }
            })
        }
    }

}

