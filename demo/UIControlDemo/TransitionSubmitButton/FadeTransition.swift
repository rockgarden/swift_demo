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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func onTapScreen() {
        dismiss(animated: true, completion: nil)
    }
}
