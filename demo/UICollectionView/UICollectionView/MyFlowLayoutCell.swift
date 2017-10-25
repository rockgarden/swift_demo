//
//  MyFlowLayoutCell.swift
//  UICollectionView
//
//  Created by wangkan on 2017/6/6.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class MyFlowLayoutCell: UICollectionViewCell {

    @IBOutlet var lab: UILabel!
    @IBOutlet var container: UIView!

    private let deleteButton = UIButton(type: .contactAdd)
    private var deleteClosure: ((String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.cornerRadius = 3
        layer.borderColor = UIColor.blue.cgColor

        deleteButton.isHidden = true
        deleteButton.addTarget(self, action: #selector(self.deleteText), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }

    @objc func capital(_ sender: Any!) {
        // 确认 collection view
        var v : UIView = self
        repeat { v = v.superview! } while !(v is UICollectionView)
        let cv = v as! UICollectionView
        // 获取 self index path
        let ip = cv.indexPath(for: self)!
        // 设置代理 relay to its delegate
        cv.delegate?.collectionView?(cv, performAction:#selector(capital), forItemAt: ip, withSender: sender)
    }

    @objc func deleteText() {
        deleteClosure?(lab.text!)
    }

    func observeDelete(closure: @escaping (String) -> ()) {
        deleteClosure = closure
    }

    func startEdit() {
        deleteButton.isHidden = false
        startShake()
    }

    func stopEdit() {
        deleteButton.isHidden = true
        stopShake()
    }

    private func startShake() {
        let animation =  CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [2 / self.frame.width, -2 / self.frame.width]
        animation.duration = 0.3
        animation.isAdditive = true
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.layer.add(animation, forKey: "shake")
    }

    private func stopShake() {
        self.layer.removeAnimation(forKey: "shake")
    }

    /*
     override func sizeThatFits(_ size: CGSize) -> CGSize {
     var sz = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
     sz.width = ceil(sz.width); sz.height = ceil(sz.height)
     return sz
     }
     */

    /*
     override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
     setNeedsLayout()
     layoutIfNeeded()
     let sz = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
     //sz.width = ceil(sz.width); sz.height = ceil(sz.height)
     let atts = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
     atts.size = sz
     //var newFrame = layoutAttributes.frame
     //newFrame.size.height = sz.height
     //newFrame.size.width = sz.width
     //layoutAttributes.frame = newFrame
     return atts
     }
     */
    
}

