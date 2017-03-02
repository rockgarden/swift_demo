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
    
    fileprivate let titleLabel = UILabel()
    fileprivate let iconView = UIImageView()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconView.image = icon
        }
    }
    
    /// init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        let width = self.frame.size.width, height = self.frame.size.height
        iconView.frame = CGRect(x:0, y:0, width: height, height: height)
        titleLabel.frame = CGRect(x:height, y:0, width: width - height, height: height)
    }
    
}
