//
//  PhotoTableViewCell.swift
//  swiftDemo
//
//  Created by LinfangTu on 15/12/10.
//  Copyright © 2015年 LinfangTu. All rights reserved.
//

import UIKit

class UITableViewCell_photo_1: UITableViewCell {

    var photoView : UIImageView!
    var titleLabel : UILabel!
    var descLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpView()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        photoView                         = UIImageView(frame: CGRect.zero)
        photoView.contentMode             = UIViewContentMode.scaleAspectFit
        self.contentView.addSubview(photoView)

        titleLabel                        = UILabel(frame: CGRect.zero)
        titleLabel.textColor              = kRandomColor()
        titleLabel.font                   = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleLabel)

        descLabel                         = UILabel(frame: CGRect.zero)
        descLabel.textColor               = kRGBA(0, g: 0, b: 0, a: 0.6)
        descLabel.font                    = UIFont.systemFont(ofSize: 12)
        descLabel.numberOfLines           = 0
        descLabel.preferredMaxLayoutWidth = kScreenWidth - 110
        self.contentView.addSubview(descLabel)
        
        photoView.translatesAutoresizingMaskIntoConstraints  = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints  = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views:[String:AnyObject] = ["photoView": photoView, "titleLabel": titleLabel , "descLabel": descLabel]

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[photoView(==60)]-10-[titleLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[photoView(==60)]-10-[descLabel]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[photoView(==60)]", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel(==25)]-5-[descLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))

        layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
