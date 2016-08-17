//
//  APIClientTests.swift
//  URLSessionStubDemo
//
//  Created by dasdom on 04.01.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import UIKit
import XCTest
@testable import NSURLSession_NSOperationQueue_GDC

class APIClientTests: XCTestCase {
    
    //  var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        
        //    apiClient = APIClient()
    }
    
    func testFetchingProfile_ReturnsPopulatedUser() {
        let responseExpectation = expectationWithDescription("User")
        // Arrage
        let apiClient = APIClientMock()
        apiClient.session = URLSessionMock(jsonDict: ["login": "dasdom", "id": 1234567])!
        
        // Act
        var catchedUser: User? = nil
        apiClient.fetchProfileWithName("Foo") { (user, error) in
            catchedUser = user
            responseExpectation.fulfill()
        }
        
        // Assert
        waitForExpectationsWithTimeout(1) { (error) in
            let expectedUser = User(name: "dasdom", id: 1234567)
            debugPrint(catchedUser,expectedUser)
            XCTAssertEqual(catchedUser, expectedUser)
        }
    }
    
}

