

import UIKit


class AnimationAndAutolayoutVC : UIViewController {
    @IBOutlet var v : UIView!
    @IBOutlet var v1 : UIView!
    @IBOutlet var v_horizontalPositionConstraint : NSLayoutConstraint!
    
    var which = 1
    var delta: CGFloat = -80

    override func viewDidLoad() {
        super.viewDidLoad()
        /// nib uses autolayout but we intend to animate v1, so we take it out of autolayout
        self.v1.translatesAutoresizingMaskIntoConstraints = true
        /// (and v1's constraints in the nib are all placeholders, so they've been deleted)
    }

    @IBAction func doButton(_ sender: Any?) {
        let b = sender as! UIButton
        b.setTitle("Test + \(which)", for: .normal)
        switch which {
        case 1:/// 若有别的关联 Constraints 则无效，比如 v1 leading v
            UIView.animate(withDuration:1) {
                self.v.center.x += 100
            }
        case 2:// 无效
            UIView.animate(withDuration:1, animations:{
                self.v.center.x -= 100
                }, completion: {
                    _ in
                    // NB new in iOS 9 must call setNeedsLayout to get layout
                    self.v.superview!.setNeedsLayout()
                    self.v.superview!.layoutIfNeeded()
            })
        case 3:// 无效
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.v.center.x += 100
            }
            anim.addCompletion {
                _ in
                self.v.superview!.setNeedsLayout()
                self.v.superview!.layoutIfNeeded()
            }
            anim.startAnimation()

        case 4:
            if let con = self.v_horizontalPositionConstraint {
                con.constant += 100
                UIView.animate(withDuration:1) {
                    self.v.superview!.layoutIfNeeded()
                }
            }
        case 5:
            // same thing with property animator
            if let con = self.v_horizontalPositionConstraint {
                con.constant -= 100
                let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                    self.v.superview!.layoutIfNeeded()
                }
                anim.startAnimation()
            }
        case 6:
            // general solution to all such problems: animate a temporary snapshot instead!
            let snap = self.v.snapshotView(afterScreenUpdates:false)!
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.isHidden = true
            UIView.animate(withDuration:0.3, delay:0, options:.autoreverse,
                animations:{
                    snap.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                }, completion: {
                    _ in
                    delay(0.1) {
                        self.v.isHidden = false
                        snap.removeFromSuperview()
                    }
                })
        case 7:
            let snap = self.v.snapshotView(afterScreenUpdates:false)!
            snap.frame = self.v.frame
            self.v.superview!.addSubview(snap)
            self.v.isHidden = true
            UIView.animate(withDuration:1) {
                snap.center.x += 100
            }
        case 8:
            // this works in iOS 7 as well; layer animation does not trigger spurious layout there
            let ba = CABasicAnimation(keyPath:"transform")
            ba.autoreverses = true
            ba.duration = 0.3
            ba.toValue = CATransform3DMakeScale(1.1, 1.1, 1)
            self.v.layer.add(ba, forKey:nil)

        case 9:
            // this works fine in iOS 8! does not trigger spurious layout
            UIView.animate(withDuration:0.3, delay: 0, options: .autoreverse, animations: {
                self.v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
            }, completion: {
                _ in
                self.v.transform = .identity
            })

        case 10:
            // don't try this one: it may appear to work but it causes a constraint conflict
            self.v.translatesAutoresizingMaskIntoConstraints = true
            UIView.animate(withDuration:1, animations:{
                self.v.center.x -= 100
            }, completion: {
                _ in
                self.v.superview!.layoutIfNeeded() // ouch
            })
        default: break
        }
        which = which < 10 ? which+1 : 1

        delta = -delta

        UIView.animate(withDuration:1, animations: {
            self.v1.center.x += self.delta
        }, completion: {
            _ in
            UIView.animate(withDuration:0.3, delay: 0, options: .autoreverse,
                           animations: {
                            self.v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
            }, completion: {
                _ in
                self.v.transform = .identity
                self.v.superview!.setNeedsLayout()
                self.v.superview!.layoutIfNeeded() //没有违反约束 no violation of constraints
            })
        })
    }

    @IBOutlet var oldConstraint: NSLayoutConstraint!

    // show that you can animate more than a change of constant
    // here, I remove one constraint and replace it with another - and I can still animate layout!
    // (I am told you can also animate change of priority, but you can't change from 1000)

    @IBAction func changeConstant(_ sender: Any) {
        let v = sender as! UIView
        let c = self.oldConstraint.constant
        NSLayoutConstraint.deactivate([self.oldConstraint])
        let newConstraint = c > 0 ?
            v.trailingAnchor.constraint(equalTo:self.view.layoutMarginsGuide.trailingAnchor, constant:-c) :
            v.leadingAnchor.constraint(equalTo:self.view.layoutMarginsGuide.leadingAnchor, constant:-c)
        NSLayoutConstraint.activate([newConstraint])
        self.oldConstraint = newConstraint
        UIView.animate(withDuration:0.4) {
            v.superview!.layoutIfNeeded()
        }
    }
}
