//
//  ImageAndTraitCollection.swift
//  Constraint
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

/*
 trait集合描述了您的应用程序的iOS界面环境，包括水平和垂直大小类，显示比例和用户界面习语等特征。要创建自适应界面，请编写代码以根据这些特征的变化调整应用程序的布局。
 iOS特性环境通过UITraitEnvironment协议的traitCollection属性来暴露。该协议由以下类引用：UIScreen，UIWindow，UIViewController，UIPresentationController和UIView。您可以使用UITraitCollection horizo​​ntalSizeClass，verticalSizeClass，displayScale和userInterfaceIdiom属性访问特定的特征值。表达成语和大小特征的值在UIUserInterfaceIdiom和UIUserInterfaceSizeClass枚举中定义;显示比例特征的值表示为浮点数。
 要使您的视图控制器和视图响应iOS界面环境中的更改，请从trait环境协议中覆盖traitCollectionDidChange（_ :)方法。要自定义视图控制器动画以响应界面环境更改，请覆盖UIContentContainer协议的willTransition（to :) with :)方法。
 此图显示了在各种设备全屏幕上运行时，您的应用程序可能遇到的水平（宽度）和垂直（高度）大小等级。
 有关您的应用程序在iPad上的幻灯片和拆分视图中遇到的大小类的信息，请阅读幻灯片并分割视图快速入门以在iPad上采用多任务增强功能。
 您可以创建独立的trait集合来帮助与特定环境匹配。 UITraitCollection类包括四个专门的构造函数以及一个构造函数，它可以组合一系列特征集合init（traitsFrom :)。
 独立trait集合的一个重要用途是基于当前的iOS界面环境启用有条件的使用图像。您可以通过UIImageAsset实例将trait集合与UIImage实例相关联，如UIImageAsset的概述部分所述。有关从Xcode IDE中以图形方式配置资产目录的信息，请参阅资产目录帮助。
 您可以使用独立的trait集合来在iPhone上以横向方向启用两列拆分视图。请参阅UIViewController类的setOverrideTraitCollection（_：forChildViewController :)方法。
 独立的trait集合也可以通过appearanc（for :)协议方法定制视图外观，如UIAppearance中所述。
 */

import UIKit

class ImageAndTraitCollection: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var iv2: UIImageView!

    @IBOutlet weak var b: UIButton!
    @IBOutlet weak var v: ImageAndTraitCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.iv.image = UIImage(named:"Moods")

        let tcdisp = UITraitCollection(displayScale: UIScreen.main.scale)
        let tcphone = UITraitCollection(userInterfaceIdiom: .phone)
        let tcreg = UITraitCollection(verticalSizeClass: .regular)
        let tc1 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tcreg])
        let tccom = UITraitCollection(verticalSizeClass: .compact)
        let tc2 = UITraitCollection(traitsFrom: [tcdisp, tcphone, tccom])

        /*
         UIImageAsset对象是用于表示描述单张艺术作品的多种方式的图像集合的容器。 UIImageAsset的常见用例是在不同的显示比例下对同一项目的多个图像进行分组。
         UIImageAsset对象不分配给UIImage的实例; 当图像的多个表示可用时，UIImage提供资产。 使用init（named:)或init（named：compatibleWith :)方法的图像资产目录检索的图像自动具有允许从目录访问其他图像的UIImageAsset对象。
         */
        let moods = UIImageAsset()
        let frowney = UIImage(named:"frowney")!.withRenderingMode(.alwaysOriginal)
        let smiley = UIImage(named:"smiley")!.withRenderingMode(.alwaysOriginal)
        moods.register(frowney, with: tc1)
        moods.register(smiley, with: tc2)

        let tc = self.traitCollection
        let im = moods.image(with: tc)
        self.iv2.image = im

        self.b.setImage(im, for: UIControlState())
        self.b.setImage(im, for: .highlighted)

        self.v.image = im
    }

}


class ImageAndTraitCollectionView: UIView {

    var image : UIImage!

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setNeedsDisplay() // causes drawRect to be called
    }

    override func draw(_ rect: CGRect) {
        if var im = self.image {
            if let asset = self.image.imageAsset {
                let tc = self.traitCollection
                im = asset.image(with: tc)
            }
            im.draw(at: CGPoint.zero)
        }
    }
}
