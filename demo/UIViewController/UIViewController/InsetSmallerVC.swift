

import UIKit


class InsetSmallerVC: UIViewController {

    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIButton!

    var anim : UIViewImplicitlyAnimating?

    /// important: viewDidLoad() is too late for this sort of thing, must be done before presentation even has a chance to start
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        /// 注意如果我们要修改_animation_，我们需要设置transitioningDelegatee
        self.transitioningDelegate = self
        /// 如果我们要自定义_presentation_样式,并且只针对iPhone，则根据traitCollection 判断设备，后将modalPresentationStyle设置为custom
        if UIApplication.shared.keyWindow!.traitCollection.userInterfaceIdiom == .phone {
            self.modalPresentationStyle = .custom
        }
    }

    @IBAction func doButton(_ sender: Any) {
        presentingViewController!.dismiss(animated:true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tc = self.transitionCoordinator {
            tc.animate(alongsideTransition:{
                _ in
                self.buttonTopConstraint.constant += 200
                self.view.layoutIfNeeded()
            })
        }
    }

}

extension InsetSmallerVC : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = InsetPresentationController(presentedViewController: presented, presenting: presenting)
        return pc
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // return nil
        return self
    }
}


extension InsetSmallerVC : UIViewControllerAnimatedTransitioning {

    func interruptibleAnimator(using ctx: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {

        if self.anim != nil {
            return self.anim!
        }

        //let vc1 = transitionContext.viewController(forKey:.from)
        let vc2 = ctx.viewController(forKey:.to)

        let con = ctx.containerView

        //let r1start = transitionContext.initialFrame(for:vc1!)
        let r2end = ctx.finalFrame(for:vc2!)

        //let v1 = transitionContext.view(forKey:.from)!
        let v2 = ctx.view(forKey:.to)!

        v2.frame = r2end
        v2.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        v2.alpha = 0
        con.addSubview(v2)

        let _anim: UIViewImplicitlyAnimating!
        if #available(iOS 10.0, *) {
            _anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
                v2.alpha = 1
                v2.transform = .identity
            }
            _anim.addCompletion! { _ in
                ctx.completeTransition(true)
            }
        } else {
            _anim = UIView.animate(withDuration: 2, delay:0, options: [.curveLinear], animations: {
                v2.alpha = 1
                v2.transform = .identity
            }, completion: {
                _ in
                delay (0.1) { // needed to solve "black ghost" problem after partial gesture
                    let cancelled = ctx.transitionWasCancelled
                    ctx.completeTransition(!cancelled)
                }
            }) as! UIViewImplicitlyAnimating
        }

        self.anim = _anim
        return _anim

    }

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        let anim = self.interruptibleAnimator(using: ctx)
        anim.startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        self.anim = nil
    }
}


class InsetPresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView : CGRect {
        return super.frameOfPresentedViewInContainerView.insetBy(dx: 40, dy: 40)
    }

    // ==========================
    override func presentationTransitionWillBegin() {
        let con = self.containerView!
        let shadow = UIView(frame:con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        con.insertSubview(shadow, at: 0)
        // deal with what happens on rotation
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // ==========================
    override func dismissalTransitionWillBegin() {
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = self.presentedViewController.transitionCoordinator!
        tc.animate(alongsideTransition: {
            _ in
            shadow.alpha = 0
        })
    }

    // ===========================
    override var presentedView : UIView? {
        let v = super.presentedView!
        v.layer.cornerRadius = 6
        v.layer.masksToBounds = true
        return v
    }
    //    override func shouldRemovePresentersView() -> Bool {
    //        return true
    //    }

    // ===========================
    override func presentationTransitionDidEnd(_ completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v?.tintAdjustmentMode = .dimmed
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        let vc = self.presentingViewController
        let v = vc.view
        v?.tintAdjustmentMode = .automatic
    }
}



