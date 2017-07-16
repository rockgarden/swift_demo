//
//  ViewController.swift
//  TintColor
//
//  Created by wangkan on 2016/12/25.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

/**
 tintColor 是 iOS7.0 引入的一个 UIView 的属性. tintColor 是 UIView 的属性, 可被子类继承与重写。
 继承: 只要一个 UIView 的 subview 没有明确指定 tintColor, 那么这个 view 的 tintColor 就会被它的 subview 所继承! 在一个 App 中, 最顶层的 view 就是 window, 因此, 只要修改 window 的 tintColor, 那么所有 view 的 tintColor 就都会跟着改变.
 重写: 如果明确指定了某个 view 的 tintColor, 那么这个 view 就不会继承其 superview 的 tintColor, 而且自此, 这个 view 的 subview 的 tintColor 会发生改变.
 传播:一个 view 的 tintColor 的改变会立即向下传播, 影响其所有的 subview, 直至它的一个 subview 明确指定了 tintColor 为止.
 */

import UIKit

class TintColorVC: UIViewController {

    var blue = true

    @IBAction func doToggleTint(_ sender: Any) {
        self.blue = !self.blue
        view.tintColor = self.blue ? nil : UIColor.red
    }

    var dim = false

    @IBAction func doToggleDimming(_ sender: Any) {
        self.dim = !self.dim
        view.tintAdjustmentMode = self.dim ? .dimmed : .automatic
    }

}

