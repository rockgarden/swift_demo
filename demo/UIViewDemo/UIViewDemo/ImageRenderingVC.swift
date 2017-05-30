
import UIKit

class ImageRenderingVC : UIViewController {
    @IBOutlet var b : UIButton!
    @IBOutlet var tbi : UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let window = UIApplication.shared.delegate!.window! {
            window.tintColor = UIColor.red
        }

        /// 使用指定的渲染模式创建并返回一个新的图像对象。
        /// alwaysTemplate: 始终绘制图像作为模板图像，忽略其颜色信息.
        let im = UIImage(named:"Smiley")!.withRenderingMode(.alwaysTemplate)
        self.b.setBackgroundImage(im, for: UIControlState())
        let im2 = UIImage(named:"smiley2")!.withRenderingMode(.alwaysOriginal)
        self.tbi.image = im2

        // but with Xcode 6, this sort of thing is usually unnecessary!
        /// look at the third button in the top row; it is template but with _no code_ that's because you can now set the rendering mode directly in the asset catalog

        // also demonstrated, another new Xcode 6 feature: vector art in the asset catalog!
        // one size fits all, without rasterization
        // apparently only vector PDFs are acceptable

        /// withAlignmentRectInsets可用于去除图片的特定区域: setting alignment rectangle in asset catalog
        let im3 = UIImage(named:"photo")!.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 18, 0))
        let iv = UIImageView(image: im3)
        self.view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        // the previous code aligns to bottom correctly
        // now, if alignment rectangle in asset catalog were working...
        // then I should be able to make the same setting in the asset catalog
        // and then I would just fetch the image directly
        // but it doesn't work, as I shall now show

        let im4 = UIImage(named:"photo")! // trying to use asset catalog alignment
        let iv2 = UIImageView(image:im4)
        self.view.addSubview(iv2)
        iv2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            iv2.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        // FIXME: In the asset catalog, it is the Top, not the Bottom, that I have set
        // Moreover, if I don't also set the Left, nothing happens at all;
        // a Left of 0 turns off the whole thing

        print(im4.alignmentRectInsets) // C.UIEdgeInsets(top: 0.0, left: 0.5, bottom: 24.0, right: 0.0)
        // but what I set was the top!
        print(iv2.alignmentRectInsets)


        let im5 = UIImage(named:"smiley2")!
        let b = UIButton(type: .system)
        b.setImage(im5.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 40, 0)), for: .normal)
        b.setTitle("Howdy", for:.normal)
        b.sizeToFit()
        self.view.addSubview(b)
        
    }
}


