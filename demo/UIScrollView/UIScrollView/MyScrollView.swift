//
//  MyScrollView.swift
//  scrollviews
//
//  Created by M.Satori on 15.12.17.
//  Copyright © 2015 usagimaru. All rights reserved.
//

import UIKit

class MyScrollView: UIScrollView, UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
			let panGesture: UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
			let velocity = panGesture.velocity(in: panGesture.view)
			let angle = fabs(atan2(velocity.y, velocity.x) * 180.0 / CGFloat(M_PI))
			debugPrint([velocity, angle], separator: "/n", terminator: "*")
			if (angle >= 0 && angle <= 45) || (angle >= 135 && angle <= 180) {}
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
