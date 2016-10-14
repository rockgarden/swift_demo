//
//  ViewController.swift
//  swiftDemo
//
//  Created by LinfangTu on 15/12/2.
//  Copyright © 2015年 LinfangTu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	var nameText: UITextField!
	var passwordText: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "登录"
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

		let loginButton = UIButton(type: UIButtonType.custom)
		loginButton.frame = CGRect.zero
		loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		loginButton.setTitleColor(kRGBA(0, g: 0, b: 0, a: 1), for: UIControlState())
		loginButton.setTitle("登录", for: UIControlState())
		loginButton.backgroundColor = UIColor.lightGray
		loginButton.layer.cornerRadius = 4
		loginButton.layer.masksToBounds = true
		loginButton.layoutIfNeeded()
		loginButton.addTarget(self, action: #selector(LoginViewController.signinButtonPress(_:)), for: UIControlEvents.touchUpInside)

		let signupButton = UIButton(type: UIButtonType.custom)
		signupButton.frame = CGRect.zero
		signupButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		signupButton.setTitleColor(kRGBA(0, g: 0, b: 0, a: 1), for: UIControlState())
		signupButton.setTitle("注册", for: UIControlState())
		signupButton.backgroundColor = UIColor.lightGray
		signupButton.layer.cornerRadius = 4
		signupButton.layer.masksToBounds = true
		signupButton.layoutIfNeeded()
		signupButton.addTarget(self, action: #selector(LoginViewController.showVC), for: UIControlEvents.touchUpInside)
        
		self.view.addSubview(nameText)
		self.view.addSubview(passwordText)
		self.view.addSubview(loginButton)
        self.view.addSubview(signupButton)

		// 使用Auto Layout的方式来布局
		nameText.translatesAutoresizingMaskIntoConstraints = false
		passwordText.translatesAutoresizingMaskIntoConstraints = false
		loginButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false

		// 创建水平方向约束
		let views: [String: AnyObject] = ["nameText": nameText, "passwordText": passwordText, "loginButton": loginButton, "signinButton": signupButton]
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[nameText]-20-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[passwordText]-20-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[signinButton]-20-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[loginButton]-20-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
		// 创建垂直方向约束
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[nameText(==40)]-20-[passwordText(==40)]-20-[loginButton(==40)]-20-[signinButton(==40)]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    func showVC() {
		let signup: SignupViewController = SignupViewController()
		self.navigationController!.show(signup, sender: nil) //pushViewController(signup, animated: true)
	}

	func signinButtonPress(_ sender: UIButton) {
		if nameText.text == "user" && passwordText.text == "password" {
            // Demo
			let detail = UIViewController_table_1()
			self.navigationController!.pushViewController(detail, animated: true)
		}
		else {
			debugPrint("user name is error!")
		}
	}
    
    // RGBA的颜色设置
    func kRGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

}

