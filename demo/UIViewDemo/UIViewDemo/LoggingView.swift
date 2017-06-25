

import UIKit

class LoggingView: UIView {

    override func updateConstraints() {
        super.updateConstraints()
        print("\(self) \(#function)\n")
    }

    /* Called when the layer requires layout. The default implementation
     * calls the layout manager if one exists and it implements the
     * -layoutSublayersOfLayer: method. Subclasses can override this to
     * provide their own layout algorithm, which should set the frame of
     * each sublayer. */
    // 替代layoutSublayersOfLayer
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        print("\(self) \(#function)\n")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self) \(#function)\n")
    }

}
