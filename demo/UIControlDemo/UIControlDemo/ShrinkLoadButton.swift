//
//  ShrinkLoadButton.swift
//  UIControlDemo
//
//  Created by wangkan on 2017/7/10.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


import UIKit

class ShrinkLoadButton: UIButton {

    fileprivate var completed:(()->Void)?
    fileprivate var originalColor:UIColor!
    fileprivate var originalTitle: String!
    fileprivate var originalRadius: CGFloat = 0.0
    fileprivate var stateLayer: ShrinkLoadLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }

    override func awakeFromNib() {}

    /// Animates in when touches begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        startLoading()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delay(6){
            self.stopLoading(completed: {
                print("Test load Completed")
            })
        }
    }

    fileprivate func setUp() {
        stateLayer = ShrinkLoadLayer(frame: self.bounds)
        stateLayer.strokeColor = self.titleLabel?.textColor.cgColor
        self.layer.addSublayer(stateLayer)
        self.originalRadius = self.layer.cornerRadius
        self.originalColor = self.backgroundColor
        originalTitle = title(for: UIControlState())
    }

    func startLoading() {
        self.setShrink(true,shrinkKey:"ShrinkStart")
        delay(0.3){self.stateLayer.currentState = .loading}
    }

    func stopLoading(completed:(() -> Void)?) {
        self.completed = completed
        self.stateLayer.currentState = .scuess
        self.setShrink(false,shrinkKey:"ShrinkScuess")
    }

    fileprivate func setShrink(_ isShrink:Bool,shrinkKey:String){
        self.isEnabled = !isShrink
        if isShrink {
            setTitle("", for: UIControlState())
        } else {
            setTitle(self.originalTitle, for: UIControlState())
        }

        let shrink = CABasicAnimation(keyPath:"bounds.size.width")
        shrink.fromValue = (isShrink) ? (self.frame.size.width) : (self.frame.size.height)
        shrink.toValue  = (isShrink) ? (self.frame.size.height) : (self.frame.size.width)
        shrink.duration = 0.3

        let corner = CABasicAnimation(keyPath:"cornerRadius")
        corner.fromValue = (isShrink) ? self.originalRadius : self.frame.size.height/2
        corner.toValue =  (isShrink) ? self.frame.size.height/2 : self.originalRadius
        corner.duration = 0.3

        let groupA = CAAnimationGroup()
        groupA.animations = [shrink,corner]
        groupA.duration = 0.3
        groupA.isRemovedOnCompletion = false
        groupA.fillMode = kCAFillModeForwards
        groupA.setValue(shrinkKey, forKey: "Animation")
        self.layer.add(groupA, forKey: "Animation")
    }

    private func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}


enum ShrinkLoadingState {
    case loading
    case scuess
    case error
    case none
}


class ShrinkLoadLayer: CAShapeLayer {

    var layerFrame = CGRect.zero
    var hideInternal:TimeInterval = 0.0

    lazy var rotationAnimation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        animation.fromValue  = (0)
        animation.toValue    = (Float.pi * 2);
        animation.duration   = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = HUGE
        animation.fillMode = kCAFillModeBackwards
        animation.isRemovedOnCompletion = false
        return animation
    }()

    lazy var pathAnimation:CABasicAnimation = {
        let animation = CABasicAnimation(keyPath:"strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.duration = 0.7
        animation.fillMode = kCAFillModeBackwards
        animation.isRemovedOnCompletion = false
        return animation
    }()

    convenience init(frame:CGRect) {
        self.init()
        layerFrame = frame
        self.setPath()
    }

    func setPath() {
        let startAngle = 0 - Float.pi/2 ;
        let endAngle   = Float.pi * 2 - Float.pi/2;
        let height = min(layerFrame.size.height, layerFrame.size.width)
        let radius = height/2
        let center = CGPoint(x: height/2, y: height/2)
        self.frame = CGRect(x: 0, y: 0, width: height, height: height)

        self.path = UIBezierPath(arcCenter: center, radius: radius/2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).cgPath;

        self.fillColor = nil
        self.lineWidth = 2.0
        self.strokeEnd = 0.4
        self.isHidden = true
    }

    var currentState: ShrinkLoadingState = .none{
        didSet {
            switch currentState {
            case .loading:
                hideInternal = 0.0
                self.isHidden = false
                self.add(rotationAnimation, forKey: "RotationAnimation")
                break
            case .scuess,.error:
                self.removeAllAnimations()
                self.isHidden = true
                break
            case .none:
                self.setPath()
            }
        }
    }

    func drawCheckPath(){
        let bezier = UIBezierPath()
        let frame = self.frame
        let centerX = frame.width/2
        let centerY = frame.height/2
        if(self.currentState == .scuess){
            bezier.move(to: CGPoint(x: centerX - centerX/2,y: centerY))
            bezier.addLine(to: CGPoint(x: centerX - 2,y: centerY + centerY/2))
            bezier.addLine(to: CGPoint(x: centerX + centerX/2 + 3,y: centerY - centerY/2 + 3))
        }else if (self.currentState == .error){
            bezier.move(to: CGPoint(x: centerX - centerX/2,y: centerY - centerY/2))
            bezier.addLine(to: CGPoint(x: centerX + centerX/2,y: centerY + centerY/2))
            bezier.move(to: CGPoint(x: centerX + centerX/2,y: centerY - centerY/2))
            bezier.addLine(to: CGPoint(x: centerX - centerX/2,y: centerX + centerX/2))
        }
        self.strokeEnd = 1.0
        self.path = bezier.cgPath
        self.add(pathAnimation, forKey: "ResultAnimation")
    }
}
