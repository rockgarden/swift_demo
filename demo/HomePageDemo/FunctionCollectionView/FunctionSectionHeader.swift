//
//  FunctionSectionHeader.swift
//  HomePageDemo
//
//  Created by wangkan on 2017/3/1.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

let functionSectionHeaderReuseId = "FunctionSectionHeader"

class FunctionSectionHeader: UICollectionReusableView {
    
    fileprivate var titleLabel: UILabel!
    fileprivate let iconView = UIImageView()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// init
    convenience init() {
        self.init()
        
        //imageView
        iconView.clipsToBounds = true
        addSubview(iconView)
        
        //titleLabel
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakMode = .byTruncatingTail
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x:0, y:0, width: self.frame.size.height, height: self.frame.size.height)
        titleLabel.frame = CGRect(x:0, y:self.frame.size.height, width: self.frame.size.width - self.frame.size.height, height: self.frame.size.height)
    }
    
}
