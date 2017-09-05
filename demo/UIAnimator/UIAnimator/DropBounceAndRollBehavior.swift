
import UIKit


class DropBounceAndRollBehavior : UIDynamicBehavior, UICollisionBehaviorDelegate {

    let v : UIView

    init(view v:UIView) {
        self.v = v
        super.init()
    }

    override func willMove(to anim: UIDynamicAnimator?) {
        guard let anim = anim else { return }

        let sup = self.v.superview!

        let grav = UIGravityBehavior()
        grav.action = {
            // self will retain grav so do not let grav retain self
            // unowned 将保证指针释放 weak 则无效
            [unowned self] in
            let items = anim.items(in: sup.bounds) as! [UIView]
            if items.index(of:self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
                print("done")
            }
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)

        let push = UIPushBehavior(items:[self.v], mode:.instantaneous)
        push.pushDirection = CGVector(1,0)
        //push.setTargetOffsetFromCenter(UIOffsetMake(0,-200), forItem: self.iv)
        self.addChildBehavior(push)

        let coll = UICollisionBehavior()
        coll.collisionMode = .boundaries
        coll.collisionDelegate = self
        coll.addBoundary(withIdentifier:"floor" as NSString,
                         from:CGPoint(0, sup.bounds.maxY),
                         to:CGPoint(sup.bounds.maxX, sup.bounds.maxY))
        self.addChildBehavior(coll)
        coll.addItem(self.v)

        let bounce = UIDynamicItemBehavior()
        bounce.elasticity = 0.8
        self.addChildBehavior(bounce)
        bounce.addItem(self.v)

    }

    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at p: CGPoint) {
        print(p)
        // look for the dynamic item behavior
        let b = self.childBehaviors
        if let ix = b.index(where:{$0 is UIDynamicItemBehavior}) {
            let bounce = b[ix] as! UIDynamicItemBehavior
            let v = bounce.angularVelocity(for:item)
            print("Behavior Print - angular velocity: \(v)")
            if v <= 6 {
                print("adding angular velocity")
                bounce.addAngularVelocity(6, for:item)
            }
        }
    }

    deinit {
        print("farewell from behavior")
    }

}
