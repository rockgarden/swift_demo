//
//  Calculator.swift
//  UIStackView
//
//  Created by wangkan on 16/9/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class Calculator: UIViewController {

	let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 500))
	let makeView = { (color: UIColor) -> UIView in
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = color
		return view
	}

	convenience init(frame: CGRect) {
		self.init(nibName: nil, bundle: nil)
		title = "Calculator"
		setup()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(hostView)
	}

	func setup() {
		hostView.backgroundColor = .black

		let zeroButton = makeButtonWithTitle("0", selector: "", tag: 0)
		let dotButton = makeButtonWithTitle(",", selector: "", tag: 10)
		let equalButton = makeButtonWithTitle("=", selector: "", tag: 101)
		let oneButton = makeButtonWithTitle("1", selector: "", tag: 1)
		let twoButton = makeButtonWithTitle("2", selector: "", tag: 2)
		let threeButton = makeButtonWithTitle("3", selector: "", tag: 3)
		let plusButton = makeButtonWithTitle("+", selector: "", tag: 102)
		let fourButton = makeButtonWithTitle("4", selector: "", tag: 4)
		let fiveButton = makeButtonWithTitle("5", selector: "", tag: 5)
		let sixButton = makeButtonWithTitle("6", selector: "", tag: 6)
		let minusButton = makeButtonWithTitle("−", selector: "", tag: 103)
		let sevenButton = makeButtonWithTitle("7", selector: "", tag: 7)
		let eighyButton = makeButtonWithTitle("8", selector: "", tag: 8)
		let nineButton = makeButtonWithTitle("9", selector: "", tag: 9)
		let timesButton = makeButtonWithTitle("×", selector: "", tag: 104)
		let tanButton = makeButtonWithTitle("C", selector: "", tag: 100)
		let openParenthesesButton = makeButtonWithTitle("±", selector: "", tag: 100)
		let closeParenthesesButton = makeButtonWithTitle("%", selector: "", tag: 100)
		let divideButton = makeButtonWithTitle("÷", selector: "", tag: 105)

		let textView = UILabel(frame: .zero)
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.text = "42"
		textView.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
		// textView.backgroundColor = UIColor.redColor()
		textView.textColor = .white
		textView.textAlignment = .right

		let textHostView = UIView(frame: .zero)
		textHostView.backgroundColor = .black
		textHostView.addSubview(textView)

		var constraints = [NSLayoutConstraint]()

		constraints.append(textView.bottomAnchor.constraint(equalTo: textHostView.bottomAnchor, constant: -5))
		constraints.append(textView.leadingAnchor.constraint(equalTo: textHostView.leadingAnchor, constant: 5))
        constraints.append(textView.trailingAnchor.constraint(equalTo: textHostView.trailingAnchor, constant: -5))

		NSLayoutConstraint.activate(constraints)

		// let redView = makeView(.redColor())
		// let blueView = makeView(.blueColor())
		// let greenView = makeView(.greenColor())

		let firstRow = UIStackView(arrangedSubviews: [zeroButton, dotButton, equalButton])
		firstRow.distribution = .fillProportionally
		firstRow.spacing = 0.5

		zeroButton.widthAnchor.constraint(equalTo: dotButton.widthAnchor, multiplier: 2.0, constant: 0.5).isActive = true
		dotButton.widthAnchor.constraint(equalTo: equalButton.widthAnchor).isActive = true

		let secondRow = UIStackView(arrangedSubviews: [oneButton, twoButton, threeButton, plusButton])
		secondRow.distribution = .fillEqually
		secondRow.spacing = 0.5

		let thirdRow = UIStackView(arrangedSubviews: [fourButton, fiveButton, sixButton, minusButton])
		thirdRow.distribution = .fillEqually
		thirdRow.spacing = 0.5

		let fourthRow = UIStackView(arrangedSubviews: [sevenButton, eighyButton, nineButton, timesButton])
		fourthRow.distribution = .fillEqually
		fourthRow.spacing = 0.5

		let fifthRow = UIStackView(arrangedSubviews: [tanButton, openParenthesesButton, closeParenthesesButton, divideButton])
		fifthRow.distribution = .fillEqually
		fifthRow.spacing = 0.5

		let buttonStackView = UIStackView(arrangedSubviews: [fifthRow, fourthRow, thirdRow, secondRow, firstRow])
		buttonStackView.axis = .vertical
		buttonStackView.distribution = .fillEqually
		buttonStackView.spacing = 0.5

		let hostStackView = UIStackView(arrangedSubviews: [textHostView, buttonStackView])
		hostStackView.frame = hostView.bounds
		hostStackView.axis = .vertical
        hostStackView.distribution = .fillEqually
        /// fillProportionally 
        /// 堆叠视图调整其排列视图大小的布局，以便它们沿堆叠视图的轴线填充可用空间。当排列的视图不适合堆叠视图时，它会根据其压缩阻力优先级缩小视图。如果排列的视图不填满堆叠视图，则会根据其拥挤优先级来扩展视图。如果存在任何歧义，堆叠视图将根据sortedSubviews数组中的索引来调整排列的视图的大小。会对 Subviews.widthAnchor 有要求。
		hostStackView.spacing = 0.5

		textHostView.heightAnchor.constraint(equalToConstant: 150).isActive = true

		hostView.addSubview(hostStackView)

	}

	func makeButtonWithTitle(_ title: String, selector: String, tag: Int) -> UIButton {
		let button = UIButton(type: .system)
		button.tintColor = UIColor.black
		switch tag {
		case 0...10:
			button.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
			button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
		case 101...110:
			button.backgroundColor = UIColor.orange
			button.tintColor = .white
			button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 50)
		default:
			button.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
			button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
		}
		button.setTitle(title, for: UIControlState())
		button.tag = tag
		return button
	}

}
