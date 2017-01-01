
import UIKit

extension CGSize {
    func sizeByDelta(dw:CGFloat, dh:CGFloat) -> CGSize {
        return CGSize(self.width + dw, self.height + dh)
    }
}

class MyShrinkingButton: UIButton {

    override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.backgroundRect(forBounds:bounds)
        if self.isHighlighted {
            result = result.insetBy(dx: 3, dy: 3)
        }
        return result
    }
    
    override var intrinsicContentSize : CGSize {
        return super.intrinsicContentSize.sizeByDelta(dw:25, dh: 20)
    }

}
