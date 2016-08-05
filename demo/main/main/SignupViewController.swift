//
//  SignupViewController.swift
//  swiftDemo
//
//  Created by LinfangTu on 15/12/7.
//  Copyright © 2015年 LinfangTu. All rights reserved.
//

import UIKit
import Foundation

class SignupViewController: UIViewController {

	var nameText: UITextField!
	var passwordText: UITextField!
	var codeText: UITextField!
	var authCodeView: AuthcodeView?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "注册"
		self.view.backgroundColor = UIColor.whiteColor()

		self.nameText = UITextField(frame: CGRectZero)
		self.nameText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		self.nameText.borderStyle = UITextBorderStyle.RoundedRect
		self.nameText.placeholder = "用户名"
		self.nameText.font = UIFont.systemFontOfSize(14)
		self.nameText.layoutIfNeeded()

		passwordText = UITextField(frame: CGRectZero)
		passwordText.placeholder = "密码"
		passwordText.borderStyle = UITextBorderStyle.RoundedRect
		passwordText.font = UIFont.systemFontOfSize(14)
		passwordText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		passwordText.secureTextEntry = true
		passwordText.layoutIfNeeded()

		authCodeView = AuthcodeView()
		authCodeView!.frame = CGRectZero

		self.codeText = UITextField(frame: CGRectZero)
		self.codeText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		self.codeText.borderStyle = UITextBorderStyle.RoundedRect
		self.codeText.placeholder = "验证码"
		self.codeText.font = UIFont.systemFontOfSize(14)
		self.codeText.layoutIfNeeded()

		let signupButton = UIButton(type: UIButtonType.Custom)
		signupButton.frame = CGRectZero
		signupButton.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
		signupButton.setTitleColor(kRGBA(0, g: 0, b: 0, a: 1), forState: UIControlState.Normal)
		signupButton.setTitle("注册", forState: UIControlState.Normal)
		signupButton.backgroundColor = UIColor.lightGrayColor()
		signupButton.layer.cornerRadius = 4
		signupButton.layer.masksToBounds = true
		signupButton.layoutIfNeeded()
		signupButton.addTarget(self, action: #selector(SignupViewController.signupButtonPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)

		self.view.addSubview(nameText)
		self.view.addSubview(passwordText)
		self.view.addSubview(signupButton)
		self.view.addSubview(self.codeText)
		self.view.addSubview(authCodeView!)

		// 使用Auto Layout的方式来布局
		nameText.translatesAutoresizingMaskIntoConstraints = false
		passwordText.translatesAutoresizingMaskIntoConstraints = false
		signupButton.translatesAutoresizingMaskIntoConstraints = false
		authCodeView!.translatesAutoresizingMaskIntoConstraints = false
		self.codeText.translatesAutoresizingMaskIntoConstraints = false

		let views: [String: AnyObject] = ["nameText": nameText, "passwordText": passwordText, "signupButton": signupButton, "authCodeView": authCodeView!, "codeText": self.codeText]
		// 创建水平方向约束
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[nameText]-20-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[passwordText]-20-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[codeText]-15-[authCodeView(==100)]-20-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[signupButton]-20-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))
		// 创建垂直方向约束
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[nameText(==40)]-20-[passwordText(==40)]-20-[authCodeView(==40)]-20-[signupButton(==40)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[nameText(==40)]-20-[passwordText(==40)]-20-[codeText(==40)]-20-[signupButton(==40)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: views))

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func signupButtonPress(sender: UIButton) {
		if nameText.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || passwordText.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || codeText.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
			let alert: UIAlertController = UIAlertController(title: "提示", message: "信息补全", preferredStyle: UIAlertControllerStyle.Alert)
			let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
			alert.addAction(action)
			self.presentViewController(alert, animated: true, completion: { () -> Void in
			})
		}
		else {
			// 比较验证码
			let code = (self.authCodeView?.authCodeStr)! as NSString
			debugPrint("code = \(code) text =\(codeText.text)")
			if codeText.text!.lowercaseString == code.lowercaseString {
				let signin: LoginViewController = LoginViewController()
				self.navigationController!.pushViewController(signin, animated: true)
			}
			else {
				let alert: UIAlertController = UIAlertController(title: "提示", message: "验证码错误", preferredStyle: UIAlertControllerStyle.Alert)
				let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
				alert.addAction(action)
				self.presentViewController(alert, animated: true, completion: { () -> Void in
				})
			}
		}
	}

	// RGBA的颜色设置
	func kRGBA (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
		return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
	}
}