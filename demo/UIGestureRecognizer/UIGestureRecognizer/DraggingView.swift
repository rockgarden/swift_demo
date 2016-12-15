//
//  DraggingView.swift
//  UIGestureRecognizer
//

import UIKit

class DraggingView: UIView {

    var lastLocation = CGPoint(x: 0, y: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)

        /// 拖曳手势识别器 (pan gesture recognizer)
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(self.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]

        // randomize view color
        let blueValue = CGFloat(Int(arc4random() % 255)) / 255.0
        let greenValue = CGFloat(Int(arc4random() % 255)) / 255.0
        let redValue = CGFloat(Int(arc4random() % 255)) / 255.0

        self.backgroundColor = UIColor(red:redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// translation 变量 获取到新的坐标值之后,视图的中心将根据改变后的坐标值做出相应调整。
    func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }

    override func touchesBegan(_ touches: (Set<UITouch>!), with event: UIEvent!) {
        // Promote the touched view
        self.superview?.bringSubview(toFront: self)

        // Remember original location
        lastLocation = self.center
    }
}
