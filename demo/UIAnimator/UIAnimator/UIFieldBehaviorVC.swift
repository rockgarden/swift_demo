

import UIKit

class DelayedFieldBehavior : UIFieldBehavior {
    
    // ignore, just testing the syntax
    let b = UIFieldBehavior.field {
        (beh, pt, v, m, c, t) -> CGVector in
        if t > 0.25 {
            return CGVector(-v.dx, -v.dy)
        }
        return CGVector(0,0)
    }

    
    var delay = 0.0
    class func dragField(delay del:Double) -> Self {
        let f = self.field {
            (beh, pt, v, m, c, t) -> CGVector in
            if t > (beh as! DelayedFieldBehavior).delay {
                return CGVector(-v.dx, -v.dy)
            }
            return CGVector(0,0)
        }
        f.delay = del
        return f
    }
}


class UIFieldBehaviorVC: UIViewController {
    
    var anim : UIDynamicAnimator!
    
    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.anim = UIDynamicAnimator(referenceView: self.view)
        
        let v = UIView(frame:CGRect(0,70,50,50))
        v.backgroundColor = .black
        self.view.addSubview(v)

        let v1 = UIView(frame:CGRect(100,170,50,50))
        v1.backgroundColor = .gray
        self.view.addSubview(v1)

        delay(1) {
            let p = UIPushBehavior(items: [v1], mode: .instantaneous)
            p.pushDirection = CGVector(0.5, 1)
            self.anim.addBehavior(p)

            let b = UIDynamicItemBehavior(items:[v1])
            b.charge = 10
            self.anim.addBehavior(b)

            let f = UIFieldBehavior.electricField()
            // let f = UIFieldBehavior.magneticField()
            let r = self.anim.referenceView!.bounds
            f.position = CGPoint(r.midX, r.midY)
            f.strength = 1
            f.addItem(v1)
            self.anim.addBehavior(f)
        }

        switch which {
        case 1:
            let v2 = UIView(frame:CGRect(200,70,50,50))
            v2.backgroundColor = .red
            self.view.addSubview(v2)
            
            let a = UIAttachmentBehavior.slidingAttachment(with:v, attachedTo: v2, attachmentAnchor: CGPoint(125,25), axisOfTranslation: CGVector(0,1))
            a.attachmentRange = UIFloatRangeMake(-200,200)
            self.anim.addBehavior(a)
            
            delay(2) {
                print("push")
                let p = UIPushBehavior(items: [v], mode: .continuous)
                p.pushDirection = CGVector(0,0.05)
                self.anim.addBehavior(p)
            }
        case 2:
            let b = DelayedFieldBehavior.dragField(delay:0.95)
            b.region = UIRegion(size: self.view.bounds.size)
            b.position = CGPoint(self.view.bounds.midX, self.view.bounds.midY)
            b.addItem(v)
            self.anim.addBehavior(b)
            
            let p = UIPushBehavior(items: [v], mode: .instantaneous)
            p.pushDirection = CGVector(0.5, 0.5)
            self.anim.addBehavior(p)
        case 3:
            let v2 = UIView(frame:CGRect(200,70,50,50))
            v2.backgroundColor = UIColor.red
            self.view.addSubview(v2)
            
            let anch = UIDynamicItemBehavior(items: [v2])
            anch.isAnchored = true
            self.anim.addBehavior(anch)
            
            let b = UIFieldBehavior.linearGravityField(direction:CGVector(0,1))
            b.addItem(v)
            b.strength = 2
            self.anim.addBehavior(b)
            
            delay(2) {
                let a = UIAttachmentBehavior(item: v, attachedTo: v2)
                print(a.damping)
                print(a.frequency)
                a.frequency = 4
                self.anim.addBehavior(a)
            }
        default:break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("here")
        self.anim.perform(Selector(("setDebugEnabled:")), with:true)
    }

}

