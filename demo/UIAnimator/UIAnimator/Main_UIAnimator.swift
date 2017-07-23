

import UIKit

class Main_UIAnimator: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let vc = UIFieldBehaviorVC()
            show(vc, sender: nil)
        default:
            break
        }

    }
    
}

/**
 # UIDynamicAnimator
 动态动画师为其动态项目提供与物理相关的功能和动画，并为这些动画提供上下文。它通过在底层的iOS物理引擎和动态项之间进行中介，通过添加到动画师的行为对象。
 动态项目是符合UIDynamicItem协议的任何iOS或自定义对象。 UIView和UICollectionViewLayoutAttributes类从iOS 7.0开始实现此协议。您可以实现此协议，使用具有自定义对象的动态动画制作工具，以实现由动画师计算的旋转或位置更改的反应。
 要使用动态，请配置一个或多个动态行为，包括为每个动态行为提供一组动态项，然后将这些行为添加到动态动画。
 您可以使用任何iOS原始动态行为类来指定动态行为：UIAttachmentBehavior，UICollisionBehavior，UIDynamicItemBehavior，UIGravityBehavior，UIPushBehavior和UISnapBehavior。每个都提供配置选项，并允许您将一个或多个动态项目与行为关联。要激活行为，请将其添加到动画制作工具。
 动态动画师与其动态项目进行交互，如下所示：
 在将项目添加到行为之前，请指定项目的起始位置，旋转和边界（为此，使用项目类的属性，例如基于UIView的项目的中心，转换和边界属性） ）
 在将动画添加到动画制作器之后，动画师接管：随着动画的进行，它更新了项目的位置和旋转（参见UIDynamicItem协议）
 您可以通过编程方式在动画中更新项目的状态，之后，动画师相对于您指定的状态来收回项目动画的控制（请参阅updateItem（usingCurrentState :)方法）
 您可以使用UIDynamicBehavior父行为类的addChildBehavior（_ :)方法定义复合行为。添加到动画制作器中的一组行为构成行为层次结构。与动画师关联的每个行为实例在层次结构中只能出现一次。
 要使用动态动画制作工具，首先要确定要动画化的动态项目的类型。该选择确定要调用哪个初始化程序，这又决定了坐标系如何设置。初始化动画师的三种方法，然后可以使用的动态项目以及由此产生的坐标系统如下：
 要使动画生成动画，请使用init（referenceView :)方法创建动画。参考视图的坐标系作为动画师行为和项目的坐标系。与此类动画师关联的每个动态项必须是UIView对象，必须从参考视图中下降。
 相对于参考视图的边界，您可以定义参与碰撞行为的项目的边界。请参阅setTranslatesReferenceBoundsIntoBoundary（with :)方法。
 要使集合视图生成动画，请使用init（collectionViewLayout :)方法创建一个动画。所得到的动画师使用集合视图布局（UICollectionViewLayout类的对象）作为其坐标系。这种动画制作工具中的动态项目必须是UICollectionViewLayoutAttributes作为布局的一部分的对象。
 相对于集合视图布局的边界，可以为参与碰撞行为的项定义边界。请参阅setTranslatesReferenceBoundsIntoBoundary（with :)方法。
 集合视图动画师根据需要自动调用invalidateLayout（）方法，并在更改集合视图的布局时酌情自动暂停和恢复动画。
 要使用符合UIDynamicItem协议的其他对象的动态动画师，请使用继承的init（）方法创建一个动画。所得到的动画师使用抽象坐标系统，不绑定到屏幕或任何视图。
 当定义与这种动画师一起使用的碰撞边界时，没有参考边界。但是，在碰撞行为中，仍然可以按照UICollisionBehavior中的描述指定自定义边界。
 所有类型的动态动画师分享以下特点：
 每个动态动画师都与您创建的其他动态动画师无关
 您可以将给定的动态项目与多个行为相关联，前提是这些行为属于同一个动画师
 动画师在所有项目静止时自动暂停，并且当行为参数更改或行为或项目添加或删除时自动恢复
 您可以使用UIDynamicAnimatorDelegate协议的dynamicAnimatorDidPause（_ :)和dynamicAnimatorWillResume（_ :)方法来实现代理以响应动画师暂停/恢复状态的更改。
 */

/**
 # UIViewPropertyAnimator 
 动画修改视图，并允许动态修改这些动画。
 UIViewPropertyAnimator对象可让您对视图进行动画更新，并在动画完成前动态修改动画。使用属性动画师，您可以从一开始到正常地运行动画，也可以将其转换为互动动画并自动控制时间。动画师操作视图的动画属性，如框架，中心，阿尔法和变换属性，从您提供的块创建所需的动画。
 创建属性动画制作对象时，请指定以下内容：
 包含修改一个或多个视图的属性的代码的块。
 定时曲线定义了运行过程中动画的速度。
 动画的持续时间（以秒为单位）。
 动画完成时执行的可选完成块。
 在动画块中，将动画属性的值设置为您希望该视图所反映的最终值。例如，如果要淡出视图，您可以将其alpha属性设置为0。属性animator对象创建一个动画，将该属性的值从其初始值调整到块中指定的新值。
 属性值更改的速度由创建属性动画师时指定的时间曲线控制。属性动画师包括支持内置的UIKit动画曲线，如线性，轻松和轻松。您还可以使用三次Bezier曲线或弹簧功能来控制动画的时间。
 如果您使用标准初始化方法之一创建动画师，则必须通过调用startAnimation（）方法来显式启动动画。如果要在创建动画制作器后立即启动动画，请使用runningPropertyAnimator（withDuration：delay：options：animations：completion :)方法，而不是标准初始化程序。
 该类采用UIViewAnimating和UIViewImplicitlyAnimating协议，它们定义了启动，停止和修改动画的方法。有关这些协议的方法的更多信息，请参阅UIViewAnimating和UIViewImplicitlyAnimating。
 */
