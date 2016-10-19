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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
     
     - parameter sender: <#sender description#>
     */
    @IBAction func removeStar(_ sender: AnyObject) {
        let star:UIView? = self.horizontalStackView.arrangedSubviews.last
        if let aStar = star
        {
            self.horizontalStackView.removeArrangedSubview(aStar)
            aStar.removeFromSuperview()
            UIView.animate(withDuration: 0.25, animations: {
                self.horizontalStackView.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func onSettingsButtonTap(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.25, animations: {
            self.emojiButtons.forEach {
                $0.isHidden = !$0.isHidden
            }
        })
    }
    
}

