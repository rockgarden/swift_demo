

import UIKit


class LayerAnimationVC : UIViewController {
    @IBOutlet var compassView : CompassView!
    
    var which = 1

    @IBAction func doButton(_ sender: Any?) {
        let c = self.compassView.layer as! BaseCompassLayer
        let arrow = c.arrow!
        
        switch which {
        case 1:
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            
        case 2:
            CATransaction.setAnimationDuration(0.8)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            
        case 3:
            let clunk = CAMediaTimingFunction(controlPoints: 0.9, 0.1, 0.7, 0.9)
            CATransaction.setAnimationTimingFunction(clunk)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)

        case 4:
            // proving that the completion block works
            CATransaction.setCompletionBlock({
                print("done")
                })
            
            // capture the start and end values
            let startValue = arrow.transform
            let endValue = CATransform3DRotate(startValue, .pi/4.0, 0, 0, 1)
            // change the layer, without implicit animation
            CATransaction.setDisableActions(true)
            arrow.transform = endValue
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 5:
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, .pi/4.0, 0, 0, 1)
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            arrow.add(anim, forKey:nil)
            
        case 6:
            // capture the start and end values
            let nowValue = arrow.transform
            let startValue = CATransform3DRotate(nowValue, .pi/40.0, 0, 0, 1)
            let endValue = CATransform3DRotate(nowValue, -.pi/40.0, 0, 0, 1)
            // construct the explicit animation
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction = CAMediaTimingFunction(
                name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.fromValue = startValue
            anim.toValue = endValue
            // ask for the explicit animation
            arrow.add(anim, forKey:nil)
            
        case 7:
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.05
            anim.timingFunction =
                CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
            anim.repeatCount = 3
            anim.autoreverses = true
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)
            anim.fromValue = Float.pi/40
            anim.toValue = -Float.pi/40
            arrow.add(anim, forKey:nil)
            
        case 8:
            let rot = CGFloat.pi/4.0
            CATransaction.setDisableActions(true)
            arrow.transform = CATransform3DRotate(arrow.transform, rot, 0, 0, 1)
            // construct animation additively
            let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim.timingFunction = clunk
            anim.fromValue = -rot
            anim.toValue = 0
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)
            arrow.add(anim, forKey:nil)

        case 9:
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            print(values)
            let anim = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim.values = values
            anim.isAdditive = true
            anim.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
            arrow.add(anim, forKey:nil)

        case 10:
            // put them all together, they spell Mother...
            
            // capture current value, set final value
            let rot = .pi/4.0
            CATransaction.setDisableActions(true)
            let current = arrow.value(forKeyPath:"transform.rotation.z") as! Double
            arrow.setValue(current + rot, forKeyPath:"transform.rotation.z")

            // first animation (rotate and clunk)
            let anim1 = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
            anim1.duration = 0.8
            let clunk = CAMediaTimingFunction(controlPoints:0.9, 0.1, 0.7, 0.9)
            anim1.timingFunction = clunk
            anim1.fromValue = current
            anim1.toValue = current + rot
            anim1.valueFunction = CAValueFunction(name:kCAValueFunctionRotateZ)

            // second animation (waggle)
            var values = [0.0]
            let directions = sequence(first:1) {$0 * -1}
            let bases = stride(from: 20, to: 60, by: 5)
            for (base, dir) in zip(bases, directions) {
                values.append(Double(dir) * .pi / Double(base))
            }
            values.append(0.0)
            let anim2 = CAKeyframeAnimation(keyPath:#keyPath(CALayer.transform))
            anim2.values = values
            anim2.duration = 0.25
            anim2.isAdditive = true
            anim2.beginTime = anim1.duration - 0.1
            anim2.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)

            // group
            let group = CAAnimationGroup()
            group.animations = [anim1, anim2]
            group.duration = anim1.duration + anim2.duration
            arrow.add(group, forKey:nil)

            
        default: break
        }
        which = which<10 ? which+1 : 1
    }
    
}
