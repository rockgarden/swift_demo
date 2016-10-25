//
//  Configuration.swift
//  KVO
//
//  Created by Bart Jacobs on 15/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import Foundation

class Configuration: NSObject {

    // MARK: - Properties
    /// Objective-C and Dynamic Dispatch
    dynamic var createdAt = Date()
    dynamic var updatedAt = Date()

}

//What Does the Dynamic Keyword Mean in Swift 3
//
//Written by Bart JacobsOctober 15, 2016SWIFT
//You probably know that the Swift language defines a number of attributes, such as objc, escaping, and available. It also defines a range of declaration modifiers.
//
//As the name implies, a declaration modifier modifies a declaration. For example, by marking a class declaration with the final keyword, we inform the compiler that the class cannot be subclassed. This allows the compiler to make a number of optimizations to increase performance.
//
//One other declaration modifier you may have come across is dynamic. 
//Swift and Objective-C Interoperability
//
//Even though Swift and Objective-C play well together, not every feature of Objective-C is available in Swift. Objective-C is a powerful language and much of that power is the result of the Objective-C runtime. Dynamic dispatch, for example, is one of the features that make Objective-C as dynamic as it is.
//
//Dynamic what? Dynamic dispatch. It simply means that the Objective-C runtime decides at runtime which implementation of a particular method or function it needs to invoke. For example, if a subclass overrides a method of its superclass, dynamic dispatch figures out which implementation of the method needs to be invoked, that of the subclass or that of the parent class. This is a very powerful concept.
//
//Swift uses the Swift runtime whenever possible. The result is that it can make a number of optimizations. While Objective-C solely relies on dynamic dispatch, Swift only opts for dynamic dispatch if it has no other choice. If the compiler can figure out at compile time which implementation of a method it needs to choose, it wins a few nanoseconds by opting out of dynamic dispatch.
//
//Why Do I Need to Know This?
//
//If you really want to understand what the dynamic declaration modifier means, then you need to understand the above.
//
//How the Swift runtime works isn’t the topic of this tutorial. But you need to understand that the Swift runtime chooses other options, such as static and virtual dispatch, over dynamic dispatch whenever possible. It does this to increase performance.
//
//Static and virtual dispatch are much faster than dynamic dispatch. Even though we are talking nanoseconds, the net result can be dramatic. If you are wondering, inlined access beats static and virtual dispatch hands down.
//
//As you can imagine, bypassing dynamic dispatch has some drawbacks. Dynamic dispatch is one of the ingredients that make the Objective-C runtime as powerful as it is.
//
//Right. But I am only using Swift in my project. Are you? The frameworks that power iOS, tvOS, macOS, and watchOS applications are written in Objective-C. And many features we have come accustomed to are only possible because of the dynamic Objective-C runtime, including Core Data and Key-Value Observing.
//
//Dynamic Dispatch
//
//This is a long explanation for a simple answer. By applying the dynamic declaration modifier to a member of a class, you tell the compiler that dynamic dispatch should be used to access that member.
//
//By prefixing a declaration with the dynamic keyword, the declaration is implicitly marked with the objc attribute. The objc attribute makes the declaration available in Objective-C, which is a requirement for it to be dispatched by the Objective-C runtime.
//
//You should now understand why the lengthy introduction was important for understanding the meaning of the dynamic keyword.
//
//Classes Only
//
//It goes without saying that the dynamic declaration modifier can only be used for members of a class. Structures and enumerations don’t support inheritance, which means the runtime doesn’t have to figure out which implementation it needs to use.
//
//When to Use It
//
//The dynamic declaration modifier is required whenever you need to make use of Objective-C’s dynamism. Tomorrow, I show you an example that demonstrates the use of the dynamic declaration modifier to enable Key-Value Observing for an NSObject subclass.
