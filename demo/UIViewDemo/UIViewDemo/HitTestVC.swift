
/*:
 响应者链条概念: iOS系统检测到手指触摸(Touch)操作时会将其打包成一个UIEvent对象，并放入当前活动Application的事件队列，单例的UIApplication会从事件队列中取出触摸事件并传递给单例的UIWindow来处理，UIWindow对象会使用hitTest:with:方法寻找此次Touch操作初始点所在的视图(View)，即需要将触摸事件传递给其处理的视图，这个过程称之为hit-test view。
 
 响应者对象（Responder Object）指的是有响应和处理事件能力的对象。响应者链就是由一系列的响应者对象 构成的一个层次结构。
 
 UIResponder是所有响应对象的基类，在UIResponder类中定义了处理上述各种事件的接口。我们熟悉的UIApplication、UIViewController、UIWindow 和所有继承自UIView的UIKit类都直接或间接的继承自UIResponder，所以它们的实例都是可以构成响应者链的响应者对象。
 
 UIWindow实例对象会首先在它的内容视图上调用hitTest:with:，此方法会在其视图层级结构中的每个视图上调用point(inside, with)（该方法用来判断点击事件发生的位置是否处于当前视图范围内，以确定用户是不是点击了当前视图），如果point(inside, with)返回YES，则继续逐级调用，直到找到touch操作发生的位置，这个视图也就是要找的hit-test view。
 
 hitTest:with:方法的处理流程如下:
 
 首先调用当前视图的pointInside:withEvent:方法判断触摸点是否在当前视图内；
 
 若返回NO,则hitTest:with:返回nil;
 
 若返回YES,则向当前视图的所有子视图(subviews)发送hitTest:with:消息，所有子视图的遍历顺序是从最顶层视图一直到到最底层视图，即从subviews数组的末尾向前遍历，直到有子视图返回非空对象或者全部子视图遍历完毕；
 
 若第一次有子视图返回非空对象，则hitTest:with:方法返回此对象，处理结束；
 
 如所有子视图都返回非，则hitTest:withEvent:方法返回自身(self)。
 
 1、如果最终hit-test没有找到第一响应者，或者第一响应者没有处理该事件，则该事件会沿着响应者链向上回溯，如果UIWindow实例和UIApplication实例都不能处理该事件，则该事件会被丢弃；
 
 2、hitTest:with:方法将会忽略隐藏(hidden=YES)的视图，禁止用户操作(userInteractionEnabled=YES)的视图，以及alpha级别小于0.01(alpha<0.01)的视图。如果一个子视图的区域超过父视图的bound区域(父视图的clipsToBounds 属性为NO，这样超过父视图bound区域的子视图内容也会显示)，那么正常情况下对子视图在父视图之外区域的触摸操作不会被识别,因为父视图的point:inside:with:方法会返回NO,这样就不会继续向下遍历子视图了。当然，也可以重写point:inside:with:方法来处理这种情况。
 
 3、我们可以重写 hitTest:with:来达到某些特定的目的，下面的链接就是一个有趣的应用举例，当然实际应用中很少用到这些。
 */
import UIKit

class HitTestVC : UIViewController {

    @IBAction func doButton(_ sender: Any?) {
        print("button tap!")
    }
    
    @IBAction func tapped(_ g: UITapGestureRecognizer) {
        let p = g.location(ofTouch:0, in: g.view)
        let v = g.view?.hitTest(p, with: nil)
        if let v = v as? UIImageView {
            UIView.animate(withDuration:0.2, delay: 0,
                options: .autoreverse,
                animations: {
                    v.transform = CGAffineTransform(scaleX:1.1, y:1.1)
                }, completion: {
                    _ in
                    v.transform = .identity
                })
        }
    }

}


class MyView_hT : UIView {
    
    // 如果超级视图没有剪辑到边界，你可以看到它的超级视图 view 之外的一个子视图 Button，尝试点按它, 无效，因为通常情况下，无法在其超级视图之外触及子视图的区域
    // 通过 覆盖 hitTest 使得 触及子视图 成为可能

    /*
     返回包含指定点的视图层次结构（包括自身）中的接收者的最远后代。
     该方法遍历视图层次结构，调用每个子视图的point（inside :) with :)方法来确定哪个子视图应该接收触摸事件。如果point（with :)返回true，则子视图的层次结构也会相似地遍历，直到找到包含指定点的最前面的视图。如果视图不包含该点，则其视图层次结构的分支将被忽略。您很少需要自己调用此方法，但您可以覆盖它以从子视图中隐藏触摸事件。
     此方法将忽略隐藏的视图对象，该对象已禁用用户交互，或者具有小于0.01的Alpha级别。当确定命中时，此方法不会考虑视图的内容。因此，即使指定的点在该视图的内容的透明部分中，仍然可以返回视图。
     位于接收者边界之外的点不会被报告为命中，即使它们实际上位于接收者的子视图之一内。如果当前视图的clipToBounds属性设置为false并且受影响的子视图超出视图的边界，则可能会发生这种情况。
     */
    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with:e) {
            return result
        }
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with:e) {
                return result
            }
        }
        return nil
    }
}
