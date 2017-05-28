
import UIKit

class CVCS_ChildVC : UIViewController {

    @IBAction func doButton(_ sender: Any?) {
        presentingViewController!.dismiss(animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc2 view did load")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.traitCollection)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.transitioningDelegate = self
        self.modalPresentationStyle = .currentContext
    }
}

extension CVCS_ChildVC : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}


extension CVCS_ChildVC : UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let vc2 = transitionContext.viewController(forKey:.to)!

        let con = transitionContext.containerView

        let r2end = transitionContext.finalFrame(for:vc2)

        let v2 = transitionContext.view(forKey:.to)!

        var r2start = r2end
        r2start.origin.y -= r2start.size.height
        v2.frame = r2start
        con.addSubview(v2)
        UIView.animate(withDuration:0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, animations: {
            v2.frame = r2end
        }, completion: {
            _ in
            transitionContext.completeTransition(true)
        })
        
    }
}
