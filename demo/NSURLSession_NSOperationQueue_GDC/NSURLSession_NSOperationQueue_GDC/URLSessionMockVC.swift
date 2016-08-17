//
//  URLSessionMockVC.swift
//  NSURLSession_NSOperationQueue_GDC
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class URLSessionMockVC: UIViewController {
    // Arrage
    let apiClient = APIClientMock()
    
    // Act
    var catchedUser: User? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        apiClient.session = URLSessionMock(jsonDict: ["login": "dasdom", "id": 1234567])!
        apiClient.fetchProfileWithName("Foo") { (user, error) in
            self.catchedUser = user
        }
    }
}