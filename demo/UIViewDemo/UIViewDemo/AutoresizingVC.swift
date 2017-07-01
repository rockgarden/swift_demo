//
//  ViewController.swift
//  Autoresizing
//
//  Created by wangkan on 2016/11/4.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class AutoresizingVC: AppBaseVC {

    let which = 1

    override func loadView() {
        switch which {
        case 1:
            let v = UIView()
            self.view = v
            v.backgroundColor = .green

        case 2: fallthrough
        default:
            // if you don't create a custom view in code...
            // ... then either don't implement loadView() or,
            // if you do, then call super so that the view is created
            /// 创建控制器管理的视图(用于在代码中创建自定义视图)。
            /// 你不应该直接调用这个方法。视图控制器在请求其视图属性时调用此方法，但当前为零。此方法加载或创建视图并将其分配给视图属性。
            /// 如果视图控制器具有关联的nib文件，则该方法从nib文件加载视图。如果nibName属性返回非零值，则视图控制器具有关联的nib文件，如果视图控制器从故事板中实例化，则会使用init（nibName：bundle :)方法将其指定为nib文件，或者如果iOS在应用程序包中找到一个基于视图控制器的类名称的名称的nib文件。如果视图控制器没有关联的nib文件，则此方法将创建一个简单的UIView对象。
            /// 如果使用Interface Builder创建视图并初始化视图控制器，则不得覆盖此方法。
            /// 您可以覆盖此方法，以手动创建视图。如果选择这样做，则将视图层次结构的根视图分配给视图属性。您创建的视图应该是唯一的实例，不应与任何其他视图控制器对象共享。您的这种方法的自定义实现不应该调用超级。
            /// 如果要对视图执行任何其他初始化，请在viewDidLoad（）方法中执行此操作。
            super.loadView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let v1 = UIView(frame:CGRect(x: 100, y: 111, width: 132, height: 194))
        v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView(frame:CGRect(x: 0, y: 0, width: 132, height: 10))
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView(frame:CGRect(x: v1.bounds.width-20, y: v1.bounds.height-20, width: 20, height: 20))
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(v1)
        v1.addSubview(v2)
        v1.addSubview(v3)

        v2.autoresizingMask = .flexibleWidth
        v3.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]

        let label = UILabel()
        view.addSubview(label)
        label.text = "Hello, World!"
        label.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleLeftMargin,
            .flexibleBottomMargin,
            .flexibleRightMargin]
        label.sizeToFit()
        label.center = CGPoint(view.bounds.midX, view.bounds.midY)
        label.frame = label.frame.integral

        delay(2) {
            v1.bounds.size.width += 40
            v1.bounds.size.height -= 50
            //v1.frame = mainview.bounds
            //v1.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            print(v2)
            print(v3)
        }

    }

}

