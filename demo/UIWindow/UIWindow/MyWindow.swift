
import UIKit

class MyWindow: UIWindow {

    // NB tested in split screen mode! still works
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        let lay = self.layer.hitTest(point)
        // ... possibly do something with that information
        print(lay?.backgroundColor as Any)
        return super.hitTest(point, with:e)
    }

}
