//
//  UnitTestingTests.swift
//  UnitTestingTests
//
//  Created by wangkan on 2016/10/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import XCTest
@testable import UnitTesting //可不加?!

class UnitTestingTests: XCTestCase {

    var viewController = ViewController()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDogMyCats() {
        if let viewController =
            (UIApplication.shared.delegate as? AppDelegate)?
                .window?.rootViewController as? ViewController {
            print(viewController)
        }
        let input = "cats"
        let output = "dogs"
        XCTAssertEqual(output,
                       self.viewController.dogMyCats(input),
                       "Failed to produce \(output) from \(input)")
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
    
}
