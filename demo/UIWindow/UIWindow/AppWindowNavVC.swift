//
//  AppWindowNavVC.swift
//

import Foundation
import UIKit

let kHeaderHeight: CGFloat = 120

// TODO: 移动入 AppDelegate 可让 所有的 VC 都可调用 back windows
open class AppWindowNavVC: UINavigationController {
    
    private var firstX = Float()
    private var firstY = Float()
    private var _origin = CGPoint()
    private var _final = CGPoint()
    private var duration = CGFloat()
    private var window: UIWindow!
    private var panGesture = UIPanGestureRecognizer()
    
    override open func viewDidLoad() {
        /// 获取AppDelegate.window 也可自己生成 UIWindow() 再赋值给 AppDelegate.window, 但这样做需要给 AppDelegate.window 增加 set 方法
        window = (UIApplication.shared.delegate as! AppDelegate).window!
        window.layer.shadowRadius = 15
        window.layer.shadowOffset = CGSize(width: 0, height: 0)
        window.layer.shadowColor = UIColor.black.cgColor
        window.layer.shadowOpacity = 0.8
        duration = 0.3

        activateSwipeToOpenMenu(true)
    }
    
    func activateSwipeToOpenMenu(_ onlyNavigation: Bool) {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        
        if (onlyNavigation == true) {
            self.navigationBar.addGestureRecognizer(panGesture)
        } else {
            window.addGestureRecognizer(panGesture)
        }
    }
    
    func openAndClose() {
        var finalOrigin = CGPoint()
        var f = CGRect()
        
        f = window.frame
        
        if (f.origin.y == CGPoint.zero.y) {
            finalOrigin.y = UIScreen.main.bounds.height - kHeaderHeight
        } else {
            finalOrigin.y = CGPoint.zero.y
        }
        
        finalOrigin.x = 0
        f.origin = finalOrigin
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.window.transform = CGAffineTransform.identity
            self.window.frame = f
            },
            completion: nil)
    }
    
    func setAnimationDuration(_ d:CGFloat) {
        duration = d
    }

    //FIXME: drag view 异常
    func onPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: window)
        let velocity = pan.velocity(in: window)
        
        switch (pan.state) {
        case .began:
            _origin = window.frame.origin
            break
            
        case .changed:
            if (_origin.y + translation.y >= 0) {
                if (window.frame.origin.y != CGPoint.zero.y) {
                    window.transform = CGAffineTransform(translationX: 0, y: translation.y)
                } else {
                    window.transform = CGAffineTransform(translationX: 0, y: translation.y)
                }
            }
            break
            
        case .ended:
            break
            
        case .cancelled:
            var finalOrigin = CGPoint.zero
            if (velocity.y >= 0) {
                finalOrigin.y = UIScreen.main.bounds.height - kHeaderHeight
            }
            
            var f = window.frame
            f.origin = finalOrigin
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.window.transform = CGAffineTransform.identity
                self.window.frame = f
                }, completion: nil)
            break
            
        default:
            break
        }
    }
    
}
