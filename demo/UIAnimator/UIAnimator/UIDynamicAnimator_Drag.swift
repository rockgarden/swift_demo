
import UIKit


/// Drag By UIAttachmentBehavior
class UIDynamicAnimator_Drag : UIViewController {

    var anim : UIDynamicAnimator!
    /// UIAttachmentBehavior对象创建两个动态项之间的关系，或动态项与锚点之间的关系。 当两件物品相连时，赋予一件物品的力会以规定的方式影响另一件物品的移动。 当项目附加到锚点时，该项目的移动受其与指定锚点的连接的影响。 一些附件行为支持两个项目和一个锚点。您在创建时指定所需的附件行为类型。 这个类提供了许多创建和初始化方法，每个方法创建一个不同类型的附件行为，以后不能改变。 但是，您可以使用此类的属性更改附件行为的特定属性。 例如，您可以更改两个附件之间的距离或更改应用于物品的阻尼力。
    var att : UIAttachmentBehavior!

    @IBAction func dragging(_ p: UIPanGestureRecognizer) {
        switch p.state {
        case .began:
            self.anim = UIDynamicAnimator(referenceView:view)
            self.anim.delegate = self
            let loc = p.location(ofTouch:0, in:p.view)
            let cen = CGPoint(p.view!.bounds.midX, p.view!.bounds.midY)
            let off = UIOffsetMake(loc.x-cen.x, loc.y-cen.y)
            let anchor = p.location(ofTouch:0, in:view)
            let att = UIAttachmentBehavior(item:p.view!,
                                           offsetFromCenter:off, attachedToAnchor:anchor)
            self.anim.addBehavior(att)
            self.att = att
        case .changed:
            self.att.anchorPoint = p.location(ofTouch:0, in: self.view)
        default:
            print("done")
            self.anim = nil
        }
    }
}


extension UIDynamicAnimator_Drag : UIDynamicAnimatorDelegate {

    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("pause")
    }

    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("resume")
    }

}

