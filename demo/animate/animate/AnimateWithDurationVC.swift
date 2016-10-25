

import UIKit

func imageOfSize(_ size: CGSize, _ whatToDraw: () -> ()) -> UIImage {
	UIGraphicsBeginImageContextWithOptions(size, false, 0)
	whatToDraw()
	let result = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return result!
}

class AnimateWithDurationVC: UIViewController {

	@IBOutlet weak var myButton2: UIButton!
	@IBOutlet weak var horizontalStackView: UIStackView!
	@IBOutlet weak var log: UILongPressGestureRecognizer!
	@IBOutlet weak var myButton: UIButton!
	@IBOutlet weak var v: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		let image = imageOfSize(CGSize(width: 45, height: 20), {
			let p = UIBezierPath(
				roundedRect: CGRect(x: 0, y: 0, width: 45, height: 20), cornerRadius: 8)
			p.stroke()
		})
		myButton.setBackgroundImage(image, for: UIControlState())

        loadAnimate(9)
	}

	func loadAnimate(_ which: Int) {
		delay(1) {
			print(0)
			print(self.v.center.y)
			switch which {
			case 1:
				UIView.animate(withDuration: 0.4, animations: {
					self.v.backgroundColor = UIColor.red
				})
			case 2:
				UIView.animate(withDuration: 0.4, animations: {
					self.v.backgroundColor = UIColor.red
					self.v.center.y += 100
				})
			case 3:
				let v2 = UIView()
				v2.backgroundColor = UIColor.black
				v2.alpha = 0
				v2.frame = self.v.frame
				self.v.superview!.addSubview(v2)
				UIView.animate(withDuration: 0.4, animations: {
					self.v.alpha = 0
					v2.alpha = 1
					}, completion: {
					_ in
					self.v.removeFromSuperview()
				})
			case 4:
				UIView.perform(.delete, on: [self.v], options: [], animations: nil, completion: { _ in print(self.v.superview) })
			case 5:
				UIView.animate(withDuration: 1, animations: {
					self.v.backgroundColor = UIColor.red
					UIView.performWithoutAnimation {
						self.v.center.y += 100
					}
				})
			case 6:
				func report(_ ix: Int) {
					let pres = (self.v.layer.presentation() as! CALayer).position.y
					let model = self.v.center.y
					print("step \(ix): presentation \(pres), model \(model)")
				}
				UIView.animate(withDuration: 2, animations: {
					report(2)
					self.v.center.y += 100
					report(3)
					}, completion: {
					_ in
					report(4)
				})
				self.v.center.y += 300
				report(1)
			case 7:
				UIView.animate(withDuration: 2, animations: {
					self.v.center.y += 100
					self.v.center.y += 300
					}, completion: { _ in print(self.v.center.y) })
			case 8:
				let opts = UIViewAnimationOptions.autoreverse
				let xorig = self.v.center.x
				UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
					self.v.center.x += 100
					}, completion: {
					_ in
					self.v.center.x = xorig
				})
			case 9:
				self.animate(3)
			case 10:
				let opts = UIViewAnimationOptions.autoreverse
				let xorig = self.v.center.x
				UIView.animateWithTimes(3, duration: 1, delay: 0, options: opts, animations: {
					self.v.center.x += 100
					}, completion: {
					_ in
					self.v.center.x = xorig
				})
			case 11:
				UIView.animate(withDuration: 1, animations: {
					self.v.center.x += 100
				})
				// let opts = UIViewAnimationOptions.BeginFromCurrentState
				UIView.animate(withDuration: 1, animations: {
					self.v.center.y += 100
				})
			case 12:
				UIView.animate(withDuration: 2, animations: {
					self.v.center.x += 100
				})
				delay(1) {
					// let opts = UIViewAnimationOptions.BeginFromCurrentState
					UIView.animate(withDuration: 1, delay: 0, options: [],
						animations: {
							self.v.center.y += 100
						}, completion: nil)
				}
				default: break
			}
		}
	}

	let whichAnimateWay = 1 // 1 or 2

	func animate(_ count: Int) {
		switch whichAnimateWay {
		case 1:
			let opts = UIViewAnimationOptions.autoreverse
			let xorig = self.v.center.x
			UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
				UIView.setAnimationRepeatCount(Float(count)) // I really don't like this
				self.v.center.x += 100
				}, completion: {
				_ in
				self.v.center.x = xorig
			})
		case 2:
			let opts = UIViewAnimationOptions.autoreverse
			let xorig = self.v.center.x
			UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
				self.v.center.x += 100
				}, completion: {
				_ in
				self.v.center.x = xorig
				if count > 1 {
					delay(0) {
						self.animate(count - 1)
					}
				}
			})
		default: break
		}
	}

	@IBAction func doButton(_ sender: AnyObject) {
		UIView.animate(withDuration: 0.4, animations: {
			() -> () in
			self.myButton.frame.origin.y += 20
			}, completion: {
			(finished: Bool) -> () in
			print("finished: \(finished)")
		})
	}

	@IBAction func doButton2(_ sender: AnyObject) {
		// showing some serious compression of the above syntax
		UIView.animate(withDuration: 0.4, animations: {
			self.myButton2.frame.origin.y += 20
		}, completion: {
			print("finished: \($0)") // must have either "_ in" or "$0"
		}) 
	}

}

extension UIView {
	class func animateWithTimes(_ times: Int,
		duration dur: TimeInterval,
		delay del: TimeInterval,
		options opts: UIViewAnimationOptions,
		animations anim: @escaping () -> Void,
		completion comp: ((Bool) -> Void)?) {
			func helper(_ t: Int,
				_ dur: TimeInterval,
				_ del: TimeInterval,
				_ opt: UIViewAnimationOptions,
				_ anim: @escaping () -> Void,
				_ com: ((Bool) -> Void)?) {
					UIView.animate(withDuration: dur,
						delay: del, options: opt,
						animations: anim, completion: {
							done in
							if com != nil {
								com!(done)
							}
							if t > 0 {
								delay(0) {
									helper(t - 1, dur, del, opt, anim, com)
								}
							}
					})
			}
			helper(times - 1, dur, del, opts, anim, comp)
	}

}

