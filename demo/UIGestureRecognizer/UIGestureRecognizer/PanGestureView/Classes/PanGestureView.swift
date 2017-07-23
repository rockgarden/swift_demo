//
//  PanGestureView.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

public enum PanGestureViewSwipeDirection {
    case none
    case down
    case left
    case up
    case right
}

let horizontalSwipeDirections = [PanGestureViewSwipeDirection.left, PanGestureViewSwipeDirection.right]

open class PanGestureView: UIView {

    open var contentView: UIView!
    fileprivate var actions: [PanGestureViewSwipeDirection:PanGestureAction] = [:]
    fileprivate var actionViews: [PanGestureViewSwipeDirection:PanGestureActionView] = [:]
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    fileprivate var swipeDirection: PanGestureViewSwipeDirection!
    fileprivate var displayLink: CADisplayLink?
    fileprivate var currentTranslationInView: CGPoint?
    
    public override init(frame:CGRect){
        super.init(frame:frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    fileprivate func setupView(){
        addContentView()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PanGestureView.handlePan(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    fileprivate func addContentView(){
        contentView = UIView(frame: self.bounds)
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }

    open func addAction(_ action:PanGestureAction){
        let direction = action.swipeDirection

        actions[direction!] = action
        
        if let existingActionView = actionViews[direction!]{
            existingActionView.removeFromSuperview()
        }
        
        let view = PanGestureActionView(frame: CGRect(x: 0,y: 0,width: 0,height: 0),action:action)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        addConstraintsToActionView(view, direction: direction!)
        
        actionViews[direction!] = view
    }
    
    func addConstraintsToActionView(_ actionView:PanGestureActionView, direction:PanGestureViewSwipeDirection) {
        
        let views = ["view":actionView,"contentView":contentView] as [String : Any]
        
        let orientation1 = (horizontalSwipeDirections.contains(direction)) ? "H" : "V"
        let orientation2 = (orientation1 == "H") ? "V" : "H"

        var constraint1:String!
        if direction == .left || direction == .up {
            constraint1 = "\(orientation1):[contentView]-(<=0@250,0@750)-[view(>=0)]-0-|"
        }
        else {
            constraint1 = "\(orientation1):|-0-[view(>=0)]-(<=0@250,0@750)-[contentView]"
        }
        let constraints1 = NSLayoutConstraint.constraints(withVisualFormat: constraint1, options: [], metrics: [:], views: views  )
        
        let constraint2 = "\(orientation2):|-0-[view]-0-|"
        let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: constraint2, options: [], metrics: [:], views: views)
        
        self.addConstraints(constraints1)
        self.addConstraints(constraints2)
    }
}

extension PanGestureView : UIGestureRecognizerDelegate {
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(PanGestureView.handleDisplayLink(_:)))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    func handleDisplayLink(_ link:CADisplayLink) {
        guard let translation = currentTranslationInView else {return}
        invertSwipeDirectionIfRequired(translation)
        updatePosition(translation)
    }
    
    func handlePan(_ gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: gesture.view)
        currentTranslationInView = translation
        let velocity = gesture.velocity(in: gesture.view)
        
        switch gesture.state {
            case .began:
                swipeDirection = swipeDirectionForTranslation(translation,velocity: velocity)
                startDisplayLink()
            case .changed:
                break
            case .cancelled:
                self.stopDisplayLink()
                print("cancelled")
            case .failed:
                self.stopDisplayLink()
            case .ended:
                self.stopDisplayLink()
                if let actionView = self.actionViews[self.swipeDirection], let action = self.actions[self.swipeDirection], actionView.shouldTrigger  {

                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [UIViewAnimationOptions.curveEaseOut, UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
                        
                        self.resetView()
                        
                        }, completion: { (finished) -> Void in
                            
                            if finished {
                                action.didTriggerBlock?(self.swipeDirection)
                                
                            }
                    })
                }
                else {
                    UIView.animate(withDuration: 0.3, delay: 0, options: [UIViewAnimationOptions.curveEaseOut, UIViewAnimationOptions.allowUserInteraction], animations: { 
                        
                        self.resetView()
                        
                        }, completion: { (finished) in

                    })
                }
            
            default:
                break
        }
    }
    
    fileprivate func swipeDirectionWasInverted(_ originalDirection:PanGestureViewSwipeDirection, translation:CGPoint) -> Bool {
        
        var wasInverted = false
        
        switch originalDirection {
        case .left:
            wasInverted = translation.x > 0
        case .right:
            wasInverted = translation.x < 0
        case .up:
            wasInverted = translation.y > 0
        case .down:
            wasInverted = translation.y < 0
        default:
            break
        }
        
        return wasInverted
    }
    
    fileprivate func inverseForSwipeDirection(_ direction:PanGestureViewSwipeDirection) -> PanGestureViewSwipeDirection{
        
        var inverseDirection:PanGestureViewSwipeDirection!
        
        switch direction {
        case .left:
            inverseDirection = .right
        case .right:
            inverseDirection = .left
        case .up:
            inverseDirection = .down
        case .down:
            inverseDirection = .up
        default:
            break
        }

        return inverseDirection
    }
    
    fileprivate func invertSwipeDirectionIfRequired(_ translation:CGPoint) {
        if swipeDirectionWasInverted(self.swipeDirection, translation: translation){
            self.swipeDirection = inverseForSwipeDirection(self.swipeDirection)
        }
    }
    
    fileprivate func resetView(){
        self.contentView.center = self.center
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    fileprivate func updatePosition(_ translation:CGPoint){
        
        if horizontalSwipeDirections.contains(swipeDirection){
            let elasticTranslation = elasticPoint(Float(translation.x), li: 44, lf: 100)
            contentView.center.x = contentView.frame.size.width/2 + CGFloat(elasticTranslation)
        }
        else {
            let elasticTranslation = elasticPoint(Float(translation.y), li: 44, lf: 100)
            contentView.center.y = contentView.frame.size.height/2 + CGFloat(elasticTranslation)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        if let actionView = actionViews[swipeDirection] {
            if actionView.isActive {
                actionView.shouldTrigger = true
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    
                    actionView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    
                    }, completion: { (finished) -> Void in
                        
                })
            }
            else {
                actionView.shouldTrigger = false
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    
                    actionView.transform = CGAffineTransform.identity
                    
                    }, completion: { (finished) -> Void in
                        
                })
            }
        }
        
    }
    
    fileprivate func swipeDirectionForTranslation(_ translation:CGPoint, velocity: CGPoint) -> PanGestureViewSwipeDirection{

        if velocity.x == 0 && velocity.y == 0 {
            return .none
        }
        
        var isHorizontal: Bool = false
        if abs(velocity.x) > abs(velocity.y) {
            
            isHorizontal = true
            
        }
        if isHorizontal {
            if translation.x > 0 {
                return .right
            }
            return .left
        }
        
        if translation.y > 0 {
            return .down
        }
        
        return .up
    }
    
    func elasticPoint(_ x: Float, li: Float, lf: Float) -> Float {
        let π = Float(Float.pi)

        if (fabs(x) >= fabs(li)) {
            return atanf(tanf((π*li)/(2*lf))*(x/li))*(2*lf/π)
        } else {
            return x
        }
    }
    
    
}

let kMinimumTranslation: CGFloat = 15
class PanGestureActionView: UIView {
    var imageView: UIImageView!
    var action: PanGestureAction!
    var isActive:Bool = false
    var shouldTrigger:Bool = false
    
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    convenience init(frame: CGRect, action:PanGestureAction ) {
        self.init(frame:frame)
        self.action = action
        setupView()

    }
    
    fileprivate func setupView(){
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = action.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.tintColor = action.tintColor ?? UIColor.white
        addSubview(imageView)
        
        self.backgroundColor = action.backgroundColor ?? UIColor.white
        setupConstraints()
        
    }
    
    fileprivate func setupConstraints(){
        let views = ["imageView":imageView] as [String : Any]
        
        let orientation1 = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? "H" : "V"
        let orientation2 = (orientation1 == "H") ? "V" : "H"
        
        
        let hConstraintString = "\(orientation1):|-(0@250)-[imageView(<=44)]-(0@250)-|"
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: hConstraintString, options: [], metrics: [:], views: views)
        self.addConstraints(hConstraints)
        
        let vConstraintString = "\(orientation2):[imageView(44)]"
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: vConstraintString, options: [], metrics: [:], views: views)
        self.addConstraints(vConstraints)
        
        let hCenterConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        hCenterConstraint.priority = 1000
        self.addConstraint(hCenterConstraint)
        
        let vCenterConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        self.addConstraint(vCenterConstraint)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.frame.size.width : self.frame.size.height
        let imageViewLength = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.imageView.frame.size.width : self.imageView.frame.size.height
        
        if length > imageViewLength {
            let origin = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.bounds.origin.x : self.bounds.origin.y
            let imageViewOrigin = (horizontalSwipeDirections.contains(self.action.swipeDirection)) ? self.imageView.frame.origin.x : self.imageView.frame.origin.y
            imageView.alpha = (origin + imageViewOrigin)/kMinimumTranslation
        }
        else {
            imageView.alpha = 0
        }

        isActive = (imageView.alpha >= 1)
    }
}
