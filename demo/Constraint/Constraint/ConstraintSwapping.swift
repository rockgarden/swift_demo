//
//  ViewController.swift
//  Constraint
//
//  Created by wangkan on 16/9/18.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ConstraintSwapping: UIViewController {

	let v = UIView()
	var v0: UIView!
	var v1: UIView!
	var v2: UIView!
	var v3: UIView!
	var constraintsWith = [NSLayoutConstraint]()
	var constraintsWithout = [NSLayoutConstraint]()

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		print("here")
		super.touchesBegan(touches, withEvent: event)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let mainView = self.view

		v.backgroundColor = UIColor.redColor()
		v.translatesAutoresizingMaskIntoConstraints = false
		mainView.addSubview(v)
		NSLayoutConstraint.activateConstraints([
			NSLayoutConstraint.constraintsWithVisualFormat("H:|-(60)-[v]-(0)-|", options: [], metrics: nil, views: ["v": v]),
			NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[v]-(0)-|", options: [], metrics: nil, views: ["v": v])
			].flatten().map { $0 })
		// experiment by commenting out this line
		v.preservesSuperviewLayoutMargins = true

		let v0 = UIView()
		v0.backgroundColor = UIColor.greenColor()
		v0.translatesAutoresizingMaskIntoConstraints = false
		v.addSubview(v0)

		let v1 = UIView()
		v1.backgroundColor = UIColor.redColor()
		v1.translatesAutoresizingMaskIntoConstraints = false
		let v2 = UIView()
		v2.backgroundColor = UIColor.yellowColor()
		v2.translatesAutoresizingMaskIntoConstraints = false
		let v3 = UIView()
		v3.backgroundColor = UIColor.blueColor()
		v3.translatesAutoresizingMaskIntoConstraints = false
		v0.addSubview(v1)
		v0.addSubview(v2)
		v0.addSubview(v3)

		self.v0 = v0
		self.v1 = v1
		self.v2 = v2
		self.v3 = v3

		var which0: Int { return 1 }
		switch which0 {
		case 1:
			// no longer need delayed performance here
			NSLayoutConstraint.activateConstraints([
				NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v1]-|", options: [], metrics: nil, views: ["v1": v0]),
				NSLayoutConstraint.constraintsWithVisualFormat("V:|-[v1]-|", options: [], metrics: nil, views: ["v1": v0])
				].flatten().map { $0 })
		case 2:
			// new notation treats margins as a pseudoview (UILayoutGuide)
			NSLayoutConstraint.activateConstraints([
				v0.topAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.topAnchor),
				v0.bottomAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.bottomAnchor),
				v0.trailingAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.trailingAnchor),
				v0.leadingAnchor.constraintEqualToAnchor(v.layoutMarginsGuide.leadingAnchor)
			])
		case 3:
			// new kind of margin, "readable content"
			// particularly dramatic on iPad in landscape
			NSLayoutConstraint.activateConstraints([
				v0.topAnchor.constraintEqualToAnchor(v.readableContentGuide.topAnchor),
				v0.bottomAnchor.constraintEqualToAnchor(v.readableContentGuide.bottomAnchor),
				v0.trailingAnchor.constraintEqualToAnchor(v.readableContentGuide.trailingAnchor),
				v0.leadingAnchor.constraintEqualToAnchor(v.readableContentGuide.leadingAnchor)
			])
			default: break
		}

		// construct constraints
		let c1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v1])
		let c2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v2])
		let c3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[v(100)]", options: [], metrics: nil, views: ["v": v3])
		let c4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(100)-[v(20)]", options: [], metrics: nil, views: ["v": v1])
		let c5with = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v2(20)]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1": v1, "v2": v2, "v3": v3])
		let c5without = NSLayoutConstraint.constraintsWithVisualFormat("V:[v1]-(20)-[v3(20)]", options: [], metrics: nil, views: ["v1": v1, "v3": v3])

		// first set of constraints
		self.constraintsWith.appendContentsOf(c1)
		self.constraintsWith.appendContentsOf(c2)
		self.constraintsWith.appendContentsOf(c3)
		self.constraintsWith.appendContentsOf(c4)
		self.constraintsWith.appendContentsOf(c5with)

		// second set of constraints
		self.constraintsWithout.appendContentsOf(c1)
		self.constraintsWithout.appendContentsOf(c3)
		self.constraintsWithout.appendContentsOf(c4)
		self.constraintsWithout.appendContentsOf(c5without)

		// apply first set
		NSLayoutConstraint.activateConstraints(self.constraintsWith)

		/*
		 // just experimenting, pay no attention
		 let g = UILayoutGuide()
		 self.view.addLayoutGuide(g)
		 NSLayoutConstraint.activateConstraints([
		 g.topAnchor.constraintEqualToAnchor(self.topLayoutGuide.bottomAnchor),
		 g.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor),
		 g.widthAnchor.constraintEqualToConstant(100),
		 g.heightAnchor.constraintEqualToConstant(100)
		 ])

		 // still experimenting
		 let v = UIView()
		 let arr = NSLayoutConstraint.constraintsWithVisualFormat(
		 "V:[tlg]-0-[v]", options: [], metrics: nil,
		 views: ["tlg":self.topLayoutGuide, "v":v])
		 let tlg = self.topLayoutGuide
		 let c = v.topAnchor.constraintEqualToAnchor(tlg.bottomAnchor)

		 // still experimenting
		 NSLayoutConstraint.activateConstraints(
		 NSLayoutConstraint.constraintsWithVisualFormat(
		 "V:|-0-[v]", options: [], metrics: nil, views: ["v":v])
		 )
		 */

		let v4 = UIView(frame: CGRectMake(100, 250, 132, 194))
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
			// the old way, and this is the last time I'm going to show this
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .Leading,
					relatedBy: .Equal,
					toItem: v4,
					attribute: .Leading,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .Trailing,
					relatedBy: .Equal,
					toItem: v4,
					attribute: .Trailing,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .Top,
					relatedBy: .Equal,
					toItem: v4,
					attribute: .Top,
					multiplier: 1, constant: 0)
			)
			v5.addConstraint(
				NSLayoutConstraint(item: v5,
					attribute: .Height,
					relatedBy: .Equal,
					toItem: nil,
					attribute: .NotAnAttribute,
					multiplier: 1, constant: 10)
			)
			v6.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .Width,
					relatedBy: .Equal,
					toItem: nil,
					attribute: .NotAnAttribute,
					multiplier: 1, constant: 20)
			)
			v6.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .Height,
					relatedBy: .Equal,
					toItem: nil,
					attribute: .NotAnAttribute,
					multiplier: 1, constant: 20)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .Trailing,
					relatedBy: .Equal,
					toItem: v4,
					attribute: .Trailing,
					multiplier: 1, constant: 0)
			)
			v4.addConstraint(
				NSLayoutConstraint(item: v6,
					attribute: .Bottom,
					relatedBy: .Equal,
					toItem: v4,
					attribute: .Bottom,
					multiplier: 1, constant: 0)
			)
		case 2:
			// new API in iOS 9 for making constraints individually
			// and we should now be activating constraints, not adding them...
			// to a specific view
			// whereever possible, activate all the constraints at once
			NSLayoutConstraint.activateConstraints([
				v5.leadingAnchor.constraintEqualToAnchor(v4.leadingAnchor),
				v5.trailingAnchor.constraintEqualToAnchor(v4.trailingAnchor),
				v5.topAnchor.constraintEqualToAnchor(v4.topAnchor),
				v5.heightAnchor.constraintEqualToConstant(10),
				v6.widthAnchor.constraintEqualToConstant(20),
				v6.heightAnchor.constraintEqualToConstant(20),
				v6.trailingAnchor.constraintEqualToAnchor(v4.trailingAnchor),
				v6.bottomAnchor.constraintEqualToAnchor(v4.bottomAnchor)
			])

		case 3:
			// NSDictionaryOfVariableBindings(v2,v3) // it's a macro, no macros in Swift
			// let d = ["v2":v2,"v3":v3]
			// okay, that's boring...
			// let's write our own Swift NSDictionaryOfVariableBindings substitute (sort of)
			let d = dictionaryOfNames(v4, v5, v6)
			NSLayoutConstraint.activateConstraints([
				NSLayoutConstraint.constraintsWithVisualFormat(
					"H:|[v2]|", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraintsWithVisualFormat(
					"V:|[v2(10)]", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraintsWithVisualFormat(
					"H:[v3(20)]|", options: [], metrics: nil, views: d),
				NSLayoutConstraint.constraintsWithVisualFormat(
					"V:[v3(20)]|", options: [], metrics: nil, views: d),
				// uncomment me to form a conflict
				// NSLayoutConstraint.constraintsWithVisualFormat(
				// "V:[v3(10)]|", options: [], metrics: nil, views: d),
				].flatten().map { $0 })
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
			NSLayoutConstraint.deactivateConstraints(self.constraintsWith)
			NSLayoutConstraint.activateConstraints(self.constraintsWithout)
		} else {
			mainview.addSubview(v2)
			NSLayoutConstraint.deactivateConstraints(self.constraintsWithout)
			NSLayoutConstraint.activateConstraints(self.constraintsWith)
		}
	}

	@IBAction func doSwap(sender: AnyObject) {
		doSwap()
	}

	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		let prev = previousTraitCollection
		let tc = self.traitCollection
		if prev == nil && tc.verticalSizeClass == .Compact {
			self.doSwap()
		} else if prev != nil && tc.verticalSizeClass != prev!.verticalSizeClass {
			self.doSwap()
		}
	}

}

