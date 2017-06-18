
import UIKit

class HitTestVC : UIViewController {

    @IBAction func doButton(_ sender: Any?) {
        print("button tap!")
    }
    
    @IBAction func tapped(_ g: UITapGestureRecognizer) {
        let p = g.location(ofTouch:0, in: g.view)
        let v = g.view?.hitTest(p, with: nil)
        if let v = v as? UIImageView {
            UIView.animate(withDuration:0.2, delay: 0,
                options: .autoreverse,
                animations: {
                    v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                }, completion: {
                    _ in
                    v.transform = .identity
                })
        }
    }

}


class MyView_hT : UIView {
    
    // 如果超级视图没有剪辑到边界，你可以看到它的超级视图 view 之外的一个子视图 Button，尝试点按它, 无效，因为通常情况下，无法在其超级视图之外触及子视图的区域
    // 通过 覆盖 hitTest 使得 触及子视图 成为可能

    /*
     返回包含指定点的视图层次结构（包括自身）中的接收者的最远后代。
     该方法遍历视图层次结构，调用每个子视图的point（inside :) with :)方法来确定哪个子视图应该接收触摸事件。如果point（with :)返回true，则子视图的层次结构也会相似地遍历，直到找到包含指定点的最前面的视图。如果视图不包含该点，则其视图层次结构的分支将被忽略。您很少需要自己调用此方法，但您可以覆盖它以从子视图中隐藏触摸事件。
     此方法将忽略隐藏的视图对象，该对象已禁用用户交互，或者具有小于0.01的Alpha级别。当确定命中时，此方法不会考虑视图的内容。因此，即使指定的点在该视图的内容的透明部分中，仍然可以返回视图。
     位于接收者边界之外的点不会被报告为命中，即使它们实际上位于接收者的子视图之一内。如果当前视图的clipToBounds属性设置为false并且受影响的子视图超出视图的边界，则可能会发生这种情况。
     */
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with:e) {
            return result
        }
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with:e) {
                return result
            }
        }
        return nil
    }
}
