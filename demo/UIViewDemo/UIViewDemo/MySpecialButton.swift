
import UIKit

/// 不受tintColor的影响
class MySpecialButton : UIButton {

    var orig : NSAttributedString?
    var dim : NSAttributedString?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.orig = self.attributedTitle(for:.normal)!
        let t = NSMutableAttributedString(attributedString: self.attributedTitle(for:.normal)!).then({ n in
            n.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: NSMakeRange(0,n.length))
        })

        self.dim = t
    }

    override func tintColorDidChange() {
        self.setAttributedTitle(
            /*
             tintAdjustmentMode总是返回UIViewTintAdjustmentModeNormal或UIViewTintAdjustmentModeDimmed。 返回的值是接收者的超级视图链中的第一个非默认值（从本身开始）。
                   如果没有找到非默认值，则返回UIViewTintAdjustmentModeNormal。
                   当tintAdjustmentMode对于视图具有UIViewTintAdjustmentModeDimmed值时，将从tintColor返回的颜色将被修改为给出一个灰色的外观。
                   当视图的tintAdjustmentMode更改（视图的值更改或其一个超级视图的值更改时），将调用-tintColorDidChange以允许视图刷新其呈现。
             */
            self.tintAdjustmentMode == UIViewTintAdjustmentMode.dimmed ? self.dim : self.orig,
            for:.normal)
    }
}
