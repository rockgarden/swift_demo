//
//  UIStoryboard+Storyboards.swift
//  AHStoryboard
//
//  Created by Andyy Hope on 19/01/2016.
//  Copyright © 2016 Andyy Hope. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    
    /// EZSE: Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    public static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    /// WK: Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class : Storyboard 标识符必须使用类名作为标识符.
    public func instantiateVC<T>(identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        guard let vc = instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(storyboardID) ")
        }
        return vc
    }
    
}

extension UIStoryboard {
    
    /// The uniform place where we state all the storyboard we have in our application, 统一的\中心全局化的 UIStoryboard 字符串标识符自定义Storyboard enum
    enum Storyboard : String {
        case Main
        case News
        case Gallery
    }
    
    
    /// Convenience Initializers
    /// 传 nil 给 bundle 参数，UIStroyboard 类会去 main bundle 中查找资源，所以给 bundle 参数传 nil 和传 NSBundle.mainBundle()
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    
    /// Class Functions
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    
    /// View Controller Instantiation from Generics
    /// Old Way:
    
    func instantiateViewController<T: UIViewController>(_: T.Type) -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
    
    /// New Way: UIViewController 或者是 UIViewController 的子类，在泛型声明中有一个 where 子句，它限制了这些类也需要遵循 StoryboardIdentifiable 协议
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

/// 辅助UIViewController扩展实现
extension UIViewController : StoryboardIdentifiable { }

/// 控制器标识协议: 只有一个静态变量 storyboardIdentifier
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

/// StoryboardIdentifiable 协议扩展
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

