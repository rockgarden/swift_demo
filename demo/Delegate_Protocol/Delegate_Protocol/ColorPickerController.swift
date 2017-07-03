//
//  ColorPickerController.swift
//  Delegate_Protocol
//
//  Created by wangkan on 2016/9/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
	// color == nil on cancel
	func colorPicker (_ picker: ColorPickerController,
		didSetColorNamed theName: String?,
		toColor theColor: UIColor?)
}

class ColorPickerController: UIViewController {
	weak var delegate: ColorPickerDelegate?
	var color = UIColor.red
	var colorName: String

	init(colorName: String, andColor: UIColor) {
        self.colorName = colorName //Must init before super.init
        super.init(nibName: "ColorPicker", bundle: nil)
        //self.color = andColor
        //view.backgroundColor = color
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		return .portrait
	}

	@IBAction func dismissColorPicker(_ sender: AnyObject?) {
		let c: UIColor? = self.color
		self.delegate?.colorPicker(
			self, didSetColorNamed: self.colorName, toColor: c)
	}
}

