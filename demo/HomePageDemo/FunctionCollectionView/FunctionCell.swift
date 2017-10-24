//
//  FunctionCell.swift
//
//  Created by wangkan on 2017/2/28.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

let functionCellReuseId = "FunctionCell"

// MARK: - Cell
class FunctionCell: UICollectionViewCell {
    
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
    
    var function: Function? {
        didSet {
            if let f = function {
                titleLabel.text = f.name
                guard let i = UIImage(named: f.iconName) else { return }
                iconView.image = i
            }
        }
    }
    
    /// init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        let width = self.frame.size.height, height = self.frame.size.height
        iconView.frame = CGRect(x: 0+width/4, y: 0+height/4, width: width/2, height: height/2)
        titleBackgroundView.frame = CGRect(x: 0,
                                     y: height - backViewHeight,
                                     width: width,
                                     height: backViewHeight)
        titleLabel.frame = titleBackgroundView.bounds
    }
    
}


// TODO: 定义FunctionModule接口
// MARK: - Model
class Function {
    
    var name: String
    var iconName: String = ""
    var iconURLString: String = ""
    var type: String
    var index: Int
    var iconImage = UIImage() //TODO: 传送方式: ImageURL? 或 RawString Data?
    
    // TODO: 实现 init(json: JSON)
    
    init(name:String, iconName:String, type:String, index:Int) {
        self.name = name
        self.iconName = iconName
        self.type = type
        self.index = index
    }
    
    init(name:String, iconURLString:String, type:String, index:Int) {
        self.name = name
        self.iconURLString = iconURLString
        self.type = type
        self.index = index
    }
    
    convenience init(copying f: Function) {
        self.init(name:f.name, iconName:f.iconName, type:f.type, index:f.index)
    }
    
}


// MARK: - internal extension
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


internal extension UIImage {
    
    convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            debugPrint("No image in URL \(urlString)")
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }
}

