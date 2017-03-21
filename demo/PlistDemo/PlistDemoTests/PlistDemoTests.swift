//
//  PlistDemoTests.swift
//  PlistDemoTests
//
//  Created by wangkan on 2017/3/20.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import XCTest

@testable import SwiftyConfiguration

private extension Keys {
    
    static let string = Key<String>("string")
    static let url    = Key<URL>("url")
    static let number = Key<NSNumber>("number")
    static let int    = Key<Int>("int")
    static let float  = Key<Float>("float")
    static let double = Key<Double>("double")
    static let date   = Key<Date>("date")
    static let bool   = Key<Bool>("bool")
    
    static let array      = Key<[Any]>("array")
    static let innerInt   = Key<Int>("array.0")
    static let innerArray = Key<String>("array.1.0")
    
    static let dictionary  = Key<[String : String]>("dictionary")
    static let innerString = Key<String>("dictionary.innerString")
}

class PlistDemoTests: XCTestCase {
    
    private lazy var plistPath: String = {
        return Bundle(for: type(of: self)).path(forResource: "Configuration", ofType: "plist")!
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetValue() {
        let config = Configuration(plistPath: plistPath)!
        
        XCTAssertTrue("hoge" == config.get(.string)!)
        XCTAssertTrue(URL(string: "https://github.com/ykyouhei/SwiftyConfiguration")! == config.get(.url)!)
        XCTAssertTrue(NSNumber(value: 0 as Int32) == config.get(.number)!)
        XCTAssertTrue(1 == config.get(.int)!)
        XCTAssertTrue(1.1 == config.get(.float)!)
        XCTAssertTrue(3.14 == config.get(.double)!)
        XCTAssertTrue(config.get(.bool)!)
        XCTAssertTrue(Date(timeIntervalSince1970: 0).timeIntervalSince1970 == config.get(.date)!.timeIntervalSince1970)
        
        let array = config.get(.array)!
        XCTAssertTrue(array[0] as! Int == 0)
        XCTAssertTrue(array[1] as! [NSString] == ["array.1.0"])
        XCTAssertTrue(0 == config.get(.innerInt)!)
        XCTAssertTrue("array.1.0" == config.get(.innerArray)!)
        
        XCTAssertTrue(["innerString" : "moge"] == config.get(.dictionary)!)
        XCTAssertTrue("moge" == config.get(.innerString)!)
    }
    
}
