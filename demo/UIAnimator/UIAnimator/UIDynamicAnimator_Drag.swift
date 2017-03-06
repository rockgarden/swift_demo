
import UIKit

class UIDynamicAnimator_Drag : UIViewController {
    var anim : UIDynamicAnimator!
    var att : UIAttachmentBehavior!

    @IBAction func dragging(_ p: UIPanGestureRecognizer) {
        switch p.state {
        case .began:
            self.anim = UIDynamicAnimator(referenceView:self.view)
            self.anim.delegate = self
            let loc = p.location(ofTouch:0, in:p.view)
            let cen = CGPoint(p.view!.bounds.midX, p.view!.bounds.midY)
            let off = UIOffsetMake(loc.x-cen.x, loc.y-cen.y)
            let anchor = p.location(ofTouch:0, in:self.view)
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

