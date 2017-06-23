

import UIKit


class ViewAnimationVC: UIViewController {
    @IBOutlet weak var v: UIView!
    var which = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func doWhich(_ sender: Any) {
        (sender as? UIButton)?.setTitle("Case \(which)", for: .normal)
        print(self.v?.center.y as Any)
        switch self.which {
        case 0:
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1)
            self.v.backgroundColor = .red
            UIView.commitAnimations()
        case 1:
            UIView.animate(withDuration:1) {
                self.v.backgroundColor = .gray
            }
        case 2:
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                print("starting the animation (not really)")
                self.v.backgroundColor = .blue
                print("ending the animation (not really)")
            }
            anim.startAnimation()
            print("starting to sleep")
            usleep(1000000)
            print("finished sleeping")
        case 3:
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.v.backgroundColor = .red
                self.v.center.y += 100
            }
            anim.startAnimation()
        case 4:
            let anim = UIViewPropertyAnimator(duration: 1, timingParameters: UICubicTimingParameters(animationCurve:.linear))
            anim.addAnimations {
                self.v.backgroundColor = .blue
            }
            anim.addAnimations {
                self.v.center.y -= 100
            }
            anim.startAnimation()
        case 5:
            let v2 = UIView()
            v2.backgroundColor = .black
            v2.alpha = 0
            v2.frame = self.v.frame
            self.v.superview!.addSubview(v2)
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.v.alpha = 0
                v2.alpha = 1
            }

            /// proving that multiple completions work
            anim.addCompletion { _ in
                print("v2 removing")
                // if delete v case 6 can't run.
                v2.removeFromSuperview()
                self.v.alpha = 1
            }
            anim.addCompletion {
                _ in print("one ringy dingy")
            }

            anim.startAnimation()
        case 6:
            UIView.animate(withDuration:2, animations: {
                self.v.center.x += 100
            })
            delay(1) {
                // let opts = UIViewAnimationOptions.beginFromCurrentState
                UIView.animate(withDuration:1, delay: 0, options: [],
                               animations: {
                                self.v.center.y += 100
                })
            }
        case 7:
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.v.backgroundColor = .red
                UIView.performWithoutAnimation {
                    self.v.center.y += 100
                }
            }
            anim.startAnimation()
        case 8:
            func report(_ ix:Int) {
                // at last, the presentation layer comes to you as a CALayer (Optional)
                let pres = self.v.layer.presentation()!.position.y
                let model = self.v.center.y
                print("step \(ix): presentation \(pres), model \(model)")
            }
            let anim = UIViewPropertyAnimator(duration: 2, curve: .linear) {
                report(2)
                self.v.center.y += 100
                report(3)
            }
            anim.addCompletion {
                _ in
                report(4)
            }
            self.v.center.y -= 300
            report(1)
            anim.startAnimation()
        case 9:
            let anim = UIViewPropertyAnimator(duration: 0, curve: .linear) {
                self.v.center.y += 100
                self.v.center.y -= 100
            }
            anim.addCompletion {_ in print(self.v.center.y)}
            anim.startAnimation()
            print(anim.duration) // 0 turns out to mean 0.2
        case 10:
            let anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                print("start2")
                self.v.center.y += 100
            }
            anim.startAnimation(afterDelay:2)
            print(anim.delay)
            print(anim.isInterruptible)
            print(anim.isUserInteractionEnabled)
            print(anim.isManualHitTestingEnabled)
            print("start")
        case 11:
            let opts : UIViewAnimationOptions = .autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                self.v.center.x -= 100
            }, completion: {
                _ in
                self.v.center.x = xorig
            })
        // can't figure out how to reproduce that using property animator
        case 12:
            let opts : UIViewAnimationOptions = .autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(3) // *
                self.v.center.x += 100
            }, completion: {
                _ in
                self.v.center.x = xorig
            })
        case 13:
            print(self.v.center)
            let anim = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                self.v.center.y += 100
            }
            anim.addAnimations({
                self.v.center.x += 100
            }, delayFactor: 0.5)
            anim.addCompletion {
                _ in print(self.v.center)
            }
            anim.startAnimation()
        case 14:
            print(self.v.center)
            let yorig = self.v.center.y
            let anim = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                self.v.center.y -= 100
            }
            anim.addAnimations({
                self.v.center.y = yorig
            }, delayFactor: 0.5)
            anim.addCompletion {
                _ in print(self.v.center)
            }
            anim.startAnimation()

        case 9:
            self.animate(count:3)
        case 10:
            let opts = UIViewAnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(times:3, duration:1, delay:0, options:opts, animations:{
                self.v.center.x += 100
            }, completion:{
                _ in
                self.v.center.x = xorig
            })
        case 11:
            UIView.animate(withDuration:1) {
                self.v.center.x += 100
            }
            // let opts = UIViewAnimationOptions.beginFromCurrentState
            UIView.animate(withDuration:1) {
                self.v.center.y += 100
            }
        case 12:
            UIView.perform(.delete, on: [self.v], animations: nil) {
                _ in print(self.v.superview as Any)
            }

        default:break
        }

        which = which < 14 ? which+1 : 0
    }

    let whichAnimateWay = 2 // 1 or 2

    func animate(count: Int) {
        switch whichAnimateWay {
        case 1:
            let opts = UIViewAnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                UIView.setAnimationRepeatCount(Float(count)) // I really don't like this
                self.v.center.x += 100
            }, completion: {
                _ in
                self.v.center.x = xorig
            })
        case 2:
            let opts = UIViewAnimationOptions.autoreverse
            let xorig = self.v.center.x
            UIView.animate(withDuration:1, delay: 0, options: opts, animations: {
                self.v.center.x += 100
            }, completion: {
                _ in
                self.v.center.x = xorig
                if count > 1 {
                    delay(0) {
                        self.animate(count:count-1)
                    }
                }
            })
        default: break
        }
    }

    @IBAction func doWay() {

    }

}

