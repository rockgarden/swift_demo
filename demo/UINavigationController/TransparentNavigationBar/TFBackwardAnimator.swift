//
//  TFBackwardAnimator.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

class TFBackwardAnimator: TFNavigationBarAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    func removeAnimationsForViews(_ views: [UIView]) {
        for view in views {
            view.layer.removeAllAnimations()
            removeAnimationsForViews(view.subviews)
        }
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let toView = context.view(forKey: UITransitionContextViewKey.to)!
        let fromView = context.view(forKey: UITransitionContextViewKey.from)!
        let duration = self.transitionDuration(using: context)

        let fromFrame = context.initialFrame(for: fromViewController)
        
        var toViewControllerNavigationBarSnapshot: UIView!
        
        let index = navigationController.viewControllers.index(of: toViewController)
        let navigationBarSnapshot = self.navigationController.navigationBarSnapshots[index!]
        toViewControllerNavigationBarSnapshot = navigationBarSnapshot
        
        // Disable user interaction
        toView.isUserInteractionEnabled = false
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotView(afterScreenUpdates: false)
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        fromView.isHidden = true

        // Insert toView below fromView
        containerView.insertSubview(toView, belowSubview: fromView)
        
        // Insert fromView snapshot
        containerView.insertSubview(fromViewSnapshot!, aboveSubview: fromView)
        
        containerView.insertSubview(toViewControllerNavigationBarSnapshot, aboveSubview: toView)
        
        let navigationControllerFrame = navigationController.view.frame
        var toFrame: CGRect = fromFrame.offsetBy(dx: -(fromFrame.width * 0.3), dy: 0)
        var fromViewFinalFrame: CGRect = fromView.frame.offsetBy(dx: fromView.frame.width, dy: 0)
        
        if self.navigationBarStyleTransition == .toSolid {
            // Set move toView to the left about 30% of its width
            toView.frame = fromFrame.offsetBy(dx: -(fromFrame.width * 0.3), dy: 0)
            toFrame = fromFrame
            // Final frame for fromView and fromViewSnapshot
            fromViewFinalFrame = fromView.frame.offsetBy(dx: fromView.frame.width, dy: 0)
            
        } else if (self.navigationBarStyleTransition == .toTransparent) {
            // Set move toView to the left about 30% of its width
            toView.frame = navigationControllerFrame.offsetBy(dx: -(navigationControllerFrame.width * 0.3), dy: 0)
            toFrame = navigationControllerFrame
            // Final frame for fromView and fromViewSnapshot
            fromViewFinalFrame = navigationControllerFrame.offsetBy(dx: navigationControllerFrame.width, dy: 0)
        }
        
        // Save origin navigation bar frame
        let navigationBarFrame = self.navigationController.navigationBar.frame
        // Shift bar
        self.navigationController.navigationBar.frame = navigationBarFrame.offsetBy(dx: -navigationBarFrame.width, dy: 0)

        let snapshotframe = navigationBarFrame.additiveRect(20, direction: .top)
        
        toViewControllerNavigationBarSnapshot.frame = snapshotframe.offsetBy(dx: -(snapshotframe.width * 0.3), dy: 0)

        
        if self.isInteractive {
//            let navbar = UINavigationBar(frame: navigationBarFrame)
//            self.navigationController.view.insertSubview(navbar, aboveSubview: toView)
//            
//            if let items = self.navigationController.navigationBar.items {
//                navbar.setItems([items[items.count-2]], animated: false)
//            }
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
            
            
            // Shift fromView to the right
            fromViewSnapshot?.frame = fromViewFinalFrame
            // Shift fromView to the right
            toView.frame = toFrame
            
            toViewControllerNavigationBarSnapshot.frame = snapshotframe
            
            if self.isInteractive {
                self.navigationController.navigationBar.alpha = 1.0
            }
            
            }, completion: { (completed) -> Void in
                // Enable user interaction
                toView.isUserInteractionEnabled = true
                // Remove snapshot
                fromViewSnapshot?.removeFromSuperview()
                toViewControllerNavigationBarSnapshot.removeFromSuperview()
                
                self.navigationController.navigationBar.alpha = 1.0
                
                self.navigationController.navigationBar.frame = navigationBarFrame
                
                if context.transitionWasCancelled {
                    
                    self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition.reverse())
                    
                    
                    fromView.isHidden = false
                    
                }
                
                context.completeTransition(!context.transitionWasCancelled)
        })
    }

    
}
