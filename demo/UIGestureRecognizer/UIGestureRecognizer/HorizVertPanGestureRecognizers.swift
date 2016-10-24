//
//  HorizVertPanGestureRecognizers.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 16/8/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation
// and note use secondary import, essential to import hidden methods
import UIKit.UIGestureRecognizerSubclass

class HorizPanGestureRecognizer: UIPanGestureRecognizer {
	var origLoc: CGPoint!

	override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent) {
		self.origLoc = touches.first!.location(in: self.view!.superview)
		super.touchesBegan(touches, with: e)
	}

	override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent) {
		if self.state == .possible {
			let loc = touches.first!.location(in: self.view!.superview)
			let deltaX = fabs(loc.x - self.origLoc.x)
			let deltaY = fabs(loc.y - self.origLoc.y)
			if deltaY >= deltaX {
				self.state = .failed
			}
		}
		super.touchesMoved(touches, with: e)
	}

	override func translation(in view: UIView?) -> CGPoint {
		var proposedTranslation = super.translation(in: view)
		proposedTranslation.y = 0
		return proposedTranslation
	}

}

class VertPanGestureRecognizer: UIPanGestureRecognizer {
	var origLoc: CGPoint!

	override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent) {
		self.origLoc = touches.first!.location(in: self.view!.superview)
		super.touchesBegan(touches, with: e)
	}

	override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent) {
		if self.state == .possible {
			let loc = touches.first!.location(in: self.view!.superview)
			let deltaX = fabs(loc.x - self.origLoc.x)
			let deltaY = fabs(loc.y - self.origLoc.y)
			if deltaX >= deltaY {
				self.state = .failed
			}
		}
		super.touchesMoved(touches, with: e)
	}

	override func translation(in view: UIView?) -> CGPoint {
		var proposedTranslation = super.translation(in: view)
		proposedTranslation.x = 0
		return proposedTranslation
	}

}
