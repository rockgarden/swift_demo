//
//  ViewController.swift
//  transform
//
//  Created by wangkan on 2016/10/11.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit


/// Transform 指定应用于接收器的变换，相对于其边界的中心。
/// 变换的原点是中心属性的值，或层的anchorPoint属性（如果已更改）。 （使用layer属性获取底层的Core Animation图层对象。）默认值为CGAffineTransformIdentity。
/// 此属性的更改可以动画。 使用beginAnimations（_：context :)类方法开始，并使用commitAnimations（）类方法来结束动画块。 默认值是中心值的任何值（如果改变了锚定点）
/// 在iOS 8.0及更高版本中，transform属性不会影响自动布局。 自动布局根据其未转换的框架计算视图的对齐矩形。
/// 警告 如果此属性不是标识转换，则frame属性的值未定义，因此应该被忽略。
class TransformVC: UIViewController {

	var which = 1
    var mainview: UIView!
    let cf = 45 * CGFloat(Double.pi) / 180.0

	override func viewDidLoad() {
		super.viewDidLoad()
        mainview = self.view
    }

    @IBAction func doWhich(_ sender: Any) {
        var v1, v2: UIView!

        for v in mainview.subviews {
            v.removeFromSuperview()
        }

        (sender as? UIButton)?.setTitle("Case \(which)", for: .normal)

        func add127() {
            v1 = UIView(frame: CGRect(x: 113, y: 111, width: 132, height: 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            v2 = UIView(frame: v1.bounds.insetBy(dx: 10, dy: 10))
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview?.addSubview(v1)
            v1.addSubview(v2)
        }

        func add3456() {
            v1 = UIView(frame: CGRect(x: 20, y: 111, width: 132, height: 194))
            v1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
            v2 = UIView(frame: v1.bounds)
            v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
            mainview?.addSubview(v1)
            v1.addSubview(v2)
        }

		switch which {
		case 1:
            add127()
			v1.transform = CGAffineTransform(rotationAngle: cf)
		case 2:
            add127()
            v1.transform = CGAffineTransform(scaleX: 2.0, y: 1.0)
		case 3:
			add3456()
			v2.transform = CGAffineTransform(translationX: 100, y: 0)
			v2.transform = v2.transform.rotated(by: cf)
		case 4:
            add3456()
			v2.transform = CGAffineTransform(rotationAngle: cf)
			v2.transform = v2.transform.translatedBy(x: 100, y: 0)
		case 5: // same as case 4 but using concat
			add3456()
			let r = CGAffineTransform(rotationAngle: cf)
			let t = CGAffineTransform(translationX: 100, y: 0)
			v2.transform = t.concatenating(r) // not r,t
		case 6:
            add3456()
			let r = CGAffineTransform(rotationAngle: cf)
			let t = CGAffineTransform(translationX: 100, y: 0)
			v2.transform = t.concatenating(r)
			v2.transform = r.inverted().concatenating(v2.transform)
		case 7:
			add127()
			v1.transform = CGAffineTransform(a: 1, b: 0, c: -0.2, d: 1, tx: 0, ty: 0)
        case 8:
            add3456()
            v2.transform = CGAffineTransform(translationX:100, y:0).rotated(by: 45 * .pi/180)
        case 9:
            add3456()
            v2.transform = CGAffineTransform(rotationAngle:45 * .pi/180).translatedBy(x: 100, y: 0)
        case 10:
            add3456()
            let r = CGAffineTransform(rotationAngle:45 * .pi/180)
            let t = CGAffineTransform(translationX:100, y:0)
            /// concatenating 返回通过组合两个现有仿射变换构造的仿射变换矩阵。
            /// 连接将两个仿射变换矩阵相乘在一起。 您可以执行多个连接，以创建包含多个转换的累积效果的单个仿射变换。
            /// 请注意，矩阵运算不可交换 - 您连接矩阵的顺序很重要。 也就是说，将矩阵t1乘以矩阵t2的结果不一定等于将矩阵t2乘以矩阵t1的结果。
            v2.transform = t.concatenating(r)
        case 11:
            add3456()
            let r = CGAffineTransform(rotationAngle:45 * .pi/180)
            let t = CGAffineTransform(translationX:100, y:0)
            v2.transform = t.concatenating(r)
            /// inverted 返回通过反转现有仿射变换构造的仿射变换矩阵。
            /// 逆向通常用于提供变换对象内的点的逆向变换。 给定已经通过给定矩阵变换为新坐标（x'，y'）的坐标（x，y），将坐标（x'，y'）变换逆矩阵产生原始坐标（x，y））
            v2.transform = r.inverted().concatenating(v2.transform)
		default: break
		}
        which = which < 11 ? which+1 : 1
	}
}

