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
        /// 一个布尔值，用于确定接收者是否延迟将结束阶段的触摸发送到其视图。
        /// 当此属性的值为true（默认值）并且接收方正在分析触摸事件时，窗口会将结束阶段中的触摸对象的传送暂挂到附加视图。如果手势识别器随后识别其手势，则取消这些触摸对象（通过touchesCancelled（_：with :)消息）。如果手势识别器无法识别其手势，则窗口会在调用视图的touchesEnded（_：with :)方法时传递这些对象。将此属性设置为false，以便在手势识别器正在分析相同的触摸时，将已结束的触摸对象传送到视图。
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
                return true
            } else {
                return false
            }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true &&
            otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
            // false = 两个View不同时响应 UIPanGestureRecognizer, 一个动另一个不动, 细节参考UIGestureRecognizer工程
            return false
        }
        return true
    }
    
}

