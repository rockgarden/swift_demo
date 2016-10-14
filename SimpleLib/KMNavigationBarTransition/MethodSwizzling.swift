//
//  KMSwizzle.swift
//  KMNavigationBarTransition
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

open class MethodSwizzling: NSObject {

     open func SwizzlingMethod(_ cls: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
		let originalMethod = class_getInstanceMethod(cls, originalSelector)
		let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
		let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
		if didAddMethod {
			class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod)
		}
	}

}
