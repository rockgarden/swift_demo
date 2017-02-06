//
//  PersonJSModel.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/2/6.
//  Copyright © 2017年 apple. All rights reserved.
//

import JavaScriptCore

@objc protocol PersonJSExports : JSExport {
    var firstName: String { get set }
    var lastName: String { get set }
    var birthYear: NSNumber? { get set }
    func getFullName() -> String
    /// create and return a new Person instance with `firstName` and `lastName`
    static func createWithFirstName(firstName: String, lastName: String) -> Person
}


@objc class Person : NSObject, PersonJSExports {
    // properties must be declared as `dynamic`
    dynamic var firstName: String
    dynamic var lastName: String
    dynamic var birthYear: NSNumber?
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    class func createWithFirstName(firstName: String, lastName: String) -> Person {
        return Person(firstName: firstName, lastName: lastName)
    }
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
