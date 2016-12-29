//
//  PhotoCell.swift
//  mobile112
//
//  Created by wangkan on 2016/12/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import Photos

final class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override var isSelected : Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor("#009688", alpha: 1.0).cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = isSelected ? 2 : 0
        }
    }
}

internal extension UIColor {

    convenience init!(_ hexStr: String, alpha: CGFloat = 1.0) {
        var formatted = hexStr.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha) } else {
            return nil
        }
    }

    class func hex (_ hexStr : NSString, alpha : CGFloat) -> UIColor {
        let realHexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: realHexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white
        }
}
}

