//
//  ExpandCell.swift
//  UILabel
//
//  Created by wangkan on 2016/9/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ExpandCell : UITableViewCell {
    
    @IBOutlet weak var expandableLabel: ExpandableLabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        expandableLabel.collapsed = true
        expandableLabel.text = nil
    }
}
