//
//  TouchCaptureGesture.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 2017/4/27.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

/// Managing the touch data
struct StrokeSample {
    let location: CGPoint
    
    init(location: CGPoint) {
        self.location = location
    }
}


/// Properties of the TouchCaptureGesture class
class TouchCaptureGesture: UIGestureRecognizer, NSCoding {
    var trackedTouch: UITouch? = nil
    var samples = [StrokeSample]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(target: nil, action: nil)
        
        self.samples = [StrokeSample]()
    }
    
    func encode(with aCoder: NSCoder) { }
    
    /// Beginning the capture of touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if touches.count != 1 {
            self.state = .failed
        }
        
        // Capture the first touch and store some information about it.
        if self.trackedTouch == nil {
            if let firstTouch = touches.first {
                self.trackedTouch = firstTouch
                self.addSample(for: firstTouch)
                state = .began
            }
        }
        else {
            // Ignore all but the first touch.
            for touch in touches {
                if touch != self.trackedTouch {
                    self.ignore(touch, for: event)
                }
            }
        }
    }
    
    func addSample(for touch: UITouch) {
        let newSample = StrokeSample(location: touch.location(in: self.view))
        self.samples.append(newSample)
    }
    
    /// Managing the touch input
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addSample(for: touches.first!)
        state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addSample(for: touches.first!)
        state = .ended
    }
    
    /// Cancelling and resetting the continuous gesture
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.samples.removeAll()
        state = .cancelled
    }
    
    override func reset() {
        self.samples.removeAll()
        self.trackedTouch = nil
    }
}
