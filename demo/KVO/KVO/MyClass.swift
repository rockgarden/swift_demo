//
//  MyClass.swift
//  KVO
//
//  Created by wangkan on 16/8/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

/*
 Powering Key-Value Observing is the NSKeyValueObserving protocol. The documentation states that NSKeyValueObserving is an informal protocol. The NSObject root class conforms to the NSKeyValueObserving protocol and any class that inherits from NSObject is also assumed to conform to the protocol.
 Later in this tutorial, we find out what that means for developers. For now, remember that every class that is defined in the Foundation framework and that inherits from NSObject conforms to the NSKeyValueObserving protocol.
 What’s the deal with the UIKit framework? That is a great question. Apple is a bit vague about the implementation of KVO in UIKit. This is what the documentation has to say about KVO and UIKit.
 Swift 中使用 KVO 的前提条件:
 规则A. 观察者和被观察者都必须是 NSObject 的子类;both objects must derive from NSObject
 因为 OC 中KVO的实现基于 KVC 和 runtime 机制，只有是 NSObject 的子类才能利用这些特性.
 另外，这也意味着 Swift 中强大的 Struct，Enum 以及泛型都与 KVO 无缘了。
 规则B. 观察的属性需要使用 @dynamic 关键字修饰;
 @dynamic 修饰，表示该属性的存取都由 runtime 在运行时来决定，由于 Swift 基于效率的考量默认禁止了动态派发机制，因此要加上该修饰符来开启动态派发；
 除此之外，在 NSObject 子类中几乎没有属性默认是使用 @dynamic 修饰（该关键字最常见场景是在 Core Data 里， NSManagedObject 子类的属性都是 dynamic 的），所以若想对某个属性进行观察，还必须在当前的子类中 override 该属性，override 时，采用 super 的实现即可。
 
 OC 中要观察的属性通常可分为三类：attributes, to-one relationships, to-many relationships。
 对于attributes, to-one relationships而言，观察这两类属性，在 Swift 中除了要遵守规则A外，与在 OC 中无异。OC 中实例变量和属性是两种东西，后者通过KVC 方法来访问前者并可以触发 KVO，在 Swift 将实例变量和属性这两种概念合并了，直接改变属性或是通过 KVC 方法都可以触发 KVO。
 对于to-many relationships，通常我们需要更加细致的信息，比如希望在添加、删除或是替换了成员时也能得到 KVO 通知，在 OC 中我们需要通过实现Collection Accessor Patterns for To-Many Properties 并使用对应的方法才能触发对应的 KVO。但在 Swift 中，这些方法都无法触发 KVO ：Key-Value Observe in Swift not showing insertions and removals in arrays，对于 NSMutableArray, NSMutableSet 一类的属性，在 Swift 中，需要通过以下 KVC 方法来获取观察属性的集合代理(collection proxy)，通过该代理，直接使用常规的添加、删除和替换方法就能触发 KVO，这正是我们需要的结果。
 - mutableArrayValueForKey:
 - mutableArrayValueForKeyPath:
 - mutableSetValueForKey:
 - mutableSetValueForKeyPath:
 - mutableOrderedSetValueForKey:
 - mutableOrderedSetValueForKeyPath:
 KVO 中的其他特征，如属性依赖(Registering Dependent Keys)，自动/手动通知，在 Swift 中都是支持的。
 */

//MARK: - 案例1
/// 声明全局的用来辨别是哪一个被视察属性的变量
public var con = "ObserveValue"

class ObjectToObserve: NSObject {
    dynamic var value: Bool = false
}

class Observer: NSObject {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        print("-----------------start------------")
        print("I heard about the change!")
        print((object) as Any)
        // 类型判断 object 以 Any 传入 转为 AnyObject 不含有 value
        if object is ObjectToObserve {
            print((object as! ObjectToObserve).value(forKeyPath: keyPath!) as Any)
        }
        print(change as Any)
        print(context == &con) // aha
        let c = context?.assumingMemoryBound(to: String.self)
        //context?.bindMemory(to: UInt8.self, capacity: len)  //set buffer length is safer
        //let c = UnsafeMutablePointer<String>(context)
        let s = c?.pointee
        print(s as Any)
        print("-----------------end------------")
    }
}

//func SHA256(data: String) -> Data {
//    var hash = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
//    if let newData: Data = data.data(using: .utf8) {
//        _ = hash.withUnsafeMutableBytes {mutableBytes in
//            newData.withUnsafeBytes {bytes in
//                CC_SHA256(bytes, CC_LONG(newData.count), mutableBytes)
//            }
//        }
//    }
//    return hash
//}

//MARK: - 案例2

/// 声明1个全局的用来辨别是哪一个被视察属性的变量
private var myContext = "ObserveDate"

class ObjectToObserve1: NSObject {
    dynamic var myDate = Date()
    func updateDate() {
        myDate = Date()
    }
}

class Observer1: NSObject {
    
    var objectToObserve = ObjectToObserve1()
    
    override init() {
        super.init()
        // must [.Initial, .New] if only .New observeValueForKeyPath don't response
        objectToObserve.addObserver(self, forKeyPath: "myDate", options: [.initial, .new, .old], context: &myContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change , context == &myContext {
            print("**************************")
            print(keyPath as Any, "改变了")
            print(change)
            print(keyPath as Any, "oldValue:", change[NSKeyValueChangeKey.oldKey] as Any)
        }
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeKey.newKey] {
                print(keyPath as Any, "Date changed: newValue ＝ \(newValue)")
                print(object as Any)
                print(context as Any)
                print("**************************")
            }
        } else {
            // context 不相符 时才调用 super 
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        objectToObserve.removeObserver(self, forKeyPath: "myDate", context: &myContext)
    }
}

//MARK: - 案例3
private var Update = "ObserveArray"

class ArrayToObserve: NSObject {
    dynamic var children: NSMutableArray = NSMutableArray()
    // Get the KVO/KVC compatible array
    var childrenProxy = mutableArrayValue(forKey: "children")
    //FIXME: this class is not key value coding-compliant for the key children.
    func changeArray() {
        childrenProxy.add(NSNumber(value: 20 as Int)) // .Insertion
        childrenProxy.add(NSNumber(value: 30 as Int)) // .Insertion
        childrenProxy.removeObject(at: 1) // .Removal
    }
}

class ArrayObserver: NSObject {
    
    var arrayToObserve = ArrayToObserve()
    
    override init() {
        super.init()
        arrayToObserve.addObserver(self, forKeyPath: "children", options: [.initial, .new, .old], context: &Update)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        print("-----------------start------------")
        print("I heard about the array change!")
        guard let keyPath = keyPath else { return }
        if object is ArrayToObserve {
            print((object as! ArrayToObserve).value(forKeyPath: keyPath) as Any)
        }
        print(change as Any)
        print(context == &Update)
        // let c = UnsafeMutablePointer<String>(context) // context 为 string 而非 Int
        let c = context?.assumingMemoryBound(to: String.self)
        let s = c?.pointee
        print(s as Any)
        print("-----------------end------------")
    }
    
    deinit {
        arrayToObserve.removeObserver(self, forKeyPath: "myDate", context: &myContext)
    }
}

//MARK: - 案例4
/*
 属性观察器只在在初始化完成后触发，而且不限于 NSObject 的子类，Swift 中所有的 Class, Struct, Enum 都可以使用。
 Swift 内建的Array, Dictionary, Set 等都是值类型，对其内容的修改包括添加，删除，替换元素也会触发属性观察器。
 这很好理解，Array, Dictionary, Set 等值类型更改内容后，会复制新的内容给变量，变量指向的地址不同了。
 */
class StepCounter {
    /// 属性观察器: 相当于内建的 KVO 观察，只不过只限于对自身属性的观察。
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
