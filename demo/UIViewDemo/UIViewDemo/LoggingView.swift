

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
    /*
     告诉代理层的层次已经改变了。
     当一个层的边界发生变化，并且其子层可能需要重排时，例如通过改变其框架的大小来调用layoutSublayers（of :)方法。如果需要精确控制图层子层的布局，则可以实现此方法。
     */
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        print("\(self) \(#function)\n")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("\(self) \(#function)\n")
    }

    let delegate = LayerDelegate()

    lazy var sublayer: CALayer = {
        let layer = CALayer()

        layer.addSublayer(CALayer())
        layer.sublayers?.first?.backgroundColor = UIColor.blue.cgColor

        layer.delegate = self.delegate

        return layer
    }()

}


/// LayerDelegate: 实现CALayerDelegate并将其设置为层（命名为子层）委托的类。当图层的大小更改时，代理的layoutSublayers（of :)将迭代子层的所有子层，并调整它们的大小以适应其中。
class LayerDelegate: NSObject, CALayerDelegate {
    func layoutSublayers(of layer: CALayer) {
        layer.sublayers?.forEach {
            $0.frame = layer.bounds
        }
    }
}
