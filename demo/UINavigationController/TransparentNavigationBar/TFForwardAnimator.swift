//
//  TFForwardAnimator.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

class TFForwardAnimator: TFNavigationBarAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.33
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let toView = context.view(forKey: UITransitionContextViewKey.to)!
        let fromView = context.view(forKey: UITransitionContextViewKey.from)!
        let duration = self.transitionDuration(using: context)
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotView(afterScreenUpdates: false)
        
        // Create snapshot of navigation bar
        let navbarSnapshot = navigationController.navigationBar.resizableSnapshotView(from: navigationController.navigationBar.bounds.additiveRect(20, direction: .top), afterScreenUpdates: false, withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        
        // Save snapshot of navigation bar for pop animation
        if let index = self.navigationController.viewControllers.index(of: fromViewController) {
            navigationController.navigationBarSnapshots[index] = navbarSnapshot
        }
        
        // Insert toView above from view
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        // Insert fromView snapshot above fromView
        containerView.insertSubview(fromViewSnapshot!, belowSubview: toView)
        
        // hide fromView and use snapshot instead
        fromView.isHidden = true
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        let navigationControllerFrame = navigationController.view.frame
        
        if self.navigationBarStyleTransition == .toSolid {
            
            let shiftedFrame = navigationControllerFrame.additiveRect(-64, direction: .top)
            // Move toView to the right
            toView.frame = shiftedFrame.offsetBy(dx: shiftedFrame.width, dy: 0)
            
        } else if (self.navigationBarStyleTransition == .toTransparent) {
            // Move toView to the right
            toView.frame = navigationControllerFrame.offsetBy(dx: navigationControllerFrame.width, dy: 0)
        }
        
        let toViewFinalFrame: CGRect = toView.frame.offsetBy(dx: -toView.frame.width, dy: 0)
        
        // Calculate final frame for fromView and fromViewSnapshot
        let fromViewFinalFrame = navigationControllerFrame.offsetBy(dx: -(navigationControllerFrame.width * 0.3), dy: 0)
        
        // Save origin navigation bar frame
        let navigationBarFrame = self.navigationController.navigationBar.frame
        // Shift bar
        self.navigationController.navigationBar.frame = navigationBarFrame.offsetBy(dx: navigationBarFrame.width, dy: 0)
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: { () -> Void in
            
            // Shift toView to the left
            toView.frame = toViewFinalFrame
            // Shift fromView to the left
            fromViewSnapshot?.frame = fromViewFinalFrame
            // Shift navigation bar
            self.navigationController.navigationBar.frame = navigationBarFrame
            
            }, completion: { (completed) -> Void in
                // Show fromView
                fromView.frame = fromViewFinalFrame
                fromView.isHidden = false
                // Remove snapshot
                fromViewSnapshot?.removeFromSuperview()
                // Inform about transaction completion state
                context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
