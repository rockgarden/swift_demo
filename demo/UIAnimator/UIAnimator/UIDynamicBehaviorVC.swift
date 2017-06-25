/*:
 UIDynamic将现实世界动力驱动的动画引入了UIKit，比如动力，铰链连接，碰撞，悬挂等效果，即将2D物理引擎引入了UIKit。
 UIDynamic中的三个重要概念
 * Dynamic Animator：动画者，为动力学元素提供物理学相关的能力及动画，同时为这些元素提供相关的上下文，是动力学元素与底层iOS物理引擎之间的中介，将Behavior对象添加到Animator即可实现动力仿真。
 * Dynamic Animator Item:动力学元素，是任何遵守了UIDynamic协议的对象，从iOS7开始，UIView和UICollectionViewLayoutAttributes默认实现协议，如果自定义对象实现了该协议，即可通过Dynamic Animator实现物理仿真。
 * UIDynamicBehavior:仿真行为，是动力学行为的父类，基本的动力学行为类UIGravityBehavior、UICollisionBehavior、UIAttachmentBehavior、UISnapBehavior、UIPushbehavior以及UIDynamicItemBehavior均继承自该父类。

 动态项目是符合UIDynamicItem协议的任何iOS或自定义对象。 UIView和UICollectionViewLayoutAttributes类从iOS 7.0开始实现此协议。您可以实现此协议，以使用具有自定义对象的Dynamic animator，以实现由动画师计算的旋转或位置更改的反应。
 要使用动态，请配置一个或多个动态行为，包括为每个动态行为提供一组动态项，然后将这些行为添加到动态动画。
 您可以使用任何iOS原始动态行为类来指定动态行为：UIAttachmentBehavior，UICollisionBehavior，UIDynamicItemBehavior，UIGravityBehavior，UIPushBehavior和UISnapBehavior。它们中的每一个提供配置选项，并允许您将一个或多个动态项目与行为关联。要激活某个行为，请将其添加到动画制作工具。
 动态动画制作者与其每个动态项目进行交互，如下所示：
 在将项目添加到行为之前，您可以指定项目的起始位置，旋转和边界（为此，使用项目类的属性，例如基于UIView的项目的中心，转换和边界属性）
 在将动画添加到动画制作器之后，动画师接管：随着动画的进行，它更新了项目的位置和旋转（参见UIDynamicItem协议）
 您可以通过编程方式在动画中更新项目的状态，之后，动画制作人员相对于您指定的状态来收回项目动画的控制（请参阅updateItem（usingCurrentState :)方法）
 您可以使用UIDynamicBehavior父行为类的addChildBehavior（_ :)方法定义复合行为。您添加到动画师的一组行为构成行为层次结构。与动画师关联的每个行为实例在层次结构中只能出现一次。
 要使用动态动画制作工具，首先要确定要动画的动态项目的类型。该选择确定要调用哪个初始化器，这又决定了坐标系如何设置。初始化动画师的三种方法，然后可以使用的动态项目以及由此产生的坐标系统如下所示：
 要创建动画视图，请使用init（referenceView :)方法创建动画。参考视图的坐标系作为动画师行为和项目的坐标系。与此类动画制作器关联的每个动态项目必须是UIView对象，并且必须从参考视图中下降。
 相对于参考视图的范围，您可以定义参与碰撞行为的项目的边界。请参阅setTranslatesReferenceBoundsIntoBoundary（with :)方法。
 要使集合视图生成动画，请使用init（collectionViewLayout :)方法创建动画。所得到的动画师使用集合视图布局（UICollectionViewLayout类的对象）作为其坐标系。此类动画制作工具中的动态项目必须是UICollectionViewLayoutAttributes作为布局一部分的对象。
 相对于集合视图布局的边界，可以为参与碰撞行为的项定义边界。请参阅setTranslatesReferenceBoundsIntoBoundary（with :)方法。
 集合视图动画师根据需要自动调用invalidateLayout（）方法，并在更改集合视图的布局时酌情自动暂停和恢复动画。
 要使用符合UIDynamicItem协议的其他对象的Dynamic animator，请使用继承的init（）方法创建一个动画。所得到的动画师使用抽象坐标系统，不绑定到屏幕或任何视图。
 当定义与这种动画制作者一起使用的碰撞边界时，没有参考边界。但是，您仍然可以在碰撞行为中指定自定义边界，如UICollisionBehavior所述。
 所有类型的Dynamic animator分享以下特点：
 每个Dynamic animator都与您创建的其他Dynamic animator无关
 您可以将给定的动态项目与多个行为相关联，前提是这些行为属于同一个动画师
 动画师在其所有物品处于休息状态时自动暂停，并且在行为参数更改或行为或项目被添加或删除时自动恢复
 您可以使用UIDynamicAnimatorDelegate协议的dynamicAnimatorDidPause（_ :)和dynamicAnimatorWillResume（_ :)方法来实现代理以响应动画师暂停/恢复状态的更改。
 */


import UIKit


class MyGravityBehavior : UIGravityBehavior {
    deinit {
        print("farewell from grav")
    }
}


class MyImageView : UIImageView {
    /// new in iOS 9, we can describe the shape of our image view for collisions 碰撞
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return UIDynamicItemCollisionBoundsType.ellipse
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        print("image view move to \(String(describing: newWindow))")
    }

    deinit {
        print("farewell from iv")
    }
}


class UIDynamicBehaviorVC : UIViewController {

    @IBOutlet weak var iv : UIImageView!
    var anim : UIDynamicAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.anim = UIDynamicAnimator(referenceView: self.view)
        self.anim.delegate = self
    }

    let which = 1

    @IBAction func doButton(_ sender: Any?) {
        (sender as! UIButton).isEnabled = false //防止多次click

        self.anim.addBehavior(DropBounceAndRollBehavior(view:self.iv))

        return

        do {
            let grav = MyGravityBehavior()

            switch which {
            case 1:
                // leak! neither the image view nor the gravity behavior is released
                grav.action = {
                    let items = self.anim.items(in:self.view.bounds) as! [UIView]
                    let ix = items.index(of:self.iv)
                    if ix == nil {
                        self.anim.removeAllBehaviors()
                        self.iv.removeFromSuperview()
                        print("done")
                    }
                }
            case 2:
                grav.action = {
                    let items = self.anim.items(in:self.view.bounds) as! [UIView]
                    let ix = items.index(of:self.iv)
                    if ix == nil {
                        self.anim.removeAllBehaviors()
                        self.iv.removeFromSuperview()
                        self.anim = nil // * both are released
                        print("done")
                    }
                }
            case 3:
                grav.action = {
                    let items = self.anim.items(in:self.view.bounds) as! [UIView]
                    let ix = items.index(of:self.iv)
                    if ix == nil {
                        delay(0) { // * both are released
                            self.anim.removeAllBehaviors()
                            self.iv.removeFromSuperview()
                            print("done")
                        }
                    }
                }
            case 4:
                grav.action = {
                    [weak grav] in // *
                    if let grav = grav {
                        let items = self.anim.items(in:self.view.bounds) as! [UIView]
                        let ix = items.index(of:self.iv)
                        if ix == nil {
                            self.anim.removeBehavior(grav) // * grav is released, iv is not!
                            self.anim.removeAllBehaviors() // probably because of the other behaviors
                            self.iv.removeFromSuperview()
                            print("done")
                        }
                    }
                }
            default: break
            }

            self.anim.addBehavior(grav)
            grav.addItem(self.iv)

            // ========

            let push = UIPushBehavior(items:[self.iv], mode:.instantaneous)
            push.pushDirection = CGVector(1,0)
            // push.setTargetOffsetFromCenter(UIOffsetMake(0,-200), for: self.iv)
            self.anim.addBehavior(push)

            // ========

            let coll = UICollisionBehavior()
            coll.collisionMode = .boundaries
            coll.collisionDelegate = self
            coll.addBoundary(withIdentifier:"floor" as NSString,
                             from:CGPoint(0, self.view.bounds.maxY),
                             to:CGPoint(self.view.bounds.maxX,
                                        self.view.bounds.maxY))
            self.anim.addBehavior(coll)
            coll.addItem(self.iv)
            
            // =========
            
            let bounce = UIDynamicItemBehavior()
            bounce.elasticity = 0.8
            self.anim.addBehavior(bounce)
            bounce.addItem(self.iv)
        }
    }
}

extension UIDynamicBehaviorVC : UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("pause")
    }

    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("resume")
    }

    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at p: CGPoint) {
        print(p)
        // look for the dynamic item behavior
        let b = self.anim.behaviors
        if let ix = b.index(where:{$0 is UIDynamicItemBehavior}) {
            let bounce = b[ix] as! UIDynamicItemBehavior
            /// 返回指定动态项目的角速度
            let v = bounce.angularVelocity(for:item)
            print("VC Print - angular velocity: \(v)")
            if v <= 6 {
                print("adding angular velocity")
                bounce.addAngularVelocity(6, for:item)
            }
        }
    }
    
}
