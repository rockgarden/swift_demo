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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apiClient.session = URLSessionMock(jsonDict: ["login": "dasdom" as AnyObject, "id": 1234567 as AnyObject])!
        apiClient.fetchProfileWithName("Foo") { (user, error) in
            self.catchedUser = user
        }
    }
}
