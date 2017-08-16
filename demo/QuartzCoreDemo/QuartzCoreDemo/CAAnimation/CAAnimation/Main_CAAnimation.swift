/**
 CAAnimation动画执行过程都是在后台操作的,不会阻塞主线程. 有4个子类：CABasicAnimation、CAKeyframeAnimation、CATransition、CAAnimationGroup.
 
 开发步骤:
 初始化一个动画对象(CAAnimation)并设置一些动画相关属性.
 添加动画对象到层(CALayer)中,开始执行动画.
 CALayer中很多属性都可以通过CAAnimation实现动画效果, 包括opacity, position, transform, bounds, contents等，具体可以在API文档中查找
 通过调用CALayer的addAnimation:forKey:增加动画到层(CALayer)中,这样就能触发动画了.通过调用removeAnimationForKey:可以停止层中的动画.
 
 常用属性
 属性	作用
 Autoreverses	设定这个属性为 YES 时,在它到达目的地之后,动画的返回到开始的值,代替了直接跳转到开始的值，过渡平滑
 Duration	设定开始值到结束值花费的时间。期间会被速度的属性所影响
 RemovedOnCompletion	这个属性默认为 YES,在指定的时间段完成后,动画就自动的从层上移除了。
 FillMode	这个属性一般和 RemovedOnCompletion 配合使用，保持动画状态。其中kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态.此时将RemovedOnCompletion设为NO
 Speed	默认的值为 1.0.如果你改变这个值为 2.0,动画会用 2 倍的速度播放。这样的影响就是使持续时间减半。如果你指定的持续时间为 6 秒,速度为 2.0,动画就会播放 3 秒钟即一半的持续时间。
 RepeatCount	默认的是 0,动画只会播放一次。如果指定一个无限大的重复次数,使用 MAXFLOAT 。这个不应该和 repeatDration 属性一块使用
 RepeatDuration	这个属性指定了动画应该被重复多久。动画会一直重复,直到设定的时间用完。同上它不应该和 repeatCount 一起使用
 FromValue	设置动画的初始值
 ToValue	设置动画的到达值
 TimingFunction	控制动画运行的节奏. kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉 kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开 kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地 kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是默认的动画行为。
 BeginTime	可以用来设置动画延迟执行时间，若想延迟1s，就设置为CACurrentMediaTime()+1，CACurrentMediaTime()为图层的当前时间
 
 
 CATransition之简单的转场动画
 
 CAAnimation的子类，用于做转场动画，能够为层提供移出屏幕和移入屏幕的动画效果。
 
 属性	解读
 type	动画过渡类型
 subtype	动画过渡方向
 常用动画类型:
 type的值	解读	对应常量
 fade	淡入淡出	kCATransitionFade
 push	推挤	kCATransitionPush
 reveal	揭开	kCATransitionReveal
 moveIn	覆盖	kCATransitionMoveIn
 cube	立方体	私有API
 suckEffect	吮吸	私有API
 oglFlip	翻转	私有API
 rippleEffect	波纹	私有API
 pageCurl	反翻页	私有API
 cameraIrisHollowOpen	开镜头	私有API
 cameraIrisHollowClose	关镜头	私有API
 注：私有API只能通过字符串使用哈
 
 过渡方向参数:
 subtype的值	解读
 kCATransitionFromRight	从右转场
 kCATransitionFromLeft	从左转场
 kCATransitionFromBottom	从下转场
 kCATransitionFromTop	从上转场
 
 CAKeyframeAnimation
 CAKeyframeAnimation是CApropertyAnimation的子类，跟CABasicAnimation的区别是：CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值，是一种更灵活的动画方式。
 
 属性	解读
 values	NSArray对象，里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
 path	可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略
 keyTimes	可以为对应的关键帧指定对应的时间点,其取值范围为[0,1],keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
 
 keyPath你可能用到的属性
 
 属性	解读
 transform.rotation.x	围绕x轴翻转。y,z同理 参数：角度
 transform.rotation	默认围绕z轴
 transform.scale.x	x方向缩放。y,z同理
 transform.scale	所有方向缩放
 transform.translation.x	x轴方向移动,参数：x轴上的坐标。y,z同理
 transform.translation	移动到的点
 zPosition	平面的位置
 opacity	透明度
 backgroundColor	背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
 cornerRadius	layer圆角
 borderWidth	边框宽度
 bounds	大小 参数：CGRect
 contents	内容 参数：CGImage
 contentsRect	可视内容 参数：CGRect 值是0～1之间的小数
 position	位置,效果和transform.rotation差不多
 shadowColor	阴影颜色
 shadowOffset	阴影偏移
 shadowOpacity	阴影透明度
 shadowRadius	阴影角度

 */
import UIKit

class Main_CAAnimation: UITableViewController {
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 3:
                let vc = CAAnimationGroupVC()
                navigationController?.pushViewController(vc, animated: true)
            case 5:
                let pvc = CAEmitterLayerVC()
                show(pvc, sender: nil)
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo"
    }
    
}
