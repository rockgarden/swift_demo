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
        photoView                         = UIImageView(frame: CGRectZero)
        photoView.contentMode             = UIViewContentMode.ScaleAspectFit
        self.contentView.addSubview(photoView)

        titleLabel                        = UILabel(frame: CGRectZero)
        titleLabel.textColor              = kRandomColor()
        titleLabel.font                   = UIFont.systemFontOfSize(15)
        self.contentView.addSubview(titleLabel)

        descLabel                         = UILabel(frame: CGRectZero)
        descLabel.textColor               = kRGBA(0, g: 0, b: 0, a: 0.6)
        descLabel.font                    = UIFont.systemFontOfSize(12)
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

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[photoView(==60)]-10-[titleLabel]-20-|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[photoView(==60)]-10-[descLabel]-20-|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[photoView(==60)]", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleLabel(==25)]-5-[descLabel]-10-|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))

        layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
