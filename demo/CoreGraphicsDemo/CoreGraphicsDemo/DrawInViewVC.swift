//
//  DrawInViewVC.swift
//  Draw
//
//  Created by wangkan on 2017/3/2.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


import UIKit

class DrawInViewVC : UIViewController {

    @IBAction func buttonPressed(_ sender: AnyObject) {
        let mv = RocketView(mothed: sender.selectedSegmentIndex + 1)
        mv.backgroundColor = .cyan
        //FIXME: 如何加在视图的顶层, 若不addConstraints则new mv 不可见
        view.addSubview(mv)
        mv.translatesAutoresizingMaskIntoConstraints = false

        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[v]-25-|", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"V:[v(150)]", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .centerY, relatedBy: .equal, toItem: mv.superview, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let mv = RocketView(mothed: 1)
        mv.backgroundColor = .cyan
        view.addSubview(mv)
        mv.translatesAutoresizingMaskIntoConstraints = false

        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-25-[v]-25-|", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:"V:[v(150)]", metrics: nil, views: ["v":mv])
        )
        mv.superview!.addConstraint(
            NSLayoutConstraint(item: mv, attribute: .centerY, relatedBy: .equal, toItem: mv.superview, attribute: .centerY, multiplier: 1, constant: 0)
        )

        // comment out to experiment with resizing
        delay(2) {
            mv.bounds.size.height *= 2
        }
        
    }
    
}

