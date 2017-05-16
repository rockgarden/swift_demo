//
//  TransitionDismissAnimator.swift
//
//  Created by Beomseok Seo on 3/26/16.
//  Copyright © 2016 Predle. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}


class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        
        let fromVC = ctx.viewController(forKey: .from)!
        let toVC = ctx.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = ctx.containerView
        
        let masterVC = toVC as? TransitionImageCollectionVC
        let detailVC = fromVC as? ImageDetailVC
        
        let originalFrame = detailVC?.getOriginalImageFrame()
        
        let imageView = (detailVC?.getImageView())!
        imageView.contentMode = .scaleAspectFill
        containerView.addSubview(imageView)
        
        let animationDuration = self.transitionDuration(using: ctx)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [],
                       animations: { () -> Void in
                        imageView.frame = originalFrame!
                        fromVC.view.alpha = 0.0
        }, completion: { (finished) -> Void in
            masterVC?.showSelectedImageView(originalFrame!)
            imageView.removeFromSuperview()
            ctx.completeTransition(!ctx.transitionWasCancelled)
        })
        
    }
}


class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var frame: CGRect?
    var imageName: String?
    
    convenience init(frame: CGRect, imageName: String) {
        self.init()
        self.frame = frame
        self.imageName = imageName
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using ctx: UIViewControllerContextTransitioning) {
        _ = ctx.viewController(forKey: .from)!
        let toVC = ctx.viewController(forKey: .to)!
        let containerView = ctx.containerView
        
        let animationDuration = self.transitionDuration(using: ctx)
        
        let detailVC = toVC as! ImageDetailVC
        detailVC.setOriginalImageFrame(frame!)
        
        toVC.view.alpha = 0.0
        containerView.addSubview(toVC.view)
        
        let imageView = UIImageView(frame: frame!)
        let image = UIImage(named: imageName!)!
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true
        containerView.addSubview(imageView)
        
        let ratio = image.size.width/image.size.height
        let viewHeight = UIScreen.main.bounds.size.width / ratio
        let viewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewHeight)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [],
                       animations: { () -> Void in
                        imageView.frame = viewFrame
                        imageView.center = containerView.center
                        toVC.view.alpha = 1.0
        }, completion: { (finished) -> Void in
            imageView.contentMode = .scaleAspectFit
            detailVC.setImageView(imageView)
            ctx.completeTransition(finished)
        })
    }
}

