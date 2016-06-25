//
//  Ext_UIViewController.swift
//  基于运行时中关联对象(associated objects)和方法交叉(method swizzling)实现
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

private var didKDVCInitialized = false
private var interactiveNavigationBarHiddenAssociationKey: UInt8 = 0

@IBDesignable
extension UIViewController {

	/**
	 *  向工程里所有的 view controllers 中添加一个 descriptiveName 属性
	 *  在私有嵌套 struct 中使用 static var 这样生成的关联对象键不会污染整个命名空间
	 */
	private struct descriptiveAssociatedKeys {
		static var DescriptiveName = "rockgarden power"
	}

	var descriptiveName: String? {
		get {
			return objc_getAssociatedObject(self, &descriptiveAssociatedKeys.DescriptiveName) as? String
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&descriptiveAssociatedKeys.DescriptiveName,
					newValue as NSString?,
						.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}

	@IBInspectable
	public var interactiveNavigationBarHidden: Bool {
		get {
			let associateValue = objc_getAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey) ?? false
			return associateValue as! Bool
		}
		set {
			objc_setAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	/**
	 方法交叉发生在 initialize 类方法调用时

	 - returns: <#return value description#>
	 */
	override public class func initialize() { // 也可用 override public static func initialize()

		struct Static {
			static var token: dispatch_once_t = 0
		}

		// make sure this isn't a subclass
		if self !== UIViewController.self {
			return
		}

		dispatch_once(&Static.token) {
			if !didKDVCInitialized {
				SwizzleMethod(self, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.interactiveViewWillAppear(_:)))
				didKDVCInitialized = true
			}
		}
	}

	func interactiveViewWillAppear(animated: Bool) {
		interactiveViewWillAppear(animated)
		if let name = self.descriptiveName {
			debugPrint("viewWillAppear: \(name)")
		} else {
			debugPrint("viewWillAppear: \(self)")
		}
		debugPrint("ViewWillAppear setNavigationBarHidden: \(interactiveNavigationBarHidden)")
		navigationController?.setNavigationBarHidden(interactiveNavigationBarHidden, animated: animated)
	}

	func km_containerViewBackgroundColor() -> UIColor {
		return UIColor.whiteColor()
	}

}