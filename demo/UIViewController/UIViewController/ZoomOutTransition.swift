//
//  ZoomOutTransition.swift
//  UIViewController
//
//  Created by wangkan on 2017/7/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


import UIKit

open class ZoomOutTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionDuration: TimeInterval = 0.8
    var originFrame = CGRect.zero

    public convenience init(originFrame: CGRect) {
        self.init()
        self.originFrame = originFrame
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!

        let initialFrame = fromView.frame
        let finalFrame = originFrame

        let xScaleFactor = finalFrame.width / initialFrame.width
        let yScaleFactor = finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        containerView.addSubview(toView)
        containerView.addSubview(fromView)

        UIView.animate(withDuration: transitionDuration,
                       animations: {
                        fromView.transform = scaleTransform
                        fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        fromView.alpha = 1.0

        }) { _ in
            fromView.alpha = 0.0
            transitionContext.completeTransition(true)
        }
    }
    
}

