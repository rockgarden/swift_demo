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

    func km_objc_setAssociatedWeakObject(container: AnyObject, _ key: UnsafePointer<Void>, _ value: AnyObject) {
        self.object = value
        objc_setAssociatedObject(container, key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func km_objc_getAssociatedWeakObject(container: AnyObject, _ key: UnsafePointer<Void> ) -> AnyObject {
        self.object = objc_getAssociatedObject(container, key)
        return object!
    }
}