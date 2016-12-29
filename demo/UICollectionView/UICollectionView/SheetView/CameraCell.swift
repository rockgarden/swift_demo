//
//  CameraCell.swift
//  UICollectionView
//
//  Created by wangkan on 2016/12/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

@objc public protocol CameraCellDelegate: class {
    func presentCamera()
}

/// IMPORTANT: 不可在 xib 中直接加入 GestureRecognizer, 会导致 CameraCell 的 subView[0] 不是 父类 UICollectionReusableView
class CameraCell: UICollectionReusableView {
    
    @IBOutlet weak var imageView: UIImageView!
    weak var cellDelegate: CameraCellDelegate? = nil
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }
    
    func tapped() {
        self.cellDelegate?.presentCamera()
    }
    
}
