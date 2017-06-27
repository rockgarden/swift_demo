
import UIKit

class ContainerVC : UIViewController {
    
    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.swappers += [UIViewController()]
        self.swappers += [UIViewController()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.swappers[cur]
        self.addChildViewController(vc) // "will" called for us
        vc.view.frame = self.panel.bounds
        self.panel.addSubview(vc.view) // insert view into interface between "will" and "did"
        // note: when we call add, we must call "did" afterwards
        vc.didMove(toParentViewController: self)
    }


    @IBAction func doFlip(_ sender: Any?) {
        /// 禁止响应UI事件(执行完Func后要恢复)
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds
        
        /// must have both as children vc before we can transition between them
        addChildViewController(tovc) // "will" called for us
        /// when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParentViewController: nil)

        // then perform the transition
        transition(
            from:fromvc,
            to:tovc,
            duration:0.4,
            options:.transitionFlipFromLeft,
            animations:nil) { _ in
                /// 当我们调用add时，我们必须调用. “done”when we call add, we must call "did" afterwards
                tovc.didMove(toParentViewController: self)
                fromvc.removeFromParentViewController() // "did" called for us
                /// Important: 恢复响应UI事件
                UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

}

