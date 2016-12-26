//
//  MyFileViewCell.swift
//  mobile112
//
//  Created by wangkan on 2016/12/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import Photos

final class MyFileViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override var isSelected : Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.hex("#009688", alpha: 1.0).cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = isSelected ? 2 : 0
        }
    }
}

