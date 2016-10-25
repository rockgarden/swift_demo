//
//  ExpandableByConstraint.swift
//  animate
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ExpandableByConstraint: UIViewController {

	@IBOutlet var randomLabel: UILabel!
	@IBOutlet var sectionHeightConstraint: NSLayoutConstraint!
	@IBOutlet var bottomInternalConstraint: NSLayoutConstraint!
	var collapsed = false
	let texts = ["This text can expand and collapse", "The quick brown fox jumps over the lazy dog. Then he went on vacation... Then he had a drink..."]
	var long = false

	@IBAction func toggleContents(_ sender: AnyObject!) {
		self.long = !self.long
		self.randomLabel.text = self.texts[self.long ? 1 : 0]
		UIView.animate(withDuration: 1, animations: {
			self.view.layoutIfNeeded()
		}) 
	}

	@IBAction func toggleButtonSelector (_ sender: AnyObject!) {
		self.collapsed = !self.collapsed
		if self.collapsed {
			self.sectionHeightConstraint.constant = 10
			self.sectionHeightConstraint.priority = 999
			NSLayoutConstraint.deactivate([self.bottomInternalConstraint])
			UIView.animate(withDuration: 1, animations: {
				self.view.layoutIfNeeded()
			}) 
		} else {
			self.sectionHeightConstraint.priority = 250
			NSLayoutConstraint.activate([self.bottomInternalConstraint])
			UIView.animate(withDuration: 1, animations: {
				self.view.layoutIfNeeded()
			}) 
		}
	}

}

