//
//  TouchViews.swift
//  UIResponder
//
//  Created by wangkan on 2017/7/22.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class MyView0 : UIView {

    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        superview!.bringSubview(toFront: self)

        let t = touches.first!
        let loc = t.location(in: superview)
        let oldP = t.previousLocation(in: superview)
        let deltaX = loc.x - oldP.x
        let deltaY = loc.y - oldP.y
        var c = self.center
        c.x += deltaX
        c.y += deltaY
        self.center = c
    }

}


class MyView1 : UIView {
    var decided = false
    var horiz = false

    override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent?) {
        self.decided = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        superview!.bringSubview(toFront:self)

        let t = touches.first!

        if !self.decided {
            self.decided = true
            let then = t.previousLocation(in:self)
            let now = t.location(in:self)
            let deltaX = abs(then.x - now.x)
            let deltaY = abs(then.y - now.y)
            self.horiz = deltaX >= deltaY
        }

        let loc = t.location(in:superview)
        let oldP = t.previousLocation(in:superview)
        let deltaX = loc.x - oldP.x
        let deltaY = loc.y - oldP.y
        var c = self.center
        if self.horiz {
            c.x += deltaX
        } else {
            c.y += deltaY
        }
        self.center = c
    }
}


class MyView2Not : UIView {
    var time : TimeInterval!

    override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent?) {
        self.time = touches.first!.timestamp
        NSObject.perform(#selector(MyView2Not.touchWasLong), with: nil, afterDelay: 0.4)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with e: UIEvent?) {
        let diff = e!.timestamp - self.time
        if (diff < 0.4) {
            print("short")
        } else {
            print("long")
        }
        // FIXME: Terminating app due to uncaught exception
        //NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(MyView2Not.touchWasLong), object: nil)
    }

    func touchWasLong() {
        print("long")
    }

}


class MyView2 : UIView {
    var time : TimeInterval!
    var single = false

    // see also http://stackoverflow.com/questions/8113268/how-to-cancel-nsblockoperation
    override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent?) {
        let ct = touches.first!.tapCount
        switch ct {
        case 2:
            self.single = false
        default: break
        }
        let t = touches.first!
        print(t.location(in:self))
        print(t.location(in:self.window!))
        print(t.location(in:nil))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with e: UIEvent?) {
        let ct = touches.first!.tapCount
        switch ct {
        case 1:
            self.single = true
            delay(0.3) {
                if self.single {
                    print("single tap")
                }
            }
        case 2:
            print("double tap")
        default: break
        }
    }

}


class MyView3 : UIView {
    var decidedDirection = false
    var horiz = false
    var decidedTapOrDrag = false
    var drag = false
    var single = false

    override func touchesBegan(_ touches: Set<UITouch>, with e: UIEvent?) {
        // be undecided
        self.decidedTapOrDrag = false
        // prepare for a tap
        let ct = touches.first!.tapCount
        switch ct {
        case 2:
            self.single = false
            self.decidedTapOrDrag = true
            self.drag = false
            return
        default: break
        }
        // prepare for a drag
        self.decidedDirection = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        if self.decidedTapOrDrag && !self.drag {return}

        self.superview!.bringSubview(toFront:self)
        let t = touches.first!

        self.decidedTapOrDrag = true
        self.drag = true
        if !self.decidedDirection {
            self.decidedDirection = true
            let then = t.previousLocation(in:self)
            let now = t.location(in:self)
            let deltaX = abs(then.x - now.x)
            let deltaY = abs(then.y - now.y)
            self.horiz = deltaX >= deltaY
        }
        let loc = t.location(in:self.superview)
        let oldP = t.previousLocation(in:self.superview)
        let deltaX = loc.x - oldP.x
        let deltaY = loc.y - oldP.y
        var c = self.center
        if self.horiz {
            c.x += deltaX
        } else {
            c.y += deltaY
        }
        self.center = c
    }

    override func touchesEnded(_ touches: Set<UITouch>, with e: UIEvent?) {
        if !self.decidedTapOrDrag || !self.drag {
            // end for a tap
            let ct = touches.first!.tapCount
            switch ct {
            case 1:
                self.single = true
                delay(0.3) {
                    if self.single {
                        print("single tap")
                    }
                }
            case 2:
                print("double tap")
            default: break
            }
        }
    }
    
}
