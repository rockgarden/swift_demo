//  The MIT License (MIT)
//
//  Copyright (c) 2014 Hunter Whittle
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import QuartzCore

class ActivityButton: UIControl {
    
    fileprivate let activityViewArray = NSMutableArray(capacity: 0)
    let titleLabel = UILabel()
    var rotatorColor = UIColor.darkGray
    var rotatorSize: CGFloat = 8.0
    var rotatorSpeed: CGFloat = 10.0
    var rotatorPadding: CGFloat = 0.0
    var defaultTitle = ""
    var activityTitle = ""
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
        
        self.setUp()
    }
    
    fileprivate func setUp() {
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.width)
        self.layer.cornerRadius = self.frame.size.width / 2
        
        titleLabel.frame = self.bounds
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        titleLabel.isUserInteractionEnabled = false
        self.addSubview(titleLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject! = touches.first
        let touchPoint = touch.location(in: self)
        
        if self.bounds.contains(touchPoint) {
            if(self.activityViewArray.count < 1) {
                self.startActivity()
            }
            
            self.isUserInteractionEnabled = false
        }
        
        self.titleLabel.alpha = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleLabel.alpha = 0.25
        super.touchesBegan(touches, with: event)
    }
    
    func startActivity() {
        for i in 1...Int(self.rotatorSpeed * 1.5) {
            let activityView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: rotatorSize, height: rotatorSize))
            activityView.layer.cornerRadius = activityView.frame.size.height / 2
            activityView.backgroundColor = self.rotatorColor
            activityView.alpha = 1.0 / (CGFloat(i) + 0.05)
            
            self.activityViewArray.add(activityView)
        }
        
        for view: Any in self.activityViewArray {
            if let activityView = view as? UIView {
                
                let pathAnimation = CAKeyframeAnimation(keyPath: "position")
                pathAnimation.calculationMode = kCAAnimationLinear
                pathAnimation.fillMode = kCAFillModeForwards
                pathAnimation.isRemovedOnCompletion = false
                pathAnimation.repeatCount = HUGE
                pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                pathAnimation.duration = CFTimeInterval(300.0) / CFTimeInterval(self.rotatorSpeed)
                
                let curvedPath = CGMutablePath()
                
                self.addSubview(activityView)
                let index = self.activityViewArray.index(of: activityView)
                
                let padding = self.frame.size.width / 2;
                let startAngle: CGFloat = 270.0 - (CGFloat(index) * 4)

                /// CGPathAddArc(CGMutablePathRef path, const CGAffineTransform *m, CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle, bool clockwise)
                
                curvedPath.addArc(center: CGPoint(x: self.bounds.origin.x+padding, y: self.bounds.origin.y+padding), radius: padding + self.rotatorPadding, startAngle: self.degreesToRadians(startAngle), endAngle: 360, clockwise: false)
                
                pathAnimation.path = curvedPath 
                
                activityView.layer.add(pathAnimation, forKey: "myCircleAnimation")
            }
        }
        
        if (self.titleLabel.text != nil) {
            self.defaultTitle = self.titleLabel.text!;
        }
        
        self.activityTitle = self.activityTitle.isEqual("") ? self.defaultTitle : self.activityTitle
        self.titleLabel.text = self.activityTitle as String
    }
    
    func stopActivity() {
        
        for view: Any in self.activityViewArray {
            if let activityView = view as? UIView {
                activityView.layer.removeAllAnimations()
                activityView.removeFromSuperview()
            }
        }
        
        if(!self.defaultTitle.isEqual("")) {
            self.titleLabel.text = self.defaultTitle as String
        }
        
        self.activityViewArray.removeAllObjects();
        self.isUserInteractionEnabled = true;
    }
    
    func setTitle(_ title: NSString) {
        titleLabel.text = title as String
    }
    
    fileprivate func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        
        let result = ((degrees) / 180.0 * CGFloat(Double.pi))
        return result
    }
}
