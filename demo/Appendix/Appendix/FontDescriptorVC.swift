

import UIKit

class FontDescriptorVC : UIViewController {

    @IBOutlet var lab : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet var lab3 : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.0, *) {
            self.lab.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }

        let f = UIFont(name: "Avenir", size: 15)!
        /// 返回描述字体的字体描述符。字体描述符包含用于创建 UIFont 对象的可选属性的可变字典。
        let desc = f.fontDescriptor
        /// UIFontDescriptorSymbolicTraits象征性地描述了一种字体的风格方面。 高16位用于描述字体的外观，而低16位用于字体。 由高16位表示的字体外观信息可用于文体字体匹配。
        let desc2 = desc.withSymbolicTraits(.traitItalic)
        let f2 = UIFont(descriptor: desc2!, size: 0)
        print(f)
        print(desc)
        print(desc2 as Any)
        print(f2)

        let ff = UIFont(name: "GillSans-BoldItalic", size: 20)!
        let dd = ff.fontDescriptor
        let vis = dd.object(forKey:UIFontDescriptor.AttributeName.visibleName)!
        print(vis)
        let traits = dd.symbolicTraits
        let isItalic = traits.contains(.traitItalic)
        let isBold = traits.contains(.traitBold)
        print(isItalic, isBold)

        var which : Int { return 1 }

        switch which {
        case 0:
            let desc = UIFontDescriptor(name:"Didot", size:18)
            // print(desc.fontAttributes())
            let d = [
                UIFontDescriptor.FeatureKey.featureIdentifier:kLetterCaseType,
                UIFontDescriptor.FeatureKey.typeIdentifier:kSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes(
                [UIFontDescriptor.AttributeName.featureSettings:[d]]
            )
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        case 1:
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
            // print(desc.fontAttributes())
            let d = [
                UIFontDescriptor.FeatureKey.featureIdentifier:kLowerCaseType,
                UIFontDescriptor.FeatureKey.typeIdentifier:kLowerCaseSmallCapsSelector
            ]
            let desc2 = desc.addingAttributes(
                [UIFontDescriptor.AttributeName.featureSettings:[d]]
            )
            let f = UIFont(descriptor: desc2, size: 0)
            self.lab.font = f
        default: break
        }

        do {

            var whichh : Int { return 0 }

            switch whichh {
            case 0:
                var f = UIFont.preferredFont(forTextStyle:.title2)

                let desc = f.fontDescriptor
                let d = [
                    UIFontDescriptor.FeatureKey.featureIdentifier:kStylisticAlternativesType,
                    UIFontDescriptor.FeatureKey.typeIdentifier:kStylisticAltOneOnSelector
                ]
                let desc2 = desc.addingAttributes(
                    [UIFontDescriptor.AttributeName.featureSettings:[d]]
                )
                f = UIFont(descriptor: desc2, size: 0)

                self.lab2.font = f
                self.lab2.text = "1234567890 Hill IO" // notice the straight 6 and 9

            case 1:
                var f = UIFont.preferredFont(forTextStyle:.title2)

                let desc = f.fontDescriptor
                let d = [
                    UIFontDescriptor.FeatureKey.featureIdentifier:kStylisticAlternativesType,
                    UIFontDescriptor.FeatureKey.typeIdentifier:kStylisticAltSixOnSelector
                ]
                let desc2 = desc.addingAttributes(
                    [UIFontDescriptor.AttributeName.featureSettings:[d]]
                )
                f = UIFont(descriptor: desc2, size: 0)

                self.lab2.text = "1234567890 Hill IO" // adds curvy ell
                self.lab2.font = f


            default:break
            }

            //            let mas = NSMutableAttributedString(string: "offloading fistfights", attributes: [
            //                NSFontAttributeName:UIFont(name: "Didot", size: 20)!,
            //                NSLigatureAttributeName:0
            //                ])
            //            self.lab2.attributedText = mas

            //            self.lab2.font = UIFont(name: "Papyrus", size: 20)
            //            self.lab2.text = "offloading fistfights"

            do {
                let desc = UIFontDescriptor(name: "Didot", size: 20) as CTFontDescriptor
                let f = CTFontCreateWithFontDescriptor(desc,0,nil)
                let arr = CTFontCopyFeatures(f)
                print(arr as Any)


            }

        }

        fontDownload()
    }

    /// 当iOS界面环境发生变化时，系统会调用此方法。根据您的应用需求，在视图控制器和视图中实现此方法来响应这些更改。例如，当iPhone从纵向旋转到横向时，您可以调整视图控制器的子视图的布局。此方法的默认实现为空。
    override func traitCollectionDidChange(_ ptc: UITraitCollection?) {
        let tc = self.traitCollection
        if #available(iOS 10.0, *) {
            if ptc == nil ||
                ptc!.preferredContentSizeCategory != tc.preferredContentSizeCategory {
                self.doDynamicType()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func doDynamicType() {
        var fbody : UIFont!
        var femphasis : UIFont!

        let body = UIFontDescriptor.preferredFontDescriptor(withTextStyle:.body)
        let emphasis = body.withSymbolicTraits(.traitItalic)!
        fbody = UIFont(descriptor: body, size: 0)
        femphasis = UIFont(descriptor: emphasis, size: 0)
        print(fbody)

        let s = self.lab.text!
        let mas = NSMutableAttributedString(string: s, attributes: [NSAttributedStringKey.font:fbody])
        mas.addAttribute(NSAttributedStringKey.font, value: femphasis, range: (s as NSString).range(of:"wild"))
        self.lab.attributedText = mas
    }
    
}


// MARK: - FontDownloadable
extension FontDescriptorVC {

    func doDynamicType(_ n:Notification!) {
        self.lab3.font = UIFont.preferredFont(forTextStyle:.headline)
    }

    func fontDownload() {
        let name = "NanumBrush" // another one to try: YuppySC-Regular, also good old LucidaGrande
        let size : CGFloat = 24
        let f = UIFont(name:name, size:size)
        if f != nil {
            self.lab3.font = f
            print("already installed")
            return
        }
        print("attempting to download font")
        let desc = UIFontDescriptor(name:name, size:size)

        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(
            [desc] as CFArray, nil, { state, prog in
                switch state {
                case .didBegin:
                    NSLog("%@", "matching did begin")
                case .willBeginDownloading:
                    NSLog("%@", "downloading will begin")
                case .downloading:
                    let d = prog as NSDictionary
                    let key = kCTFontDescriptorMatchingPercentage
                    let cur = d[key] // wow, no cast needed
                    if let cur = cur as? NSNumber {
                        NSLog("progress: %@%%", cur)
                    }
                case .didFinishDownloading:
                    NSLog("%@", "downloading did finish")
                case .didFailWithError:
                    NSLog("%@", "downloading failed")
                case .didFinish:
                    NSLog("%@", "matching did finish")
                    DispatchQueue.main.async {
                        let f : UIFont! = UIFont(name:name, size:size)
                        if f != nil {
                            NSLog("%@", "got the font!")
                            self.lab3.font = f
                        }
                    }
                default:break
                }
                return true
        })
    }
}
