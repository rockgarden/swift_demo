//
//  CustomBar.swift
//  navBar
//
//  Created by Remi Robert on 31/12/14.
//  Copyright (c) 2014 Remi Robert. All rights reserved.
//

//import UIKit
//
//enum ThemeColor {
//    case red, pink, purple, deepPurple, indigo, blue, lightBlue, cyan, teal, green, lightGreen, lime, yellow, amber, orange, deepOrange, brown, grey, blueGrey
//
//    func toColor() -> (statusBar: UIColor, navigationBar: UIColor) {
//        switch self {
//        case .red:
//            return (UIColor(red: 211 / 255.0, green: 47 / 255.0, blue: 47 / 255.0, alpha: 1),
//                    UIColor(red: 244 / 255.0, green: 67 / 255.0, blue: 54 / 255.0, alpha: 1))
//        case .pink:
//            return (UIColor(red: 194 / 255.0, green: 24 / 255.0, blue: 91 / 255.0, alpha: 1),
//                    UIColor(red: 233 / 255.0, green: 30 / 255.0, blue: 99 / 255.0, alpha: 1))
//        case .purple:
//            return (UIColor(red: 123 / 255.0, green: 31 / 255.0, blue: 162 / 255.0, alpha: 1),
//                    UIColor(red: 156 / 255.0, green: 39 / 255.0, blue: 176 / 255.0, alpha: 1))
//        case .deepPurple:
//            return (UIColor(red: 81 / 255.0, green: 45 / 255.0, blue: 168 / 255.0, alpha: 1),
//                    UIColor(red: 103 / 255.0, green: 58 / 255.0, blue: 183 / 255.0, alpha: 1))
//        case .indigo:
//            return (UIColor(red: 48 / 255.0, green: 63 / 255.0, blue: 159 / 255.0, alpha: 1),
//                    UIColor(red: 63 / 255.0, green: 81 / 255.0, blue: 181 / 255.0, alpha: 1))
//        case .blue:
//            return (UIColor(red: 26 / 255.0, green: 118 / 255.0, blue: 210 / 255.0, alpha: 1),
//                    UIColor(red: 32 / 255.0, green: 150 / 255.0, blue: 243 / 255.0, alpha: 1))
//        case .lightBlue:
//            return (UIColor(red: 1 / 255.0, green: 136 / 255.0, blue: 209 / 255.0, alpha: 1),
//                    UIColor(red: 4 / 255.0, green: 169 / 255.0, blue: 244 / 255.0, alpha: 1))
//        case .cyan:
//            return (UIColor(red: 0, green: 151 / 255.0, blue: 167 / 255.0, alpha: 1),
//                    UIColor(red: 1 / 255.0, green: 188 / 255.0, blue: 212 / 255.0, alpha: 1))
//        case .teal:
//            return (UIColor(red: 0, green: 121 / 255.0, blue: 107 / 255.0, alpha: 1),
//                    UIColor(red: 0, green: 150 / 255.0, blue: 136 / 255.0, alpha: 1))
//        case .green:
//            return (UIColor(red: 56 / 255.0, green: 142 / 255.0, blue: 60 / 255.0, alpha: 1),
//                    UIColor(red: 76 / 255.0, green: 175 / 255.0, blue: 80 / 255.0, alpha: 1))
//        case .lightGreen:
//            return (UIColor(red: 104 / 255.0, green: 159 / 255.0, blue: 56 / 255.0, alpha: 1),
//                    UIColor(red: 139 / 255.0, green: 195 / 255.0, blue: 74 / 255.0, alpha: 1))
//        case .lime:
//            return (UIColor(red: 175 / 255.0, green: 180 / 255.0, blue: 43 / 255.0, alpha: 1),
//                    UIColor(red: 205 / 255.0, green: 220 / 255.0, blue: 57 / 255.0, alpha: 1))
//        case .yellow:
//            return (UIColor(red: 251 / 255.0, green: 192 / 255.0, blue: 46 / 255.0, alpha: 1),
//                    UIColor(red: 255 / 255.0, green: 235 / 255.0, blue: 59 / 255.0, alpha: 1))
//        case .amber:
//            return (UIColor(red: 255 / 255.0, green: 160 / 255.0, blue: 1 / 255.0, alpha: 1),
//                    UIColor(red: 255 / 255.0, green: 193 / 255.0, blue: 8 / 255.0, alpha: 1))
//        case .orange:
//            return (UIColor(red: 245 / 255.0, green: 124 / 255.0, blue: 1 / 255.0, alpha: 1),
//                    UIColor(red: 255 / 255.0, green: 152 / 255.0, blue: 1 / 255.0, alpha: 1))
//        case .deepOrange:
//            return (UIColor(red: 230 / 255.0, green: 74 / 255.0, blue: 25 / 255.0, alpha: 1),
//                    UIColor(red: 255 / 255.0, green: 87 / 255.0, blue: 35 / 255.0, alpha: 1))
//        case .brown:
//            return (UIColor(red: 93 / 255.0, green: 64 / 255.0, blue: 55 / 255.0, alpha: 1),
//                    UIColor(red: 121 / 255.0, green: 85 / 255.0, blue: 72 / 255.0, alpha: 1))
//        case .grey:
//            return (UIColor(red: 97 / 255.0, green: 97 / 255.0, blue: 97 / 255.0, alpha: 1),
//                    UIColor(red: 158 / 255.0, green: 158 / 255.0, blue: 158 / 255.0, alpha: 1))
//        case .blueGrey:
//            return (UIColor(red: 69 / 255.0, green: 90 / 255.0, blue: 100 / 255.0, alpha: 1),
//                    UIColor(red: 96 / 255.0, green: 125 / 255.0, blue: 139 / 255.0, alpha: 1))
//        }
//    }
//}
//
//class MaterialNavigationBar: UINavigationBar {
//
//    var viewBarStatus: UIView!
//    var titleLabel: UILabel!
//
//    class RRNavigationBarParameter {
//
//        private static var __once: () = {
//                Static.instance = RRNavigationBarParameter()
//                Static.instance?.currentTheme = ThemeColor.grey
//            }()
//
//        var currentTheme: ThemeColor! = nil
//        var currentNavigationBar: MaterialNavigationBar! = nil
//
//        class var sharedInstance: RRNavigationBarParameter {
//
//            struct Static {
//                static var instance: RRNavigationBarParameter?
//                static var token: Int = 0
//            }
//
//            _ = RRNavigationBarParameter.__once
//
//            return Static.instance!
//        }
//    }
//
//    class func changeColorNavigationBar(_ color: ThemeColor) {
//        RRNavigationBarParameter.sharedInstance.currentTheme = color
//    }
//
//    func animateTitle() {
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.5,
//                                   options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
//                                    self.titleLabel.frame = CGRect(x: self.titleLabel.frame.size.width / 2, y: 0,
//                                                                       width: self.titleLabel.frame.size.width, height: self.titleLabel.frame.size.height)
//        }, completion: nil)
//    }
//
//    func animationPop() {
//        for currentSubView in self.subviews {
//            if (NSStringFromClass(object_getClass(currentSubView)) == "_UINavigationBarBackIndicatorView") {
//
//                (currentSubView as UIView).transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
//
//
//                UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5,
//                                           options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
//                                            (currentSubView as UIView).frame.origin.x = -currentSubView.frame.size.width
//                                            (currentSubView as UIView).transform = CGAffineTransform(rotationAngle: CGFloat(0))
//
//                }, completion: nil)}
//        }
//    }
//
//    func animateBackButton() {
//        for currentSubView in self.subviews {
//            if (NSStringFromClass(object_getClass(currentSubView)) == "_UINavigationBarBackIndicatorView") {
//
//                (currentSubView as UIView).transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
//                (currentSubView as UIView).frame.origin.x = -currentSubView.frame.size.width
//
//                UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5,
//                                           options: UIViewAnimationOptions.allowAnimatedContent, animations: { () -> Void in
//                                            (currentSubView as UIView).transform = CGAffineTransform(rotationAngle: CGFloat(0))
//                                            (currentSubView as UIView).frame.origin.x = 10
//
//                }, completion: { (animaed: Bool) -> Void in
//                })
//            }
//        }
//    }
//
//    func initBar() {
//
//        self.tintColor = UIColor.white
//        self.barTintColor = RRNavigationBarParameter.sharedInstance.currentTheme.toColor().navigationBar
//        self.viewBarStatus = UIView(frame: CGRect(x: 0, y: -20,
//                                                      width: UIScreen.main.bounds.size.width, height: 20))
//
//
//        self.viewBarStatus.backgroundColor = RRNavigationBarParameter.sharedInstance.currentTheme.toColor().statusBar
//
//        self.addSubview(self.viewBarStatus)
//
//        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width,
//                                                    height: self.frame.size.height + 40))
//        self.titleLabel.textAlignment = NSTextAlignment.center
//        self.titleLabel.textColor = UIColor.white
//        self.titleLabel.text = ""
//        self.titleLabel.backgroundColor = self.barTintColor
//
//        self.addSubview(titleLabel)
//
//        self.backItem?.backBarButtonItem = nil
//
//        self.animateBackButton()
//        RRNavigationBarParameter.sharedInstance.currentNavigationBar = self
//    }
//
//
//    class func setTitle(_ title: String) {
//        var navigationBar = RRNavigationBarParameter.sharedInstance.currentNavigationBar
//        navigationBar?.titleLabel.text = title
//
//        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,
//                                   options: nil, animations: { () -> Void in
//                                    navigationBar.titleLabel.text = title
//                                    navigationBar.titleLabel.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width,
//                                                                                navigationBar.titleLabel.frame.size.height)
//        }) { (animated: Bool) -> Void in
//        }
//    }
//
////    override init() {
////        super.init()
////    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initBar()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//extension UIViewController {
//
//    override open func viewDidLoad() {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
//                                                                style: UIBarButtonItemStyle.bordered, target: nil, action: nil)
//    }
//    
//}
//
//extension UINavigationController: UINavigationBarDelegate {
//    
//    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
//        (self.navigationBar as! MaterialNavigationBar).animateBackButton()
//        (self.navigationBar as! MaterialNavigationBar).animateTitle()
//    }
//    
//    public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
//        (self.navigationBar as! MaterialNavigationBar).animationPop()
//        (self.navigationBar as! MaterialNavigationBar).animateTitle()
//    }
//}
