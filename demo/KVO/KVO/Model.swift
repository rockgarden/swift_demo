//
//  Model.swift
//  KVO
//
//  Created by wangkan on 16/8/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

class People: NSObject{
    dynamic var name: String
    dynamic var age: Int
    dynamic var sex: Int
    var address: Address?
    
    init(name: String, age: Int, sex: Int, address: Address){
        self.name = name
        self.age = age
        self.sex = sex
        self.address = address
        
    }
}

class Address: NSObject {
    
}