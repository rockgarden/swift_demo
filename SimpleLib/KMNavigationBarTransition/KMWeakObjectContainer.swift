//
//  KMWeakObjectContainer.swift
//  KMNavigationBarTransition
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 Zhouqi Mo. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

class KMWeakObjectContainer: NSObject {
    weak var object: AnyObject?
    let wrapper = KMWeakObjectContainer()

    func km_objc_setAssociatedWeakObject(_ container: AnyObject, _ key: UnsafeRawPointer, _ value: AnyObject) {
        self.object = value
        objc_setAssociatedObject(container, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func km_objc_getAssociatedWeakObject(_ container: AnyObject, _ key: UnsafeRawPointer ) -> AnyObject {
        self.object = objc_getAssociatedObject(container, key) as AnyObject?
        return object!
    }
}
