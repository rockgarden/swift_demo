//
//  MUCycleCell.swift
//  MUCycleScrollView
//
//  Created by qcm on 16/12/16.
//  Copyright © 2016年 ChengziVR. All rights reserved.
//

import UIKit

let cycleReuseIdentifier: String = "cycleCellID"

class MUCycleCell: UICollectionViewCell {
        
        // MARK: - 描述文字偏移设置
        var titleEdgeInsets: UIEdgeInsets = .zero {
                didSet {
                        setNeedsLayout()
                }
        }
        
        /// 标题背景的高度
        var backViewHeight: CGFloat = 40.0 {
                didSet {
                        setNeedsLayout()
                }
        }
        
        /// UI
        let imageView: UIImageView      = UIImageView()
        let titleLabel: UILabel         = UILabel()
        let titleBackView: UIView       = UIView()
        
        /// init
        override init(frame: CGRect) {
                super.init(frame: frame)
                
                //imageView
                imageView.clipsToBounds = true
                self.addSubview(imageView)
                
                //titleBackView
                self.addSubview(titleBackView)
                
                //titleLabel
                titleLabel.backgroundColor = UIColor.clear
                titleLabel.lineBreakMode   = .byTruncatingTail
                titleBackView.addSubview(titleLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
                super.layoutSubviews()
                
                /// imageView
                imageView.frame = self.bounds
                
                /// titleBackView
                titleBackView.frame = CGRect(x: 0,
                                             y: self.mu_height - backViewHeight,
                                             width: self.mu_width,
                                             height: backViewHeight)
                
                
                /// titleLabel
                titleLabel.frame = CGRect(x: titleEdgeInsets.left,
                                          y: titleEdgeInsets.top,
                                          width: titleBackView.mu_width - titleEdgeInsets.right -  titleEdgeInsets.left,
                                          height: titleBackView.mu_height - titleEdgeInsets.bottom - titleEdgeInsets.top)
        }
}
