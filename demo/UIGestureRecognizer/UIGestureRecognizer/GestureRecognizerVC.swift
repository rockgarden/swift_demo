//
//  ViewController.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 16/8/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//
//  可直接从InterfaceBuilder通过 @IBAction 添加 GestureRecognizer

import UIKit

class GestureRecognizerVC: UIViewController {
    
    var netRotation: CGFloat = 0
    var lastScaleFactor: CGFloat = 1
    let which = 2
    
    @IBOutlet var longPresser: UILongPressGestureRecognizer!
    @IBOutlet weak var image: UIImageView!
    
    var pan: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: "image1")
        
        // ROTATION
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateGesture(_:)))
        image.addGestureRecognizer(rotateGesture)
        
        // LONG PRESS
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(_:)))
        longPressGesture.minimumPressDuration = 2.0;
        image.addGestureRecognizer(longPressGesture)
        
        /// PINCH: 寻找涉及两个触摸的捏合手势。当用户将两个手指朝向彼此移动时，传统意义是缩小;当用户将两个手指彼此远离时，常规的意义是放大。捏是一个持续的姿态。当两个触摸已经移动足够被认为是捏捏手势时，手势开始（开始）。当手指移动时（手指按住两个手指），手势会改变（改变）。手指从视图抬起时结束（结束）。
        let pinchGesture: UIPinchGestureRecognizer =
            UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        image.addGestureRecognizer(pinchGesture)
        
        // Double Tap
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(handleTap(_:))) // 本地方法不用指明所有者
        tapGesture.numberOfTapsRequired = 2;
        image.addGestureRecognizer(tapGesture)
        
        //FIXME: Check mark 和 Tap 冲突
        let checkGesture = CheckmarkGestureRecognizer(target: self, action:
            #selector(handleTap(_:)))
        view.addGestureRecognizer(checkGesture)
        
        // view that can be single-tapped, double-tapped, or dragged
        
        let t2 = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        t2.numberOfTapsRequired = 2
        image.addGestureRecognizer(t2)
        
        let t1 = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        t1.require(toFail: t2) // t2 fail response t1
        image.addGestureRecognizer(t1)
        
        switch which {
        case 1:
            /// Pan: 它寻找平移（拖动）手势。用户在平移时必须在视图上按一个或多个手指。实现此手势识别器的动作方法的客户端可以询问手势的当前翻译和速度。平移手势是连续的。当手指的最小数量（minimumNumberOfTouches）已经移动足够以被认为是平移时，它开始（开始）。当手指移动时，至少最小数量的手指被按下时，它会改变（改变）。当所有手指抬起时，它结束（结束）。该类的客户端可以在其操作方法中查询UIPanGestureRecognizer对象的当前手势翻译（翻译（in :)）和翻译速度（速度（in :)）。他们可以指定其坐标系应用于平移和速度值的视图。客户还可以将翻译重置为所需的值。
            pan = UIPanGestureRecognizer(target: self, action: #selector(dragging))
            image.addGestureRecognizer(pan)
        case 2:
            let p = HorizPanGestureRecognizer(target: self, action: #selector(dragging))
            image.addGestureRecognizer(p)
            let p2 = VertPanGestureRecognizer(target: self, action: #selector(dragging))
            image.addGestureRecognizer(p2)
            
        default: break
        }
        
        // SWIPE UIPanGestureRecognizer 优先级高于 UISwipeGestureRecognizer
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        image.addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeGestureDown.direction = UISwipeGestureRecognizerDirection.down
        image.addGestureRecognizer(swipeGestureDown)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        image.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeGestureUp.direction = UISwipeGestureRecognizerDirection.up
        image.addGestureRecognizer(swipeGestureUp)
    }
    
    // ROTATION
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        print("rotate")
        let rotation: CGFloat = sender.rotation
        let transform: CGAffineTransform =
            CGAffineTransform(rotationAngle: rotation + netRotation)
        sender.view?.transform = transform
        if (sender.state == UIGestureRecognizerState.ended) {
            netRotation += rotation;
        }
    }
    
    // SWIPE
    @IBAction func respondToSwipeGesture(_ send: UIGestureRecognizer) {
        if let swipeGesture = send as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                changeImage()
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                changeImage()
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                changeImage()
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                changeImage()
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    // LONG PRESS
    @IBAction func action(_ gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            let alertController = UIAlertController(title: "Alert", message: "Long Press gesture", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
        }
    }
    
    func longPress(_ lp: UILongPressGestureRecognizer) {
        switch lp.state {
        case .began:
            let anim = CABasicAnimation(keyPath: "transform")
            anim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1))
            anim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
            anim.repeatCount = Float.infinity
            anim.autoreverses = true
            lp.view!.layer.add(anim, forKey: nil)
        case .ended, .cancelled:
            lp.view!.layer.removeAllAnimations()
        default: break
        }
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        let factor = sender.scale
        switch sender.state {
        case .possible, .failed:
            return
        case .began:
            debugPrint("began",sender.scale)
            break
        case .changed:
            debugPrint("changed",sender.scale)
            if (factor > 1) {
                // increase zoom
                sender.view?.transform = CGAffineTransform(
                    scaleX: lastScaleFactor + (factor - 1),
                    y: lastScaleFactor + (factor - 1));
            } else {
                // decrease zoom
                sender.view?.transform = CGAffineTransform(
                    scaleX: lastScaleFactor * factor,
                    y: lastScaleFactor * factor);
            }
            break
        case .ended:
            debugPrint("ended",sender.scale)
            if (factor > 1) {
                lastScaleFactor += (factor - 1);
            } else {
                lastScaleFactor *= factor;
            }
            break
        default: break
        }
    }
    
    @IBAction func handleTap(_ sender: UIGestureRecognizer) {
        if (sender.view?.contentMode == UIViewContentMode.scaleAspectFit) {
            sender.view?.contentMode = UIViewContentMode.center
        }
        else {
            sender.view?.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
    func changeImage() {
        if (image.image == UIImage(named: "image1.png")) {
            image.image = UIImage(named: "image2.png") }
        else {
            image.image = UIImage(named: "image1.png")
        }
    }
    
    func singleTap () {
        print("single tap")
    }
    func doubleTap () {
        print("double tap")
    }
    
    /// Pan
    func dragging(_ p: UIPanGestureRecognizer) {
        let v = p.view!
        let sV = v.superview
        let loc = p.location(in: v)
        _ = v.hitTest(loc, with: nil)
        switch p.state {
        case .began, .changed:
            let delta = p.translation(in: sV)
            var c = v.center
            c.x += delta.x; c.y += delta.y
            v.center = c
            p.setTranslation(CGPoint.zero, in: sV)
        default: break
        }
    }
    
}

extension GestureRecognizerVC : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // g is the pan gesture recognizer
        //		switch gestureRecognizer.state {
        //		case .Possible, .Failed:
        //			return false
        //		default:
        //			return true
        //		}
        return true
    }
    
    // 允许同时识别两个手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("sim")
        return true
    }
    
    /**
     返回值为第一个手势能否阻止或被阻止第二个手势的触发
     
     - parameter gestureRecognizer:      gestureRecognizer description
     - parameter otherGestureRecognizer: otherGestureRecognizer description
     
     - returns: return value description
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("=== should\n\(gestureRecognizer)\n\(otherGestureRecognizer)")
        if (gestureRecognizer == pan) {
            return false
        }
        return false
    }
    
    /**
     返回值为第一个手势能否阻止或被阻止第二个手势的触发
     
     - parameter gestureRecognizer:      第一个手势
     - parameter otherGestureRecognizer: 第二个手势
     
     - returns: return value description
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("=== should be\n\(gestureRecognizer)\n\(otherGestureRecognizer)")
        if (gestureRecognizer == pan) {
            return false //触发
        }
        return false
    }
    
}


