//
//  Examples.swift
//  KVO
//
//  Created by wangkan on 16/8/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

/*
 Value Observing and Events for Swift
 https://github.com/slazyk/Observable-Swift
 Swift lacks the powerful Key Value Observing (KVO) from Objective-C. But thanks to closures, generics and property observers, in some cases it allows for far more elegant observing. You have to be explicit about what can be observed, though.

 Overview

 Observable-Swift is a Swift library for value observing (via explicit usage of Observable<T>) and subscribable events (also explicit, using Event<T>). While it is not exactly "KVO for Swift" (it is explicit, there are no "Keys", ...) it is a catchy name so you can call it that if you want. The library is still under development, just as Swift is. Any contributions, both in terms of suggestions/ideas or actual code are welcome.

 Observable-Swift is brought to you by Leszek Ślażyński (slazyk), you can follow me on twitter and github. Also check out SINQ my other Swift library that makes working with collections a breeze.

 Observables

 Using Observable<T> and related classes you can implement wide range of patterns using value observing. Some of the features:

 observable variables and properties
 chaining of observables (a.k.a. key path observing)
 short readable syntax using +=, -=, <-/^=, ^
 alternative syntax for those who dislike custom operators
 handlers for before or after the change
 handlers for { oldValue:, newValue: } (oldValue, newValue) or (newValue)
 adding multiple handlers per observable
 removing / invalidating handlers
 handlers tied to observer lifetime
 observable mutations of value types (structs, tuples, ...)
 conversions from observables to underlying type (not available since Swift Beta 6)
 observables combining other observables
 observables as value types or reference types
 ...
 Events

 Sometimes, you don’t want to observe for value change, but other significant events. Under the hood Observable<T> uses beforeChange and afterChange of EventReference<ValueChange<T>>. You can, however, use Event<T> or EventReference<T> directly and implement other events too.
 */



