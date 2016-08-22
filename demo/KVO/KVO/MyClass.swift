//
//  MyClass.swift
//  KVO
//
//  Created by wangkan on 16/8/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

/*
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

class MyClass1: NSObject {
	// absolutely crucial to say "dynamic" or this won't work
	dynamic var value: Bool = false
}

class MyClass2: NSObject {
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
		print("I heard about the change!")
		if let keyPath = keyPath {
			print(object?.valueForKeyPath?(keyPath))
		}
		print(change)
		print(context == &con) // aha
		let c = UnsafeMutablePointer<String>(context)
		let s = c.memory
		print(s)
	}
}

//MARK: - 案例2
class MyObjectToObserve: NSObject {
	dynamic var myDate = NSDate()
    override init() {
        super.init()
        print(myDate)
    }
	func updateDate() {
		myDate = NSDate()
        print(myDate)
	}
}

/// 声明1个全局的用来辨别是哪一个被视察属性的变量
private var myContext = 0

class MyObserver: NSObject {

	var objectToObserve = MyObjectToObserve()

	override init() {
		super.init()
		objectToObserve.addObserver(self, forKeyPath: "myDate", options: .New, context: &myContext)
	}

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print(context == &myContext)
		if context == &myContext {
			if let newValue = change?[NSKeyValueChangeNewKey] {
				print("Date changed: \(newValue)")
			}
		} else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}

	deinit {
		objectToObserve.removeObserver(self, forKeyPath: "myDate", context: &myContext)
	}
}

//MARK: - 案例3
private var Update = 0

class ArrayToObserve: NSObject {
	dynamic var childrenProxy = mutableArrayValueForKey("children")

	func changeArray() {
		childrenProxy.addObject(NSNumber(integer: 20)) // .Insertion
		childrenProxy.addObject(NSNumber(integer: 30)) // .Insertion
		childrenProxy.removeObjectAtIndex(1) // .Removal
	}
}

class ArrayObserver: NSObject {
	var arrayToObserve = ArrayToObserve()

	override init() {
		super.init()
		arrayToObserve.addObserver(self, forKeyPath: "children", options: .New, context: &Update)
	}

	dynamic var children: NSMutableArray = NSMutableArray()

	func ArrayChange(aNotification: NSNotification) {
		addObserver(self,
			forKeyPath: "children1",
			options: [.New, .Old],
			context: &Update)

		// Get the KVO/KVC compatible array
		var childrenProxy1 = mutableArrayValueForKey("children1")
		childrenProxy1.addObject(NSNumber(integer: 20)) // .Insertion
		childrenProxy1.addObject(NSNumber(integer: 30)) // .Insertion
		childrenProxy1.removeObjectAtIndex(1) // .Removal
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