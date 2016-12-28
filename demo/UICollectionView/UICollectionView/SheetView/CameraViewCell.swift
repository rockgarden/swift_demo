//
//  CameraViewCell.swift
//  UICollectionView
//
//  Created by wangkan on 2016/12/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import Photos

final class CameraViewCell: UICollectionReusableView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
}
