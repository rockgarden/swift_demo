//
//  ViewController.swift
//  UIStackView
//
//  Created by wangkan on 16/9/1.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class StackViewVC: UIViewController {
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    @IBOutlet var emojiButtons: [UIButton]! {
        didSet {
            emojiButtons.forEach {
                $0.isHidden = true
            }
        }
    }

    //    @IBOutlet var emojiButtonsAutolayout: [UIButton]! {
    //        didSet {
    //            emojiButtonsAutolayout.forEach {
    //                $0.hidden = true
    //            }
    //        }
    //    }
    
    @IBAction func addStar(_ sender: AnyObject) {
        let starImgVw:UIImageView = UIImageView(image: UIImage(named: "star"))
        starImgVw.contentMode = .scaleAspectFit
        self.horizontalStackView.addArrangedSubview(starImgVw)
        UIView.animate(withDuration: 0.25, animations: {
            self.horizontalStackView.layoutIfNeeded()
        })
    }
    
    /**
     removeFromSuperview call in the removeStar(_:) method is essential to remove the subview from the view hierarchy. Recall that removeArrangedSubview(_:) only tells the stack view that it no longer needs to manage the subview's constraints.
     
     - parameter sender: sender description
     */
    @IBAction func removeStar(_ sender: AnyObject) {
        let star:UIView? = self.horizontalStackView.arrangedSubviews.last
        if let aStar = star {
            self.horizontalStackView.removeArrangedSubview(aStar)
            aStar.removeFromSuperview()
            UIView.animate(withDuration: 0.25, animations: {
                self.horizontalStackView.layoutIfNeeded()
            })
        }
    }

    /*:
     IMPORTANT: 直接Hidden subView 会引起 NSLayoutConstraint:0x19789950 'UISV-hiding', 处理：可将要隐藏的subView的优先级调低,
        let con = self.heightAnchor.constraint(equalToConstant: 50)
        con.priority = 900 // 优先级调低
     */

    @IBAction func onSettingsButtonTap(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.25, animations: {
            self.emojiButtons.forEach {
                $0.isHidden = !$0.isHidden
            }
        })
    }
    
}

