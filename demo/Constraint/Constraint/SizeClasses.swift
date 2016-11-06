//
//  SizeClasses.swift
//  Constraint
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class SizeClasses: UIViewController {

    @IBOutlet var lab : UILabel!

    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change")
        let tc = self.traitCollection
        print(tc)
        if tc.horizontalSizeClass == .regular {
            print("regular")
            if self.con1 != nil {
                print("changing constraints")
                NSLayoutConstraint.deactivate([self.con1, self.con2])
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.constraints(withVisualFormat: "V:[tg]-[lab]", options: [], metrics: nil, views: ["tg":self.topLayoutGuide, "lab":self.lab]),
                    [self.lab.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)]
                    ].joined().map{$0})
                let sz = self.lab.font.pointSize * 2
                self.lab.font = self.lab.font.withSize(sz)
            }
        }
    }

}


