//
//  ViewController.swift
//  transform
//
//  Created by wangkan on 2016/10/11.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

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
		default: break
		}
        which = which < 7 ? which+1 : 1
	}
}

