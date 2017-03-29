//
//  TwoWayScrollViewVC.swift
//  UIScrollView
//
//  Created by wangkan on 2016/12/2.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class TwoWayScrollViewVC: UIViewController {

    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var childScrollView: ChildScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        childScrollView.scrollsToTop = false
        parentScrollView.panGestureRecognizer.delaysTouchesEnded = false
    }

}


internal class ChildScrollView: UIScrollView, UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            // FIXME: velocity always is (0,0)
            let velocity = panGesture.velocity(in: panGesture.view)
            let angle = fabs(atan2(velocity.y, velocity.x) * 180.0 / CGFloat(Float.pi))
            debugPrint([velocity, angle, panGesture.view!], separator: "/n", terminator: "*")
            if (angle >= 0 && angle <= 45) || (angle >= 135 && angle <= 180) {
            }
            else {
                return false
            }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true &&
            otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
            return true
        }
        return false
    }
    
}

