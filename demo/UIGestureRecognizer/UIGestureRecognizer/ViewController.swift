//
//  ViewController.swift
//  UIGestureRecognizer
//
//  Created by wangkan on 16/8/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//
//  可直接从InterfaceBuilder通过 @IBAction 添加 GestureRecognizer

import UIKit

class ViewController: UIViewController {

	var netRotation: CGFloat = 0
	var lastScaleFactor: CGFloat = 1
	let which = 1

    @IBOutlet var longPresser : UILongPressGestureRecognizer!
    @IBOutlet weak var horizontalStackView: UIStackView!

	@IBOutlet weak var image: UIImageView!

    var pan: UIPanGestureRecognizer!

	override func viewDidLoad() {
		super.viewDidLoad()
		image.image = UIImage(named: "image1.png")

		// ROTATION
		let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateGesture(_:)))
		image.addGestureRecognizer(rotateGesture)

		// LONG PRESS
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(_:)))
		longPressGesture.minimumPressDuration = 2.0;
		image.addGestureRecognizer(longPressGesture)

		// PINCH
		let pinchGesture: UIPinchGestureRecognizer =
			UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
		image.addGestureRecognizer(pinchGesture)
		super.viewDidLoad()

		// Double Tap
		let tapGesture = UITapGestureRecognizer(target: self, action:
				#selector(handleTap(_:))) // 本地方法不用指明所有者
		tapGesture.numberOfTapsRequired = 2;
		image.addGestureRecognizer(tapGesture)

		// view that can be single-tapped, double-tapped, or dragged

		let t2 = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
		t2.numberOfTapsRequired = 2
		image.addGestureRecognizer(t2)

		let t1 = UITapGestureRecognizer(target: self, action: #selector(singleTap))
		t1.requireGestureRecognizerToFail(t2) // t2 fail response t1
		image.addGestureRecognizer(t1)

		switch which {
		case 1:
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
		swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right
		image.addGestureRecognizer(swipeGestureRight)

		let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
		swipeGestureDown.direction = UISwipeGestureRecognizerDirection.Down
		image.addGestureRecognizer(swipeGestureDown)

		let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
		swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left
		image.addGestureRecognizer(swipeGestureLeft)

		let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
		swipeGestureUp.direction = UISwipeGestureRecognizerDirection.Up
		image.addGestureRecognizer(swipeGestureUp)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// ROTATION
	@IBAction func rotateGesture(sender: UIRotationGestureRecognizer) {
		let rotation: CGFloat = sender.rotation
		let transform: CGAffineTransform =
			CGAffineTransformMakeRotation(rotation + netRotation)
		sender.view?.transform = transform
		if (sender.state == UIGestureRecognizerState.Ended) {
			netRotation += rotation;
		}
	}

	// SWIPE
	@IBAction func respondToSwipeGesture(send: UIGestureRecognizer) {
		if let swipeGesture = send as? UISwipeGestureRecognizer {
			switch swipeGesture.direction {
			case UISwipeGestureRecognizerDirection.Right:
				changeImage()
				print("Swiped right")
			case UISwipeGestureRecognizerDirection.Down:
				changeImage()
				print("Swiped down")
			case UISwipeGestureRecognizerDirection.Left:
				changeImage()
				print("Swiped left")
			case UISwipeGestureRecognizerDirection.Up:
				changeImage()
				print("Swiped up")
			default:
				break
			}
		}
	}

	// LONG PRESS
	@IBAction func action(gestureRecognizer: UIGestureRecognizer) {
		if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
			let alertController = UIAlertController(title: "Alert", message: "Long Press gesture", preferredStyle: .Alert)
			let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
			alertController.addAction(OKAction)
			self.presentViewController(alertController, animated: true) { }
		}
	}

	func longPress(lp: UILongPressGestureRecognizer) {
		switch lp.state {
		case .Began:
			let anim = CABasicAnimation(keyPath: "transform")
			anim.toValue = NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1))
			anim.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
			anim.repeatCount = Float.infinity
			anim.autoreverses = true
			lp.view!.layer.addAnimation(anim, forKey: nil)
		case .Ended, .Cancelled:
			lp.view!.layer.removeAllAnimations()
		default: break
		}
	}

	@IBAction func pinchGesture(sender: UIPinchGestureRecognizer) {
		let factor = sender.scale
		if (factor > 1) {
			// increase zoom
			sender.view?.transform = CGAffineTransformMakeScale(
				lastScaleFactor + (factor - 1),
				lastScaleFactor + (factor - 1));
		} else {
			// decrease zoom
			sender.view?.transform = CGAffineTransformMakeScale(
				lastScaleFactor * factor,
				lastScaleFactor * factor);
		}
		if (sender.state == UIGestureRecognizerState.Ended) {
			if (factor > 1) {
				lastScaleFactor += (factor - 1);
			} else {
				lastScaleFactor *= factor;
		} }
	}

	@IBAction func handleTap(sender: UIGestureRecognizer) {
		if (sender.view?.contentMode == UIViewContentMode.ScaleAspectFit) {
			sender.view?.contentMode = UIViewContentMode.Center
		}
		else {
			sender.view?.contentMode = UIViewContentMode.ScaleAspectFit
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

	func dragging(p: UIPanGestureRecognizer) {
		let v = p.view!
		switch p.state {
		case .Began, .Changed:
			let delta = p.translationInView(v.superview)
			var c = v.center
			c.x += delta.x; c.y += delta.y
			v.center = c
			p.setTranslation(CGPointZero, inView: v.superview)
		default: break
		}
	}

}

extension ViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
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
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWithGestureRecognizer
        otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("sim")
        return true
    }

    /**
     返回值为第一个手势能否阻止或被阻止第二个手势的触发

     - parameter gestureRecognizer:      gestureRecognizer description
     - parameter otherGestureRecognizer: <#otherGestureRecognizer description#>

     - returns: <#return value description#>
     */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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

     - returns: <#return value description#>
     */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("=== should be\n\(gestureRecognizer)\n\(otherGestureRecognizer)")
        if (gestureRecognizer == pan) {
            return false //触发
        }
        return false
    }
    
}


