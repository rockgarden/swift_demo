//
//  FullScreenPopGesture.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 2017/2/21.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

/// This class add full screen gesture for UINavigationController, replace your class with it. It's very easy.
public class FullScreenPopGestureNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override public func viewDidLoad() {
        super.viewDidLoad()
        let target = self.interactivePopGestureRecognizer?.delegate
        let targetView = self.interactivePopGestureRecognizer!.view
        let handler: Selector = NSSelectorFromString("handleNavigationTransition:");
        let fullScreenGesture = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenGesture.delegate = self
        targetView?.addGestureRecognizer(fullScreenGesture)
        self.interactivePopGestureRecognizer?.enabled = false
    }

    // 每次触发手势之前判断导航控制器是否只有一个子控制器,若是则拦截手势触发 return false
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count == 1 ? false : true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
