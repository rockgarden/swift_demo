

import UIKit


/// scrollViewInNib
class ContentSizeVC : UIViewController {
    @IBOutlet var sv : UIScrollView!
    var didSetup = false
    
    /// storyboard doesn't use autolayout 所以有告警, 因为 是否启用 Use Auto Layout 是以storyboard文件为单位的.
    /// 由于 Use Auto Layout 没有设置, 所以人 Adjust Scroll View Insets 开启也 automaticallyAdjustsScrollViewInsets = true 也不起作用.

    /// 在 LayoutSubviews() 中 用 sv.subviews[0] 设置 contentSize!!! 可省略用 @IBOutlet var contentSize 来设置.
    override func viewDidLayoutSubviews() {
        if !didSetup {
            didSetup = true
            /// 重要 "Init ContentSize:" (0.0, 0.0)
            debugPrint("Init ContentSize:", sv.contentSize)
            sv.contentSize = sv.subviews[0].bounds.size
        }
    }
    
    /// storyboard 可配置 no code for content inset - automaticallyAdjustsScrollViewInsets takes care of it

}
