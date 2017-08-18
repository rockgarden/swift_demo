//
//  BoundedLabel.swift
//  UILabel
//
//  Created by wangkan on 2016/10/30.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class BoundedLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        c.setLineWidth(1.0)
        c.setStrokeColor(UIColor.red.cgColor)
        c.move(to: CGPoint(x: 0, y: 0))
        c.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        c.strokePath()
    }

    override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.stroke(self.bounds.insetBy(dx: 1.0, dy: 1.0))
        super.drawText(in: rect.insetBy(dx: 5.0, dy: 5.0))
    }

}
