//
//  submitButton.swift
//
//  Created by YU CHONKAO on 2016/7/20.
//  Copyright © 2016年 YU CHONKAO. All rights reserved.
//

import UIKit

@objc public enum SubmitButtonState: Int {
    case normal = 0
    case loading = 1
    case success = 2
    case warning = 3
}

// FIXME: 不支持Autolayout
public class SubmitButton: UIView, CAAnimationDelegate {

    // Color with default value
    public var normalBackgrounColor: UIColor   = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var submitIconColor: UIColor        = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    public var loadingBackgrounColor: UIColor  = UIColor(red: 255/255, green: 248/255, blue: 247/255, alpha: 1.0)
    public var loadingIconColor: UIColor       = UIColor(red: 6/255, green: 164/255, blue: 191/255, alpha: 1.0)
    public var successBackgroundColor: UIColor = UIColor(red: 65/255, green: 195/255, blue: 143/255, alpha: 1.0)
    public var successIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var warningBackgroundColor: UIColor = UIColor(red: 1.0, green: 131/255, blue: 98/255, alpha: 1.0)
    public var warningIconColor: UIColor       = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    public var shadowColor: UIColor            = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.5)
    
    // Custom UI Element
    public var submitImage: UIImage! {
        didSet {
            self.submitImageView.image = submitImage.withRenderingMode(.alwaysTemplate)
        }
    }
    public var successImage: UIImage! {
        didSet {
            self.successImageView.image = successImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate);
        }
    }
    public var warningImage: UIImage! {
        didSet {
            self.warningImageView.image = warningImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate);
        }
    }
    
    // Custom UI Setting
    public var shouldShowShadow: Bool = true {
        didSet {
            self.layer.shadowOpacity = shouldShowShadow ? 1.0 : 0.0;
        }
    }
    
    public var buttonState: SubmitButtonState = .normal {
        willSet {
            switch newValue {
            case .normal:
                self.performSubmitAppearAnimation();
                self.performBackgroundColorAnimation( normalBackgrounColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            case .loading:
                self.performBackgroundColorAnimation(loadingBackgrounColor, completion: nil);
                self.performLoadingAnimation();
            case .success:
                self.performAppearAnimation(self.successImageView, completion: nil);
                self.performBackgroundColorAnimation(successBackgroundColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            case .warning:
                self.performAppearAnimation(self.warningImageView, completion: { (result: Bool) in
                    if result {
                        self.performShakeAnimation(self.backgroundView, completion: nil);
                        self.performShakeAnimation(self.warningImageView, completion: nil);
                    }
                });
                self.performBackgroundColorAnimation(warningBackgroundColor, completion: nil);
                self.loadingShapeLayer.removeAllAnimations();
            }
        }
        didSet {
            switch oldValue {
            case .normal:
                let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC)))
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.performSubmitHiddenAnimation();
                }
            case .loading:
                self.loadingShapeLayer.isHidden = true;
            case .success:
                self.performHiddenAnimation(self.successImageView, completion: nil);
            case .warning:
                self.performHiddenAnimation(self.warningImageView, completion: nil);
            }
        }
    }
    
    // Loading circle radius
    private var kLoadingRadius: CGFloat         = 12
    
    // Private UI Element
    private var backgroundView: UIView!
    private var tapAnimationView: UIView!
    private var loadingShapeLayer: CAShapeLayer!
    private var tapMaskLayer: CAShapeLayer!
    private var submitImageView: UIImageView!
    private var successImageView: UIImageView!
    private var warningImageView: UIImageView!
    
    // Gesture
    private var tapGesture: UITapGestureRecognizer!
    
    // Target & Selector
    private var target: AnyObject?
    private var selector: Selector?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        // Self Setting
        self.layer.shadowColor = shadowColor.cgColor;
        self.layer.shadowOffset = CGSize(0.0, 2.0);
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0;
        
        
        // Basic UI Element
        submitImageView = UIImageView()
        submitImageView.tintColor = submitIconColor
        successImageView = UIImageView()
        successImageView.tintColor = successIconColor
        warningImageView = UIImageView()
        warningImageView.tintColor = warningIconColor
        successImageView.alpha = 0
        warningImageView.alpha = 0
        
        backgroundView = UIView()
        backgroundView.frame = CGRect(0, 0, self.frame.width, self.frame.height);
        backgroundView.backgroundColor = UIColor.white;
        backgroundView.layer.cornerRadius = self.frame.height / 2;
        
        tapAnimationView = UIView()
        tapAnimationView.frame = CGRect(0, 0, self.frame.width, self.frame.height);
        tapAnimationView.backgroundColor = loadingBackgrounColor;
        tapAnimationView.isUserInteractionEnabled = false;
        tapAnimationView.isHidden = true;
        tapAnimationView.layer.cornerRadius = self.frame.height / 2;
        
        self.addSubview(backgroundView);
        self.addSubview(tapAnimationView);
        self.addSubview(submitImageView);
        self.addSubview(successImageView);
        self.addSubview(warningImageView);
        
        loadingShapeLayer = CAShapeLayer();
        loadingShapeLayer.strokeColor = loadingIconColor.cgColor;
        loadingShapeLayer.lineWidth   = 3.0;
        loadingShapeLayer.fillColor   = UIColor.clear.cgColor;
        loadingShapeLayer.lineCap     = kCALineCapRound;
        loadingShapeLayer.strokeEnd   = 0.8;
        loadingShapeLayer.isHidden      = true;
        self.layer.addSublayer(loadingShapeLayer);
        
        // Autolayout
        setConstraintWithBackgroundView(submitImageView);
        setConstraintWithBackgroundView(successImageView);
        setConstraintWithBackgroundView(warningImageView);
        
        // Original transform
        self.successImageView.transform = CGAffineTransform.identity
        self.successImageView.transform = self.successImageView.transform.rotated(by: -.pi/8)
        self.warningImageView.transform = CGAffineTransform.identity;
        self.warningImageView.transform = self.warningImageView.transform.rotated(by: -.pi/8)
        
        // Gesture
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(SubmitButton.handleSelfOnTapped(_:)));
        self.backgroundView.addGestureRecognizer(tapGesture);
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        self.loadingShapeLayer.path =
            UIBezierPath(ovalIn: CGRect(self.frame.width/2 - kLoadingRadius,
                self.frame.height/2 - kLoadingRadius, 2 * kLoadingRadius, 2 * kLoadingRadius)).cgPath;
        self.loadingShapeLayer.frame = self.bounds;
    }
    
    private func setConstraintWithBackgroundView(_ constrainedImage: UIView) {
        constrainedImage.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(constrainedImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor))
        self.addConstraint(constrainedImage.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor))
    }
    
    // API
    
    public func addTarget(target: AnyObject?, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    // MARK: - Event
    
    @objc func handleSelfOnTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if self.buttonState == .normal {
            self.buttonState = .loading;
            self.performTapAnimation(gestureRecognizer.location(in: self));
            let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC)))
            DispatchQueue.main.asyncAfter(
            deadline: delayTime) {
                self.backgroundView.backgroundColor = self.loadingBackgrounColor;
            }
            if (self.target?.responds(to: self.selector!) != nil) {
                _ = self.target?.perform(self.selector!, with: self)
            }
        }
    }
    
    // MARK: - Animation
    
    private func performLoadingAnimation() {
        let delayTime =  DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.loadingShapeLayer.isHidden = false;
            let spinAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation");
            spinAnimation.fromValue             = 0;
            spinAnimation.toValue               = Float.pi * 2;
            spinAnimation.duration              = 0.8;
            spinAnimation.repeatCount           = Float.infinity;
            self.loadingShapeLayer.add(spinAnimation, forKey: nil);
        }
    }
    
    private func performTapAnimation(_ point: CGPoint) {
        
        // Remove Old Mask Layer
        if self.tapMaskLayer != nil {
            self.tapMaskLayer.removeFromSuperlayer();
            self.tapMaskLayer = nil;
        }
        
        // Set Up Mask Layer
        self.tapAnimationView.isHidden = false;
        self.tapMaskLayer = CAShapeLayer();
        self.tapMaskLayer.opacity = 1.0;
        self.tapMaskLayer.fillColor   = UIColor.green.cgColor;
        self.tapMaskLayer.path = UIBezierPath(ovalIn: CGRect(point.x - 150, point.y - 150, 300, 300)).cgPath;
        self.tapMaskLayer.frame = self.bounds;
        layer.addSublayer(tapMaskLayer);
        tapAnimationView.layer.mask = tapMaskLayer;
        
        // Animation
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale");
        scaleAnimation.fromValue = 0;
        scaleAnimation.toValue = 1.0;
        scaleAnimation.duration = 0.2;
        scaleAnimation.delegate = self
        scaleAnimation.isRemovedOnCompletion = false;
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear);
        self.tapMaskLayer.add(scaleAnimation, forKey: "tapAnimation");
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == self.tapMaskLayer.animation(forKey: "tapAnimation") {
            self.tapMaskLayer.opacity = 0.0;
        }
    }
    
    private func performHiddenAnimation(_ hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3,
                                   animations: {
                                    hiddenImage.alpha = 0.0;
                                    hiddenImage.transform = CGAffineTransform(rotationAngle: .pi/2);
        }) { (result: Bool) in
            hiddenImage.transform = CGAffineTransform(rotationAngle: -.pi/2)
            completion?(true);
        }
    }
    
    private func performAppearAnimation(_ hiddenImage: UIImageView, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.5,
                                   animations: {
                                    hiddenImage.alpha = 1.0;
                                    hiddenImage.transform = CGAffineTransform(rotationAngle: 0);
        }) { (result: Bool) in
            completion?(true);
        }
    }
    
    private func performShakeAnimation(_ hiddenImage: UIView, completion: ((Bool) -> Void)?) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-6, 6, -6, 6, -4, 4, -3, 3, 0]
        hiddenImage.layer.add(translation, forKey: "shakeIt");
    }
    
    private func performSubmitHiddenAnimation() {
        UIView.animate(withDuration: 0.4,
                                   animations: {
                                    self.submitImageView.alpha = 0.0;
                                    self.submitImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
                                    self.backgroundView.frame =
                                        CGRect((self.frame.width - self.frame.height)/2, 0, self.frame.height, self.frame.height);
                                    
        }) { (result: Bool) in
            self.submitImageView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        }
    }

    private func performSubmitAppearAnimation() {
        UIView.animate(withDuration: 0.3,
                                   animations: {
                                    self.submitImageView.alpha = 1.0;
                                    self.submitImageView.transform = CGAffineTransform(rotationAngle: 0);
                                    self.backgroundView.frame = CGRect(0, 0, self.frame.width, self.frame.height);
        });
    }
    
    private func performBackgroundColorAnimation(_ backgroundColor: UIColor, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.4,
                                   animations: {
                                    self.backgroundView.backgroundColor = backgroundColor;
        });
    }
    
}
