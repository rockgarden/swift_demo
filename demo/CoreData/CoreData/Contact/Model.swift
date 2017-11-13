//
//  Model.swift
//  Second
//
//  Created by Stan on 2017-11-05.
//  Copyright © 2017 Stan Guo. All rights reserved.
//
/**
 Binary Data
 顾名思义，就是二进制数据。对应到OC中就是NSData，Swift里面就是Data数据类型。
 可把图片变成Binary Data进行存储。
 Decimal
 Decimal为SQL Server、MySql等数据库的一种数据类型，不属于浮点数类型，可以在定义时划定整数部分以及小数部分的位数。使用精确小数类型不仅能够保证数据计算更为精确，还可以节省储存空间。
 Decimal(n,m)表示数值中共有n位数，其中整数n-m位，小数m位。
 
 Transformable
 Transformable Attributes
 There's a new "transformable" type for NSManagedObject attributes that allows you more easily support attribute types that Core Data doesn't support natively. You access an attribute as a non-standard type, but behind the scenes Core Data uses an instance of NSValueTransformer to convert the attribute to and from an instance of NSData. Core Data then stores the data instance to the persistent store.
 If you don’t specify a transformer, transformable attributes to use keyed archiving (NSKeyedUnarchiveFromDataTransformerName).
 For more details, see Non-Standard Persistent Attributes.
 说到底，这是一个非标准的类型。在中文中，非典型技术宅胖其实觉得翻译成“其他”类型更贴切。
 需要注意的地方就是，数据类型要遵守NSCoding协议。
 */
/*
 CoreData的基本读取操作
 1.1 获取CoreData已经保存数据的五个步骤
 获取总代理和托管对象总管
 从Entity获取一个fetchRequest
 根据fetchRequest，从managedContext中查询数据
 保存。保存过程中可能会出错，要做一下处理。
 添加到数组中
 1.2 基本存储
 获取总代理和托管对象总管
 建立一个Entity
 保存内容
 保存Entity到托管对象。如果保存失败，进行处理
 保存到数组中，更新UI
 2.2 多种类型的存储
 let imgData = from.value(forKey: "avatar") as? Data
 let isRelative = from.value(forKey: "isRelative") as? Bool
 let name = from.value(forKey: "name") as? String
 let updateTime = from.value(forKey: "updateTime") as? Date
 let viewTimes = from.value(forKey: "viewTimes") as? Int64
 let mobile = from.value(forKey: "mobile") as? String
 3. Codable
 咱们通讯录里面通常的做法都会把一个用户的信息全部放在一个Model里面，然后只需要把Model存储到库里面就好了。这个怎么做呢？
 在OC时代，当需要将一个对象持久化时，需要把这个对象序列化，往常的做法是实现 NSCoding 协议。
 写过的人应该都知道实现 NSCoding 协议的代码写起来很痛苦，特别想哭，尤其是当属性非常多的时候。
 Swift 4 中引入了 Codable 帮我们解决了这个问题。
 如果我们想把User 对象的实例持久化，只需要让 User 遵守 Codable 协议即可，Language 中不用写别的代码。这样就可以直接把Userencode成JSON啦。
 */
import Foundation

struct User: Codable {
    var avatarImg: Data
    var isRelative: Bool
    var name: String
    var updateTime: Date
    var viewTimes: Int64
    var mobile: String     
}

