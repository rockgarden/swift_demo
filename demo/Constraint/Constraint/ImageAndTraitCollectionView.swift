//
//  ImageAndTraitCollectionView.swift
//  Constraint
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ImageAndTraitCollectionView: UIView {

    var image : UIImage!

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setNeedsDisplay() // causes drawRect to be called
    }

    override func draw(_ rect: CGRect) {
        if var im = self.image {
            if let asset = self.image.imageAsset {
                let tc = self.traitCollection
                im = asset.image(with: tc)
            }
            im.draw(at: CGPoint.zero)
        }
    }
}
