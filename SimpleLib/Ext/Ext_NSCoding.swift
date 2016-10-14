//
//  ExtKIT
//  NSCoding.swift
//  MemoryInMap
//
//
//  Created by wangkan on 16/6/6.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation

// MARK: - 关联对象 方法交叉 仅在不得已的情况下使用 Objective-C runtime !!!
extension NSCoding {

	/**
	 Objective-C 关联对象(Associated Objects) Set

	 - parameter container: <#container description#>
	 - parameter key:       <#key description#>
	 - parameter value:     <#value description#>
	 */
	func objc_setAssociatedWeakObject(_ container: AnyObject, _ key: UnsafeRawPointer, _ value: AnyObject) {
		objc_setAssociatedObject(container, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}

	/**
	 Objective-C 关联对象(Associated Objects) Get

	 - parameter container: <#container description#>
	 - parameter key:       <#key description#>

	 - returns: <#return value description#>
	 */
	func objc_getAssociatedWeakObject(_ container: AnyObject, _ key: UnsafeRawPointer) -> AnyObject {
		let object: AnyObject? = objc_getAssociatedObject(container, key) as AnyObject?
		return object!
	}

	/**
	 Objective-C方法交叉 method swizzling

	 - parameter cls:              <#cls description#>
	 - parameter originalSelector: <#originalSelector description#>
	 - parameter swizzledSelector: <#swizzledSelector description#>
	 */
	public static func SwizzleMethod(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
		let originalMethod = class_getInstanceMethod(cls, originalSelector)
		let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
		let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
		if didAddMethod {
			class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod)
		}
	}

	// static func SwizzleMethod(cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
	// let originalMethod = class_getInstanceMethod(cls, originalSelector)
	// let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
	// let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
	// if didAddMethod {
	// class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
	// } else {
	// method_exchangeImplementations(originalMethod, swizzledMethod)
	// }
	// }

}
