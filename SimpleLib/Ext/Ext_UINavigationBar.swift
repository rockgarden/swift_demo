//
//  ExtKIT
//  Ext_NavBar.swift
//  MemoryInMap
//
//  Created by wangkan on 16/5/26.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import Foundation
import UIKit

private var kBackgroundViewKey = "kBackgroundViewKey"
private var kStatusBarMaskKey = "kStatusBarMaskKey"

extension UINavigationBar {

	public func mSetStatusBarMaskColor(color: UIColor) {
		if statusBarMask == nil {
			statusBarMask = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: 20))
			statusBarMask?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			if let tempBackgroundView = backgroundView {
				insertSubview(statusBarMask!, aboveSubview: tempBackgroundView)
			} else {
				insertSubview(statusBarMask!, atIndex: 0)
			}
		}
		statusBarMask?.backgroundColor = color
	}

	// TODO:判断statusBar有否隐藏
	public func mSetBackgroundColor(color: UIColor) {
		if backgroundView == nil {
			setBackgroundImage(UIImage(), forBarMetrics: .Default)
			shadowImage = UIImage()
			backgroundView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: 64))
			backgroundView?.userInteractionEnabled = false
			backgroundView?.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
			insertSubview(backgroundView!, atIndex: 0)
		}
		backgroundView?.backgroundColor = color
	}

	public func resetBackgroundColor() {
		setBackgroundImage(nil, forBarMetrics: .Default)
		shadowImage = nil
		backgroundView?.removeFromSuperview()
		backgroundView = nil
	}

	// MARK: Properties
	private var backgroundView: UIView? {
		get {
			return objc_getAssociatedObject(self, &kBackgroundViewKey) as? UIView
		}
		set {
			objc_setAssociatedObject(self, &kBackgroundViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	private var statusBarMask: UIView? {
		get {
			return objc_getAssociatedObject(self, &kStatusBarMaskKey) as? UIView
		}
		set {
			objc_setAssociatedObject(self, &kStatusBarMaskKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
    
}