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
    let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        gradientLayer.frame = self.bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
        let color3 = UIColor.clear.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.05).cgColor as CGColor

        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.04, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
}

extension ExpandTableViewCell: RJExpandingTableViewCell {
    
    func setLoading(_ loading: Bool) {
        if (loading) {
            indicatorView.startAnimating()
        }else{
            indicatorView.stopAnimating()
        }
        indicatorView.isHidden = !loading
    }
    
    func setExpandStatus(_ status: RJExpandStatus,animated:Bool) {
        var angle: CGFloat = 0
        var duration: TimeInterval = 0
        if status == .expanded {
            angle = CGFloat(M_PI)
        }
        if animated {
            duration = 0.3
        }
        UIView.animate(withDuration: duration, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
        }) 
    }
}
