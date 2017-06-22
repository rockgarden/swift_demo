
import UIKit


// for comparison purposes
//        let alert = UIAlertController(title: "Howdy", message: "This is a test", preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Cancel))
//        self.present(alert, animated:true)
//        return;


class MyPresentationController : UIPresentationController {
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        shadow.alpha = 0
        con.insertSubview(shadow, at: 0)
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 1
        }, completion: {
            _ in
            let vc = self.presentingViewController
            let v = vc.view
            v?.tintAdjustmentMode = .dimmed
        })
    }

    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition:{
            _ in
            shadow.alpha = 0
        }, completion: {
            _ in
            let vc = self.presentingViewController
            let v = vc.view
            v?.tintAdjustmentMode = .automatic
        })
    }

    override var frameOfPresentedViewInContainerView : CGRect {
        let v = self.presentedView!
        let con = self.containerView!
        v.center = CGPoint(con.bounds.midX, con.bounds.midY)
        return v.frame.integral
    }

    // 处理旋转
    override func containerViewWillLayoutSubviews() {
        let v = self.presentedView!
        v.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin,
                              .flexibleLeftMargin, .flexibleRightMargin]
    }

}


/// imitate an alert view
class CustomAlertVC : UIViewController {
    @IBOutlet var button : UIButton!
    
    @IBAction func doButton(_ sender: Any?) {
        presentingViewController!.dismiss(animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.borderColor = self.view.tintColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        self.button.layer.borderColor = self.button.tintColor!.cgColor
        self.button.layer.borderWidth = 1
        let im = imageOfSize(CGSize(10,10)) {
            let con = UIGraphicsGetCurrentContext()!
            con.setFillColor(UIColor(white:0.4, alpha:1.5).cgColor)
            con.fill(CGRect(0,0,10,10))
        }
        self.button.setBackgroundImage(im, for:.highlighted)
    }
    
    init() {
        super.init(nibName: "CustomAlertVC", bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

}


extension CustomAlertVC : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("providing presentation animation controller")
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("providing dismissal animation controller")
        return self
    }
}


extension CustomAlertVC : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using ctx: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.25
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        // just for logging purposes
        let vc1 = ctx.viewController(forKey:.from)
        let vc2 = ctx.viewController(forKey:.to)
        print("vc1 is", type(of: vc1!), "\nvc2 is", type(of: vc2!))
        
        let con = ctx.containerView
        
        //let r1start = ctx.initialFrame(for:vc1!)
        //let r2end = ctx.finalFrame(for:vc2!)
        
        let v1 = ctx.view(forKey:.from)
        let v2 = ctx.view(forKey:.to)
        
        /// Using the same object (self) as animation controller for both presentation and dismissal, so we have to distinguish the two cases.
        /// warning: this trick works only for non-fullscreen
        
        if let v2 = v2 { // presenting
            print("presentation animation")
            con.addSubview(v2)
            let scale = CGAffineTransform(scaleX:1.6, y:1.6)
            v2.transform = scale
            v2.alpha = 0
            UIView.animate(withDuration:0.25, animations: {
                v2.alpha = 1
                v2.transform = .identity
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
                })
        } else if let v1 = v1 { // dismissing
            print("dismissal animation")
            UIView.animate(withDuration:0.25, animations: {
                v1.alpha = 0
                }, completion: {
                    _ in
                    ctx.completeTransition(true)
                })
        }
        
    }

}
