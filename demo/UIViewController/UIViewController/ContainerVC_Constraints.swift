
import UIKit

class ContainerVC_Constraints : UIViewController {

    @IBOutlet var panel : UIView!
    var cur : Int = 0
    var swappers = [UIViewController]()
    var constraints = [NSLayoutConstraint]()
    var vc1: UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .lightGray
        return vc
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.swappers += [vc1]
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

        self.constrainInPanel(vc.view) // *
    }

    @IBAction func doFlip(_ sender: Any?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds

        // must have both as children before we can transition between them
        self.addChildViewController(tovc) // "will" called for us
        // when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParentViewController: nil)
        // then perform the transition
        self.transition(
            from:fromvc,
            to:tovc,
            duration:0.4,
            options:.transitionFlipFromLeft,
            animations: {
                self.constrainInPanel(tovc.view) // *
        }) { _ in
            // when we call add, we must call "did" afterwards
            tovc.didMove(toParentViewController: self)
            fromvc.removeFromParentViewController() // "did" called for us
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    @IBAction func doFlip_Custom(_ sender: Any?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let fromvc = self.swappers[cur]
        cur = cur == 0 ? 1 : 0
        let tovc = self.swappers[cur]
        tovc.view.frame = self.panel.bounds

        var im: UIImage!
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:tovc.view.bounds.size)
            im = r.image { ctx in
                let con = ctx.cgContext
                tovc.view.layer.render(in:con)
            }
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContextWithOptions(tovc.view.bounds.size, false, 0)
            im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        let iv = UIImageView(image:im)
        iv.frame = CGRect.zero
        self.panel.addSubview(iv)
        tovc.view.alpha = 0 // hide the real view

        // must have both as children before we can transition between them
        self.addChildViewController(tovc) // "will" called for us
        // when we call remove, we must call "will" (with nil) beforehand
        fromvc.willMove(toParentViewController: nil)
        // then perform the transition
        self.transition(
            from:fromvc,
            to:tovc,
            duration:0.4,
            // no options:
            animations: {
                iv.frame = tovc.view.frame // *
                self.constrainInPanel(tovc.view) // *
        }) { _ in
            tovc.view.alpha = 1
            iv.removeFromSuperview()
            // when we call add, we must call "did" afterwards
            tovc.didMove(toParentViewController: self)
            fromvc.removeFromParentViewController() // "did" called for us
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    func constrainInPanel(_ v: UIView) {
        print("constraint")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|", metrics:nil, views:["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|", metrics:nil, views:["v":v])
            ].flatMap{$0})
    }

    /// constraintInPanel() is called just once, but constrainInPanel2 is called twice.
    override func viewWillLayoutSubviews() {
        /// if you uncomment this, comment out the two calls to constraintInPanel() and vice versa
        //self.constrainInPanel2(self.panel.subviews[0] as UIView)
    }

    func constrainInPanel2(_ v:UIView) {
        print("constraint2")
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(self.constraints)
        self.constraints.removeAll()
        self.constraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|", metrics:nil, views:["v":v]))
        self.constraints.append(contentsOf:NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|", metrics:nil, views:["v":v]))
        NSLayoutConstraint.activate(self.constraints)
    }
}
