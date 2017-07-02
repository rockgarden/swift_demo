//
//  CancelAnimation.swift
//  animate
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class CancelAnimationVC: UIViewController {
	@IBOutlet var v: UIView!
    var pOrig : CGPoint!
    var pFinal : CGPoint!

	func animate() {
        self.pOrig = self.v.center//替换val
        self.pFinal = self.v.center
        self.pFinal.x += 100

		let val = NSValue(cgPoint: self.v.center)
		self.v.layer.setValue(val, forKey: "pOrig")

		let opts: UIViewAnimationOptions = [.autoreverse, .repeat]
		UIView.animate(withDuration: 1, delay: 0, options: opts,
			animations: {
				self.v.center.x += 100
        }, completion: {
            _ in
            print("finished initial animation")
        })
	}

    func animateKV() {
        let val = NSValue(cgPoint: self.v.center)
        self.v.layer.setValue(val, forKey: "pOrig")
        let opts: UIViewAnimationOptions = [.autoreverse, .repeat]
        UIView.animate(withDuration: 1, delay: 0, options: opts,
                       animations: {
                        self.v.center.x += 100
        }, completion: {
            _ in
            print("finished initial animation")
        })
    }

    var which = 1
	func cancel() {
        switch which {
        case 1:
            // simplest possible solution: just kill it dead
            self.v.layer.removeAllAnimations()
        case 2:
            /// 在这里注释前两行，看看什么是“添加剂”的意思 comment out the first two lines here to see what "additive" means
            /// 新动画不会删除原始动画 the new animation does not remove the original animation..., so the new animation just completes and the original proceeds as before. to prevent that, we have to intervene directly 直接干预
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
            UIView.animate(withDuration:0.1) {
                self.v.center = self.pFinal
            }
        case 3:
            // same thing except this time we decide to return to the original position
            // we will get there, but it will take us the rest of the original 4 seconds...
            // unless we intervene directly
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
            UIView.animate(withDuration:0.1) {
                self.v.center = self.pOrig
                // need to have recorded original position
            }
        case 4:
            /// cancel just means stop where you are
            self.v.layer.position = self.v.layer.presentation()!.position
            self.v.layer.removeAllAnimations()
        default: break
        }
        which = which<4 ? which+1 : 1
	}

    func cancelKV() {
        /// 因为在现有动画重复时不是添加动画的...because animation is not additive when existing animation is repeating
        UIView.animate(withDuration:0.1, delay:0,
                       options:.beginFromCurrentState,
                       animations: {
                        if let val = self.v.layer.value(forKey:"pOrig") as? CGPoint {
                            self.v.center = val
                        }
                        // as? NSValue 就要获取 val.cgPointValue
        })
    }

	@IBAction func doStart(_ sender: Any?) {
		self.animate()
	}

	@IBAction func doStop(_ sender: Any?) {
		self.cancel()
        (sender as? UIButton)?.setTitle("stop \(which)", for: .normal)
	}

    @IBAction func doStartKV(_ sender: Any?) {
        self.animateKV()
    }

    @IBAction func doStopKV(_ sender: Any?) {
        self.cancelKV()
    }
}

