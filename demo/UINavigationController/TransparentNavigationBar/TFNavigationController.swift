//
//  TFNavigationController.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//  https://github.com/thefuntasty/TFTransparentNavigationBar
//

import UIKit

@objc public enum TFNavigationBarStyle: Int {
    case transparent, solid
}

@objc public protocol TFTransparentNavigationBarProtocol {
    func navigationControllerBarPushStyle() -> TFNavigationBarStyle
}

open class TFNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    fileprivate var temporaryBackgroundImage: UIImage?
    var navigationBarSnapshots = Dictionary<Int, UIView>()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = UIImage()

        transitioningDelegate = self   // for presenting the original navigation controller
        delegate = self                // for navigation controller custom transitions
        //interactivePopGestureRecognizer?.delegate = nil
        
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(TFNavigationController.handleSwipeFromLeft(_:)))
        left.edges = .left
        self.view.addGestureRecognizer(left);
    }
    
    func handleSwipeFromLeft(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = gesture.translation(in: gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            if viewControllers.count > 1 {
                /// UINavigationController: 从导航堆栈弹出顶视图控制器并更新显示。此方法将顶视图控制器从堆栈中移除，并使堆栈的新顶部成为主动视图控制器。 如果堆叠顶部的视图控制器是根视图控制器，则此方法不执行任何操作。 换句话说，您无法弹出堆栈上的最后一个项目。除了显示与堆叠顶部的新视图控制器相关联的视图之外，该方法还会相应地更新导航栏和工具栏。 有关导航栏如何更新的信息，请参阅更新导航栏。
                popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed {
            if percent > 0.5 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
    
    
    // MARK: - UIViewControllerTransitioningDelegate

    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.forwardAnimator(source, toViewController: presented)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (viewControllers.count < 2) {
            return nil
        }
        // Last but one controller in stack
        let previousController = self.viewControllers[self.viewControllers.count - 2]
        return self.backwardAnimator(dismissed, toViewController: previousController)
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    // MARK: - UINavigationControllerDelegate
    
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self.forwardAnimator(fromVC, toViewController: toVC)
        } else if operation == .pop {
            return self.backwardAnimator(fromVC, toViewController: toVC)
        }
        return nil
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    // MARK: - Helpers
    
    fileprivate func forwardAnimator(_ fromViewController: UIViewController, toViewController: UIViewController) -> TFForwardAnimator? {
    
        var fromStyle: TFNavigationBarStyle = TFNavigationBarStyle.solid
        
        if let source = fromViewController as? TFTransparentNavigationBarProtocol {
            fromStyle = source.navigationControllerBarPushStyle()
        }
        
        var toStyle: TFNavigationBarStyle = TFNavigationBarStyle.solid
        
        if let presented = toViewController as? TFTransparentNavigationBarProtocol {
            toStyle = presented.navigationControllerBarPushStyle()
        }
        
        var styleTransition: TFNavigationBarStyleTransition!
        
        if fromStyle == .solid && toStyle == .solid {
            return nil
        } else if (fromStyle == .transparent && toStyle == .transparent) {
            styleTransition = .toSame
        } else if fromStyle == .transparent && toStyle == .solid {
            styleTransition = .toSolid
        } else if fromStyle == .solid && toStyle == .transparent {
            styleTransition = .toTransparent
        }
        
        return TFForwardAnimator(navigationController: self, navigationBarStyleTransition: styleTransition, isInteractive: interactionController != nil)
    }
    
    fileprivate func backwardAnimator(_ fromViewController: UIViewController, toViewController: UIViewController) -> TFBackwardAnimator? {
        
        var fromStyle: TFNavigationBarStyle = TFNavigationBarStyle.solid
        
        if let fromViewController = fromViewController as? TFTransparentNavigationBarProtocol {
            fromStyle = fromViewController.navigationControllerBarPushStyle()
        }
        
        var toStyle: TFNavigationBarStyle = TFNavigationBarStyle.solid
        
        if let toViewController = toViewController as? TFTransparentNavigationBarProtocol {
            toStyle = toViewController.navigationControllerBarPushStyle()
        }
        var styleTransition: TFNavigationBarStyleTransition!
        
        if fromStyle == toStyle {
            styleTransition = .toSame
        } else if fromStyle == .solid && toStyle == .transparent {
            styleTransition = .toTransparent
        } else if fromStyle == .transparent && toStyle == .solid {
            styleTransition = .toSolid
        }
        
        return TFBackwardAnimator(navigationController: self, navigationBarStyleTransition: styleTransition, isInteractive: interactionController != nil)
    }
    
    
    func setupNavigationBarByStyle(_ transitionStyle: TFNavigationBarStyleTransition) {
        if (transitionStyle == .toTransparent) {
            // set navbar to translucent
            self.navigationBar.isTranslucent = true
            // and make it transparent
            self.temporaryBackgroundImage = self.navigationBar.backgroundImage(for: .default)
            self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        } else if (transitionStyle == .toSolid) {
            self.navigationBar.isTranslucent = false
            self.navigationBar.setBackgroundImage(temporaryBackgroundImage, for: UIBarMetrics.default)
        }
    }
    
}

