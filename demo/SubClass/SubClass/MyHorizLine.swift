

import UIKit

class MyHorizLine: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        c.setLineWidth(2.0) //width为1时完成摭档
        c.setStrokeColor(UIColor.red.cgColor)
        c.move(to: CGPoint(x: 0, y: 0))
        c.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        c.strokePath()
    }


}
