//
//  UIViewController_Swizzle.swift
//  UIViewController
//
//  Created by wangkan on 2017/10/13.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

// TODO: Swift 4 不能使用 override open static func initialize()
//fileprivate var interactiveNavigationBarHiddenAssociationKey: UInt8 = 0

//@IBDesignable extension UIViewController {
//
//    @IBInspectable public var interactiveNavigationBarHidden: Bool {
//        get {
//            var value = objc_getAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey)
//            if value == nil {
//                value = false
//            }
//            return value as! Bool
//        }
//        set {
//            objc_setAssociatedObject(self, &interactiveNavigationBarHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    override open static func initialize() {
//        if !didVCInitialized {
//            replaceInteractiveMethods()
//            didVCInitialized = true
//        }
//    }
//
//    fileprivate static func replaceInteractiveMethods() {
//        method_exchangeImplementations(
//            class_getInstanceMethod(self, #selector(UIViewController.viewWillAppear(_:)))!,
//            class_getInstanceMethod(self, #selector(UIViewController.interactiveViewWillAppear(_:)))!)
//    }
//
//    @objc fileprivate func interactiveViewWillAppear(_ animated: Bool) {
//        interactiveViewWillAppear(animated)
//        debugPrint("interactiveNavigationBarHidden", self, interactiveNavigationBarHidden)
//        navigationController?.setNavigationBarHidden(interactiveNavigationBarHidden, animated: animated)
//    }
//
//}
