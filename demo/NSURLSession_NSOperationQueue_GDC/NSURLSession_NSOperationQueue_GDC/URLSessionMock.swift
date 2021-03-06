//
//  DHURLSessionProtocol.swift
//  URLSessionStubDemo
//
//  Created by dasdom on 05.01.16.
//  Copyright © 2016 dasdom. All rights reserved.
//
//  伪造 web API 的响应

import Foundation
/**
 *  NSURLSession协议
 */
@objc public protocol DHURLSession {
    @objc optional func dataTaskWithURL(_ url: URL,
                         completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTask
    @objc optional func dataTaskWithRequest(_ request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTask
}

//extension URLSession: DHURLSession { }

/// NSURLSession替换类
public final class URLSessionMock: DHURLSession {

    var url: URL?
    var request: URLRequest?
    fileprivate let dataTaskMock: URLSessionDataTaskMock
    
    public convenience init?(jsonDict: [String: AnyObject], response: URLResponse? = nil, error: NSError? = nil) {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return nil }
        self.init(data: data, response: response, error: error)
    }
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: NSError? = nil) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error)
    }
    
    public func dataTaskWithURL(_ url: URL,
                                completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }
    
    public func dataTaskWithRequest(_ request: URLRequest,
                                    completionHandler: @escaping (Data?, URLResponse?, NSError?) -> Void) -> URLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    final fileprivate class URLSessionDataTaskMock: URLSessionDataTask {
        
        typealias CompletionHandler = (Data?, URLResponse?, NSError?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, NSError?)?
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
            }
        }
    }
}
