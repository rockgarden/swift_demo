//
//  RotatingButton.swift
//  UIControlDemo
//
//  Created by wangkan on 2017/7/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit


class RotatingButton: UIButton {

    open var errorColor:UIColor = .red

    fileprivate var completed:(()->Void)?
    fileprivate var originalColor:UIColor!
    fileprivate var originalRadius:CGFloat = 0.0
    fileprivate var stateLayer:RotationLayer!

    typealias ControlStateDictionary = [UInt: Any]
    fileprivate var imagens = ControlStateDictionary()

    var normalImage: UIImage!
    var imgTmp: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }

    convenience init(image: UIImage) {
        self.init()
        super.setImage(image, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if stateLayer == nil {
            setUp()
        }
    }

    /// Animates in when touches begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard (normalImage != nil) else {return}
        startLoading()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delay(3){
            self.stopLoading(true, completed: {
                print("Test load Completed")
            })
        }
    }

    fileprivate func setUp() {
        normalImage = super.image(for: .normal)
        guard (normalImage != nil) else {return}
        imgTmp = UIImage.clearImage(size: (super.imageView?.bounds.size)!)
        stateLayer = RotationLayer(frame:self.bounds, image: normalImage)
        self.layer.addSublayer(stateLayer)
        storeDefaultValues()
    }

    fileprivate func storeDefaultValues() {
        self.originalRadius = self.layer.cornerRadius
        self.originalColor = self.backgroundColor
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        _ = states.map({
            // Images for State
            self.imagens[$0.rawValue] = super.image(for: $0)
        })
    }

    open func startLoading() {
        guard (normalImage != nil) else {return}
        self.isEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel?.isHidden = true
            super.setImage(self.imgTmp, for: .normal)
        })
        self.stateLayer.currentState = .loading
    }

    open func stopLoading(_ result:Bool,completed:(() -> Void)?) {
        self.completed = completed
        self.isEnabled = true
        self.stateLayer.currentState = (result) ? .scuess : .error
        self.titleLabel?.isHidden = false
        super.setImage(normalImage, for: .normal)
    }

}


enum RotationLoadingState {
    case loading
    case scuess
    case error
    case none
}

class RotationLayer: CALayer {

    var layerFrame = CGRect.zero
    var hideInternal:TimeInterval = 0.3
    var cgImage: CGImage!

    lazy var rotationAnimation: CABasicAnimation = {
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

    convenience init(frame:CGRect, image: UIImage){
        self.init()
        self.frame = frame
        self.backgroundColor = UIColor.clear.cgColor
        self.cgImage = image.cgImage
        self.contents = cgImage
        self.isHidden = true
    }

    var currentState: RotationLoadingState = .none{
        didSet {
            switch currentState {
            case .loading:
                hideInternal = 0.0
                self.isHidden = false
                self.add(rotationAnimation, forKey: "RotationAnimation")
                break
            case .scuess,.error:
                self.removeAllAnimations()
                break
            case .none:
                self.isHidden = true
            }
        }
    }
}


// MARK: - UIImage
fileprivate extension UIImage {

    /// UIImage clear
    static func clearImage(size: CGSize, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsPopContext()
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return  UIImage(cgImage: outputImage.cgImage!, scale: scale, orientation: UIImageOrientation.up)
    }

    static func clearImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        UIGraphicsPopContext()
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return  outputImage
    }
}
