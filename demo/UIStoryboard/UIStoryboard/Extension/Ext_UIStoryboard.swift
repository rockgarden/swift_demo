//
//  UIStoryboard+Storyboards.swift
//  AHStoryboard
//
//  Created by Andyy Hope on 19/01/2016.
//  Copyright © 2016 Andyy Hope. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    

    
    
    

    
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
    
    /// EZSE: Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    public static var mainStoryboard: UIStoryboard? {
        let bundle = NSBundle.mainBundle()
        guard let name = bundle.objectForInfoDictionaryKey("UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    /// WK: Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class, Storyboard标识符必须使用类名作为标识符。
    public func instantiateVC<T>(identifier: T.Type) -> T? {
        let storyboardID = String(identifier)
        guard let vc = instantiateViewControllerWithIdentifier(storyboardID) as? T {
            return vc
        } else {
            fatalError("Couldn't instantiate view controller with identifier \(storyboardID)!")
        }
    }
    
    /// this Way must as T, 只能传基类UIViewController, 所以返回时要用 as 强转
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
    
}

//FIXME: 无法通过动态包调用
extension UIStoryboard {
    
    /// The uniform place where we state all the storyboard we have in our application
    
    enum Storyboard : String {
        case Main
        case News
        case Gallery
    }
    
    /// Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.type(of: init)(name: storyboard.rawValue, bundle: bundle)
    }
    
    convenience init(storyboardName: String, bundle: NSBundle? = nil) {
        self.init(name: storyboardName, bundle: bundle)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func getViewControllerFromStoryboard(viewController: String, storyboard: String) -> UIViewController {
        let sBoard = UIStoryboard(name: storyboard, bundle: nil)
        let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier(viewController)
        return vController
    }
}

extension UIViewController: StoryboardIdentifiable { }

/**
 *  identifiable
 */
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(self)
    }
}



