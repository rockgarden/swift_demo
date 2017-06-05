
import UIKit

class MyDynamicAnimator : UIDynamicAnimator {
    deinit {
        print("animator: farewell")
    }
}


class FlushFlowLayout : UICollectionViewFlowLayout {
    
    var animating = false
    var animator : UIDynamicAnimator!
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var arr = super.layoutAttributesForElements(in: rect)!
        /// this part is just to get our left-justified layout
        if let sup = super.layoutAttributesForElements(in: rect) {
            arr = sup.map {
                atts in // remove (var atts)
                var atts = atts
                if atts.representedElementKind == nil {
                    let ip = atts.indexPath
                    atts = self.layoutAttributesForItem(at: ip)!
                }
                return atts
            }
        }

        // 对于每个属性，如果它可以来自动画师，请改用该属性for each attribute, if it can come from the animator, use that attribute instead
        if self.animating {
            return arr.map {
                atts in
                let path = atts.indexPath
                switch atts.representedElementCategory {
                case .cell:
                    if let atts2 = self.animator?
                        .layoutAttributesForCell(at: path) {
                            return atts2
                    }
                case .supplementaryView:
                    if let kind = atts.representedElementKind {
                        if let atts2 = self.animator?
                            .layoutAttributesForSupplementaryView(
                                ofKind: kind, at:path) {
                                    return atts2
                        }
                    }
                default: break
                }
                return atts
            }
        }
        return arr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var atts = super.layoutAttributesForItem(at: indexPath)!
        if (indexPath as NSIndexPath).item == 0 {
            return atts // degenerate case 1
        }
        if atts.frame.origin.x - 1 <= self.sectionInset.left {
            return atts // degenerate case 2
        }
        /// (indexPath as NSIndexPath).item = indexPath.row
        let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
        let fPv = self.layoutAttributesForItem(at: ipPv)!.frame
        let rightPv = fPv.origin.x + fPv.size.width + self.minimumInteritemSpacing
        atts = atts.copy() as! UICollectionViewLayoutAttributes
        atts.frame.origin.x = rightPv
        return atts
    }
    
    func flush () {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let visworld = self.collectionView!.bounds
        let anim = MyDynamicAnimator(collectionViewLayout:self)
        self.animator = anim
        
        let atts = self.layoutAttributesForElements(in: visworld)!
        self.animating = true
        
        // collision behavior: floor, with a hole at the left end
        let items = atts.filter {
            $0.representedElementKind == nil
        }
        let coll = UICollisionBehavior(items:items)
        let p1 = CGPoint(x: visworld.minX + 80, y: visworld.maxY)
        let p2 = CGPoint(x: visworld.maxX, y: visworld.maxY)
        /// NSCopying协议声明一种提供对象的功能副本的方法。 “复制”的确切含义可能会有所不同，但副本必须是功能上独立的对象，该对象的值与创建复制时的原始值相同。由NSCopying生成的副本由负责释放它的发件人隐含地保留。相当于 "bottom" as NSString
        coll.addBoundary(withIdentifier: "bottom" as NSCopying, from:p1, to:p2)
        coll.collisionMode = .boundaries
        coll.collisionDelegate = self
        anim.addBehavior(coll)

        let beh = UIDynamicItemBehavior(items:atts)
        beh.elasticity = 0.8
        beh.friction = 0.1
        anim.addBehavior(beh)
        
        let grav = UIGravityBehavior(items:atts)
        grav.magnitude = 0.8
        grav.action = {
            let atts = self.animator.items(in: visworld)
            if atts.count == 0 || anim.elapsedTime > 4 {
                print("done")
                delay(0) { // memory management
                    self.animator.removeAllBehaviors()
                    self.animator = nil
                }
                delay(0.4) { // looks better if there's a pause
                    self.animating = false
                    self.invalidateLayout()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        anim.addBehavior(grav)
    }
}


extension FlushFlowLayout : UICollisionBehaviorDelegate {

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let push = UIPushBehavior(items:[item], mode:.continuous)
        push.setAngle(3*CGFloat(Float.pi)/4.0, magnitude:1.5)
        self.animator.addBehavior(push)
    }

}
