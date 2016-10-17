//
//  APIClient.swift
//  URLSessionStubDemo
//
//  Created by dasdom on 04.01.16.
//  Copyright © 2016 dasdom. All rights reserved.
//

import Foundation
/// API Mock
class APIClientMock {
    /// 通过延迟加载属性注入依赖
    lazy var session = URLSession.shared as DHURLSession
    
    func fetchProfileWithName(_ name: String, completion: @escaping (_ user: User?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(name)") else { fatalError() }
        session.dataTaskWithURL(url) { (data, response, error) -> Void in
            if let data = data {
                do {
                    let rawDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                    
                    if let name = rawDict["login"] as? String,
                        let id = rawDict["id"] as? Int {
                        let user = User(name: name, id: id)
                        completion(user, nil)
                    }
                } catch {
                    completion(nil, error)
                }
            }
            }.resume()
    }
}
