//
//  FadeTransition.swift
//  SubmitTransition
//
//  Created by Takuya Okamoto on 2015/08/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

open class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionDuration: TimeInterval = 0.5
    var startingAlpha: CGFloat = 0.0

    public convenience init(transitionDuration: TimeInterval, startingAlpha: CGFloat) {
        self.init()
        self.transitionDuration = transitionDuration
        self.startingAlpha = startingAlpha
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

        toView.alpha = startingAlpha
        fromView.alpha = 0.8

        containerView.addSubview(toView)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { () -> Void in
            toView.alpha = 1.0
            fromView.alpha = 0.0
        }, completion: { _ in
            fromView.alpha = 1.0
            transitionContext.completeTransition(true)
        })
    }
}

class FadeInAnimatorVC: UIViewController {

    lazy var tb: TransitionSubmitButton = TransitionSubmitButton().with {
        $0.spinnerColor = .white
        $0.frame = CGRect(90, 90, 60, 40)
        $0.backgroundColor = .red
        $0.setTitle("close", for: UIControlState())
        $0.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        $0.addTarget(self, action: #selector(onTapScreen), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(tb)

        modalPresentationStyle = .custom
        transitioningDelegate = self

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func onTapScreen() {
        dismiss(animated: true, completion: nil)
    }
}


extension FadeInAnimatorVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator()
    }
}


