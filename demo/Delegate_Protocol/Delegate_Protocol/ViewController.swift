//
//  ViewController.swift
//  Delegate_Protocol
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, myDelegate {

	@IBOutlet weak var principalLabel: UILabel!

	@IBAction func mainButton(sender: UIButton) {

		// we got it the final instance in storyboard
		let secondController: SecondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
		secondController.data = "Text from superclass"
		// who is it delegate
		secondController.delegate = self
		// we do push to navigate
		self.navigationController?.pushViewController(secondController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func writeDateInLabel(data: NSString) {
		self.principalLabel.text = data as String
	}

}

