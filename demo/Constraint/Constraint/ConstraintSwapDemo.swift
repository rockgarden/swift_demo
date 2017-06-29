//
//  ConstraintSwapDemo.swift
//  Constraint
//
//  Created by wangkan on 16/9/18.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ConstraintSwapDemo: UIViewController {

	let v = UIView()
	var v0: UIView!
	var v1: UIView!
	var v2: UIView!
	var v3: UIView!
	var constraintsWith = [NSLayoutConstraint]()
	var constraintsWithout = [NSLayoutConstraint]()

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("here")
		super.touchesBegan(touches, with: event)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let mainView = view

		v.backgroundColor = .red
		v.translatesAutoresizingMaskIntoConstraints = false
		mainView?.addSubview(v)

        /// 示例 metrics 的用法
		NSLayoutConstraint.activate([
			NSLayoutConstraint.constraints(withVisualFormat: "H:|-(mh)-[v]-(0)-|", options: [], metrics: ["mh":60], views: ["v": v]),
			NSLayoutConstraint.constraints(withVisualFormat: "V:|-(mv)-[v]-(0)-|", options: [], metrics: ["mv":20], views: ["v": v])
			].joined().map { $0 })

        /// 一个布尔值，表示当前视图是否也尊重其superview的边距。当此属性的值为true时，在布局内容时也会考虑超级视图的边距。此边距影响布局，其中视图的边缘与其超级视图之间的距离小于对应的边距。例如，您可能有一个内容视图的帧精确匹配其superview的边界。当任何超级视图的边距在内容视图所表示的区域及其自身的边距内时，UIKit会调整内容视图的布局以尊重超级视图的边距。调整量是确保内容也在超级视图边缘内所需的最小量。此属性的默认值为false。
		v.preservesSuperviewLayoutMargins = true //experiment by commenting out this line

		let v0 = UIView()
		v0.backgroundColor = .green
		v0.translatesAutoresizingMaskIntoConstraints = false
		v.addSubview(v0)

		let v1 = UIView()
		v1.backgroundColor = .red
		v1.translatesAutoresizingMaskIntoConstraints = false
		let v2 = UIView()
		v2.backgroundColor = .yellow
		v2.translatesAutoresizingMaskIntoConstraints = false
		let v3 = UIView()
		v3.backgroundColor = .blue
		v3.translatesAutoresizingMaskIntoConstraints = false
		v0.addSubview(v1)
		v0.addSubview(v2)
		v0.addSubview(v3)

		self.v0 = v0
		self.v1 = v1
		self.v2 = v2
		self.v3 = v3

        // MARK: 配置 V0
		var which0: Int { return 3 }
		switch which0 {
		case 1:
			NSLayoutConstraint.activate([
				NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]-|", options: [], metrics: nil, views: ["v1": v0]),
				NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v1]-|", options: [], metrics: nil, views: ["v1": v0])
				].joined().map { $0 })
		case 2:
			/// new notation treats margins as a pseudoview伪视图 (UILayoutGuide)
			NSLayoutConstraint.activate([
				v0.topAnchor.constraint(equalTo: v.layoutMarginsGuide.topAnchor),
				v0.bottomAnchor.constraint(equalTo: v.layoutMarginsGuide.bottomAnchor),
				v0.trailingAnchor.constraint(equalTo: v.layoutMarginsGuide.trailingAnchor),
				v0.leadingAnchor.constraint(equalTo: v.layoutMarginsGuide.leadingAnchor)
			])
		case 3:
			// new kind of margin, "readable content"
			// particularly dramatic on iPad in landscape
			NSLayoutConstraint.activate([
				v0.topAnchor.constraint(equalTo: v.readableContentGuide.topAnchor),
				v0.bottomAnchor.constraint(equalTo: v.readableContentGuide.bottomAnchor),
				v0.trailingAnchor.constraint(equalTo: v.readableContentGuide.trailingAnchor),
				v0.leadingAnchor.constraint(equalTo: v.readableContentGuide.leadingAnchor)
			])
			default: break
		}

        // MARK: SWAP
		// construct constraints
		let c1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v1])
		let c2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v2])
		let c3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v3])
		let c4 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(100)-[v(20)]", options: [], metrics: nil, views: ["v": v1])
		let c5with = NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-(20)-[v2(20)]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1": v1, "v2": v2, "v3": v3])
		let c5without = NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1": v1, "v3": v3])

		// first set of constraints
		constraintsWith.append(contentsOf: c1)
		constraintsWith.append(contentsOf: c2)
		constraintsWith.append(contentsOf: c3)
		constraintsWith.append(contentsOf: c4)
		constraintsWith.append(contentsOf: c5with)

		// second set of constraints
		constraintsWithout.append(contentsOf: c1)
		constraintsWithout.append(contentsOf: c3)
		constraintsWithout.append(contentsOf: c4)
		constraintsWithout.append(contentsOf: c5without)

		// apply first set
		NSLayoutConstraint.activate(self.constraintsWith)

        // ignore, just testing new iOS 10 read-only properties
        do {
            let c = self.constraintsWith[0]
            print(c.firstItem)
            if #available(iOS 10.0, *) {
                print(c.firstAnchor)
            } else {
                // Fallback on earlier versions
            }
        }

		/*
		 // just experimenting, pay no attention
         let g = UILayoutGuide()
         self.view.addLayoutGuide(g)
         NSLayoutConstraint.activate([
         g.topAnchor.constraint(equalTo:self.topLayoutGuide.bottomAnchor),
         g.leftAnchor.constraint(equalTo:self.view.leftAnchor),
         g.widthAnchor.constraint(equalToConstant:100),
         g.heightAnchor.constraint(equalToConstant:100)
         ])

		 // still experimenting
         let v = UIView()
         let arr = NSLayoutConstraint.constraints(withVisualFormat:
         "V:[tlg]-0-[v]", metrics: nil,
         views: ["tlg":self.topLayoutGuide, "v":v])
         let tlg = self.topLayoutGuide
         let c = v.topAnchor.constraint(equalTo:tlg.bottomAnchor)

         // still experimenting
         NSLayoutConstraint.activate(
         NSLayoutConstraint.constraints(withVisualFormat:
         "V:|-0-[v]", metrics: nil, views: ["v":v])
         )
		 */

        // MARK: Normal
		let v4 = UIView(frame: CGRect(x: 100, y: 250, width: 132, height: 194))
		v4.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
		let v5 = UIView()
		v5.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
		let v6 = UIView()
		v6.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
		v6.layer.setValue("littleRedSquare", forKey: "identifier")

		v0.addSubview(v4)
		v4.addSubview(v5)
		v4.addSubview(v6)

		v5.translatesAutoresizingMaskIntoConstraints = false
		v6.translatesAutoresizingMaskIntoConstraints = false

		var which: Int { return 3 }
		switch which {
		case 1:
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .leading,
					relatedBy: .equal,
					toItem: v4,
					attribute: .leading,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .trailing,
					relatedBy: .equal,
					toItem: v4,
					attribute: .trailing,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .top,
					relatedBy: .equal,
					toItem: v4,
					attribute: .top,
					multiplier: 1, constant: 0)
			)
			v5.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .height,
					relatedBy: .equal,
					toItem: nil,
					attribute: .notAnAttribute,
					multiplier: 1, constant: 10)
			)
			v6.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .width,
					relatedBy: .equal,
					toItem: nil,
					attribute: .notAnAttribute,
					multiplier: 1, constant: 20)
			)
			v6.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .height,
					relatedBy: .equal,
					toItem: nil,
					attribute: .notAnAttribute,
					multiplier: 1, constant: 20)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .trailing,
					relatedBy: .equal,
					toItem: v4,
					attribute: .trailing,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .bottom,
					relatedBy: .equal,
					toItem: v4,
					attribute: .bottom,
					multiplier: 1, constant: 0)
			)
		case 2:
			/// new API in iOS 9 for making constraints individually
			/// whereever possible, activate all the constraints at once
			NSLayoutConstraint.activate([
				v5.leadingAnchor.constraint(equalTo: v4.leadingAnchor),
				v5.trailingAnchor.constraint(equalTo: v4.trailingAnchor),
				v5.topAnchor.constraint(equalTo: v4.topAnchor),
				v5.heightAnchor.constraint(equalToConstant: 10),
				v6.widthAnchor.constraint(equalToConstant: 20),
				v6.heightAnchor.constraint(equalToConstant: 20),
				v6.trailingAnchor.constraint(equalTo: v4.trailingAnchor),
				v6.bottomAnchor.constraint(equalTo: v4.bottomAnchor)
			])

		case 3:
			// NSDictionaryOfVariableBindings(v2,v3) // it's a macro, no macros in Swift
			// let d = ["v2":v2,"v3":v3]
			// okay, that's boring...
			// let's write our own Swift NSDictionaryOfVariableBindings substitute (sort of)
			let d = dictionaryOfNames(v4, v5, v6)
			NSLayoutConstraint.activate([
				NSLayoutConstraint.constraints(
					withVisualFormat: "H:|[v2]|", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraints(
					withVisualFormat: "V:|[v2(10)]", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraints(
					withVisualFormat: "H:[v3(20)]|", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraints(
					withVisualFormat: "V:[v3(20)]|", options: [], metrics: nil, views: d),
				].joined().map { $0 })
		default: break
		}

		delay(2) {
			v4.bounds.size.width += 40
			v4.bounds.size.height -= 50
		}

	}

	func doSwap() {
		let mainview = self.view
		if self.v2.superview != nil {
			self.v2.removeFromSuperview()
			NSLayoutConstraint.deactivate(self.constraintsWith)
			NSLayoutConstraint.activate(self.constraintsWithout)
		} else {
			mainview?.addSubview(v2)
			NSLayoutConstraint.deactivate(self.constraintsWithout)
			NSLayoutConstraint.activate(self.constraintsWith)
		}
	}

	@IBAction func doSwap(_ sender: Any) {
		doSwap()
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		let prev = previousTraitCollection
		let tc = self.traitCollection
		if prev == nil && tc.verticalSizeClass == .compact {
			self.doSwap()
		} else if prev != nil && tc.verticalSizeClass != prev!.verticalSizeClass {
			self.doSwap()
		}
	}

}

