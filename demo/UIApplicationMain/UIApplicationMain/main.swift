
import UIKit
/// If you just want to designate your custom UIApplication class, why don't you use Info.plist? NSPrincipalClass | String | $(PRODUCT_MODULE_NAME).MobileUIApplication
UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(AppDelegate.self)
)


//NSApplicationMain
//Apply this attribute to a class to indicate that it is the application delegate. Using this attribute is equivalent to calling the NSApplicationMain(_:_:) function.
//在类上使用该特性表示该类是应用程序委托类，使用该特性与调用 NSApplicationMain(_:_:) 函数并且把该类的名字作为委托类的名字传递给函数的效果相同。
//If you do not use this attribute, supply a main.swift file with code at the top level that calls the NSApplicationMain(_:_:) function as follows:
//如果你不想使用这个特性，可以提供一个 main.swift 文件，并在代码顶层调用NSApplicationMain(_:_:) 函数,如下所示:
//import AppKit
//NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)


//UIApplicationMain
//Apply this attribute to a class to indicate that it is the application delegate. Using this attribute is equivalent to calling the UIApplicationMain function and passing this class’s name as the name of the delegate class.
//在类上使用该特性表示该类是应用程序委托类，使用该特性与调用 UIApplicationMain函数并且把该类的名字作为委托类的名字传递给函数的效果相同。
//If you do not use this attribute, supply a main.swift file with code at the top level that calls the UIApplicationMain(_:_:_:) function. For example, if your app uses a custom subclass of UIApplication as its principal class, call the UIApplicationMain(_:_:_:) function instead of using this attribute.
//如果你不想使用这个特性，可以提供一个 main.swift 文件，并在代码顶层调用 UIApplicationMain(_:_:_:) 函数。比如，如果你的应用程序使用一个继承于 UIApplication 的自定义子类作为主要类，你可以调用 UIApplicationMain(_:_:_:) 函数而不是使用该特性。

