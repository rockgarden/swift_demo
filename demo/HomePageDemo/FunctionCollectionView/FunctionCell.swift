//
//  FunctionCell.swift
//
//  Created by wangkan on 2017/2/28.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

let functionCellReuseIdentifier = "FunctionCell"

final class FunctionCell: UICollectionViewCell {
    
    /// UI
    fileprivate let iconView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let titleBackgroundView = UIView()
    
    override var isSelected : Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor("#009688", alpha: 1.0).cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    /// 标题偏移设置
    var titleEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 标题背景的高度
    var backViewHeight: CGFloat = 20.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var functionItem: FunctionItem? {
        didSet {
            if let f = functionItem {
                iconView.image = UIImage(named: f.iconName)
                titleLabel.text = f.name
            }
        }
    }
    
    /// init
    convenience init() {
        self.init()
        isSelected = false
        
        //imageView
        iconView.clipsToBounds = true
        addSubview(iconView)
        
        //titleBackView
        addSubview(titleBackgroundView)
        
        //titleLabel
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakMode = .byTruncatingTail
        titleBackgroundView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = self.bounds
        titleBackgroundView.frame = CGRect(x: 0,
                                     y: self.self.frame.size.height - backViewHeight,
                                     width: self.frame.size.width,
                                     height: backViewHeight)
        titleLabel.frame = CGRect(x: titleEdgeInsets.left,
                                  y: titleEdgeInsets.top,
                                  width: titleBackgroundView.bounds.width - titleEdgeInsets.right -  titleEdgeInsets.left,
                                  height: titleBackgroundView.bounds.height - titleEdgeInsets.bottom - titleEdgeInsets.top)
    }
    
}


//TODO: 定义FunctionModule接口
struct FunctionItem {
    
    var name: String
    var iconName: String
    var type: String
    var index: Int
    var iconImage = UIImage() //TODO: 传送方式: ImageURL? 或 RawString Data?
    
    //TODO: init(json: JSON)
    
    init(name:String, iconName:String, type:String, index:Int, iconImage: UIImage) {
        self.name = name
        self.iconName = iconName
        self.type = type
        self.index = index
        self.iconImage = iconImage
    }
    
    init(copying f: FunctionItem) {
        self.init(name:f.name, iconName:f.iconName, type:f.type, index:f.index, iconImage:f.iconImage)
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
}

