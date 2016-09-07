//
//  ExpandTableViewCell.swift
//  RJExpandableTableView
//
//  Created by 吴蕾君 on 16/5/12.
//  Copyright © 2016年 rayjuneWu. All rights reserved.
//

import UIKit

class ExpandTableViewCell: UITableViewCell {
  
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ExpandTableViewCell: RJExpandingTableViewCell {
    
    func setLoading(loading: Bool) {
        if (loading) {
            indicatorView.startAnimating()
        }else{
            indicatorView.stopAnimating()
        }
        indicatorView.hidden = !loading
    }
    
    func setExpandStatus(status: RJExpandStatus,animated:Bool) {
        var angle: CGFloat = 0
        var duration: NSTimeInterval = 0
        if status == .Expanded {
            angle = CGFloat(M_PI)
        }
        if animated {
            duration = 0.3
        }
        UIView.animateWithDuration(duration) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(angle)
        }
    }
}