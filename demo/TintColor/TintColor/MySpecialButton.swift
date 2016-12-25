
import UIKit

/// 不受tintColor的影响
class MySpecialButton : UIButton {
    
    var orig : NSAttributedString?
    var dim : NSAttributedString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.orig = self.attributedTitle(for:.normal)!
        let t = NSMutableAttributedString(attributedString: self.attributedTitle(for:.normal)!)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSMakeRange(0,t.length))
        self.dim = t
    }
    
    override func tintColorDidChange() {
        self.setAttributedTitle(
           self.tintAdjustmentMode == UIViewTintAdjustmentMode.dimmed ? self.dim : self.orig,
            for:.normal)
    }
}
