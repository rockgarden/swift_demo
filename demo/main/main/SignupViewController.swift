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
		self.view.backgroundColor = UIColor.white

		self.nameText = UITextField(frame: CGRect.zero)
		self.nameText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		self.nameText.borderStyle = UITextBorderStyle.roundedRect
		self.nameText.placeholder = "用户名"
		self.nameText.font = UIFont.systemFont(ofSize: 14)
		self.nameText.layoutIfNeeded()

		passwordText = UITextField(frame: CGRect.zero)
		passwordText.placeholder = "密码"
		passwordText.borderStyle = UITextBorderStyle.roundedRect
		passwordText.font = UIFont.systemFont(ofSize: 14)
		passwordText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		passwordText.isSecureTextEntry = true
		passwordText.layoutIfNeeded()

		authCodeView = AuthcodeView()
		authCodeView!.frame = CGRect.zero

		self.codeText = UITextField(frame: CGRect.zero)
		self.codeText.textColor = kRGBA(0, g: 0, b: 0, a: 0.8)
		self.codeText.borderStyle = UITextBorderStyle.roundedRect
		self.codeText.placeholder = "验证码"
		self.codeText.font = UIFont.systemFont(ofSize: 14)
		self.codeText.layoutIfNeeded()

		let signupButton = UIButton(type: UIButtonType.custom)
		signupButton.frame = CGRect.zero
		signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		signupButton.setTitleColor(kRGBA(0, g: 0, b: 0, a: 1), for: UIControlState())
		signupButton.setTitle("注册", for: UIControlState())
		signupButton.backgroundColor = UIColor.lightGray
		signupButton.layer.cornerRadius = 4
		signupButton.layer.masksToBounds = true
		signupButton.layoutIfNeeded()
		signupButton.addTarget(self, action: #selector(SignupViewController.signupButtonPress(_:)), for: UIControlEvents.touchUpInside)

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
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[nameText]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[passwordText]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[codeText]-15-[authCodeView(==100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[signupButton]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		// 创建垂直方向约束
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[nameText(==40)]-20-[passwordText(==40)]-20-[authCodeView(==40)]-20-[signupButton(==40)]", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[nameText(==40)]-20-[passwordText(==40)]-20-[codeText(==40)]-20-[signupButton(==40)]", options: NSLayoutFormatOptions(), metrics: nil, views: views))

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func signupButtonPress(_ sender: UIButton) {
		if nameText.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 || passwordText.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 || codeText.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
			let alert: UIAlertController = UIAlertController(title: "提示", message: "信息补全", preferredStyle: UIAlertControllerStyle.alert)
			let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true, completion: { () -> Void in
			})
		}
		else {
			// 比较验证码
			let code = (self.authCodeView?.authCodeStr)! as NSString
			debugPrint("code = \(code) text =\(codeText.text)")
			if codeText.text!.lowercased() == code.lowercased {
				let signin: LoginViewController = LoginViewController()
				self.navigationController!.pushViewController(signin, animated: true)
			}
			else {
				let alert: UIAlertController = UIAlertController(title: "提示", message: "验证码错误", preferredStyle: UIAlertControllerStyle.alert)
				let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
				alert.addAction(action)
				self.present(alert, animated: true, completion: { () -> Void in
				})
			}
		}
	}

	// RGBA的颜色设置
	func kRGBA (_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
		return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
	}
}
