

import UIKit

class ViewReversalVC: UIViewController {

    @IBOutlet weak var iv: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        /// bug in iOS 10 beta 3: this doesn't work if the image is not in asset catalog
        self.iv.image = self.iv.image?.imageFlippedForRightToLeftLayoutDirection()

        let v1 = view.viewWithTag(1)! // playback
        let v2 = view.viewWithTag(2)! // nothing, but it's inside 1
        let v3 = view.viewWithTag(3)! // forced rtl
        let v4 = view.viewWithTag(4)! // nothing, but it's inside 3

        print("semantic content attributes")
        /// 用户界面布局方向适合于排列视图的即时内容。当视图的直接内容被排列或绘制时，您应该始终查看此属性的值。 另外，请注意，您不能假定该值通过视图的子树传播。
        print(v1.semanticContentAttribute.rawValue)
        print(v2.semanticContentAttribute.rawValue)
        print(v3.semanticContentAttribute.rawValue)
        print(v4.semanticContentAttribute.rawValue)

        if #available(iOS 10.0, *) {
            printFeatures10()
        } else {
            // Fallback on earlier versions
        }
    }

    /// explore some of the new iOS 10 features
    @available(iOS 10.0, *)
    func printFeatures10() {

        let v1 = view.viewWithTag(1)! // playback
        let v2 = view.viewWithTag(2)! // nothing, but it's inside 1
        let v3 = view.viewWithTag(3)! // forced rtl
        let v4 = view.viewWithTag(4)! // nothing, but it's inside 3

        print("trait collection layout directions")
        print(self.view.traitCollection.layoutDirection.rawValue)
        print(v1.traitCollection.layoutDirection.rawValue)
        print(v2.traitCollection.layoutDirection.rawValue)
        print(v3.traitCollection.layoutDirection.rawValue)
        print(v4.traitCollection.layoutDirection.rawValue)

        print("user interface layout directions")
        let appdir = UIApplication.shared.userInterfaceLayoutDirection
        print(appdir.rawValue)
        print(v1.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v2.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v3.effectiveUserInterfaceLayoutDirection.rawValue)
        print(v4.effectiveUserInterfaceLayoutDirection.rawValue)

        print("UIView.userInterfaceLayoutDirection")
        /// 返回给定语义内容属性的用户界面方向。创建包含子视图的视图时，您可以使用此方法来确定是否应翻转子视图，并按适当的顺序布置视图。
        print(UIView.userInterfaceLayoutDirection(for: v1.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v1.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v2.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v2.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v3.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v3.semanticContentAttribute, relativeTo: appdir).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v4.semanticContentAttribute).rawValue)
        print(UIView.userInterfaceLayoutDirection(for: v4.semanticContentAttribute, relativeTo: appdir).rawValue)
    }


}

