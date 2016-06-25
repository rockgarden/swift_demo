//
//  Ext_UIImage.swift
//
//  Created by wangkan on 16/6/5.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

	convenience init(color: UIColor, size: CGSize = CGSizeMake(1, 1)) {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(CGImage: image.CGImage!)
	}

}