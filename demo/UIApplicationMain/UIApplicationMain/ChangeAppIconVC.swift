/**
 在info.plist配置
 https://developer.apple.com/reference/uikit/uiapplication/2806818-setalternateiconname#parameters
 https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/TP40009249-SW14
 Primary Icon 字段写为 AppIcon60x60 是因为这里 xcassets 里面我只导入了 60pt@2x 和 60pt@3x 的图片资源，这里选为 60 是因为对于 iPhone，60pt 的图片资源图标所需最高质量，更低分辨率的版本系统会自动压缩以展示。
 blackBgColor 是我的用于替换原生图标的图片资源。文件名需要和 info.plist 中保持一致（注意 info.plist 中用到了两次 "blackBgColor"），同时这也是你在代码中设置图标时，需要给 API 传入的参数。同样是 60pt@2x 和 60pt@3x 的图片资源，文件不通过 Assets.xcassets 添加进来，而是直接放到目录中。
 如果你需要支持 iPad，建议这里使用 83.5pt（iPad Pro）的图片资源。另外还有些其他关于在 iPad 上替换图标的注意事项，在这里有说明，注意我们这里在 info.plist 里面所用的 key 是 CFBundleIcons，还有另外一个 key 是 CFBundleIcons~ipad。
 */
import UIKit

class ChangeAppIconVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeAppIcon(_ sender: Any) {
        
        if UIApplication.shared.supportsAlternateIcons {
            print("you can change this app's icon")
        }else {
            print("you cannot change this app's icon")
            return
        }
        
        if let name = UIApplication.shared.alternateIconName {
            // CHANGE TO PRIMARY ICON
            UIApplication.shared.setAlternateIconName(nil) { (err:Error?) in
                print("set icon error：\(String(describing: err))")
            }
            print("the alternate icon's name is \(name)")
        }else {
            // CHANGE TO ALTERNATE ICON
            UIApplication.shared.setAlternateIconName("blackBgColor") { (err:Error?) in
                print("set icon error：\(String(describing: err))")
            }
        }
    }

}

