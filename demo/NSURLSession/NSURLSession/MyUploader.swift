//
//  MyUploader.swift
//  NSURLSession
//
//  Created by wangkan on 2016/11/22.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

// must be @objc_block or we won't get memory management on background thread
typealias MyUploaderCompletionVoid = @convention(block)(URL!) -> ()
typealias MyUploaderCompletion = (URL!) -> ()

class MyUploader: NSObject {
    
    let config: URLSessionConfiguration
    let q = OperationQueue()
    let main = true // try false to move delegate methods onto a background thread
    lazy var session: URLSession = {
        let queue = (self.main ? .main : self.q)
        return URLSession(configuration: self.config, delegate: self, delegateQueue: queue)
    }()
    var responseData = NSMutableData()
    
    init(configuration config: URLSessionConfiguration) {
        self.config = config
        super.init()
    }
    
    /*
     Swift 3.0 中方法的返回值必须有接收否则会报警告
     1. @discardableResult 告诉编译器此方法可以不用接收返回值
     2. 使用"_"接收无用返回值
     */
    func upload(_ s: String, data: Data, completionHandler ch: MyUploaderCompletionVoid) -> URLSessionTask {
        let url = URL(string: s)!
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        URLProtocol.setProperty(Wrapper(ch), forKey: "ch", in: req)
        let task = self.session.uploadTask(with: req as URLRequest, from: data)
        task.resume()
        return task
    }
    
    @discardableResult
    func upload(url: URL, data: Data, completionHandler ch : @escaping MyUploaderCompletion) -> URLSessionTask {
        let req = NSMutableURLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        URLProtocol.setProperty(ch as Any, forKey:"ch", in: req)
        let task = self.session.uploadTask(with: req as URLRequest, from: data)
        task.resume()
        return task
    }
    
    func cancelAllTasks() {
        self.session.invalidateAndCancel()
    }
    
    deinit {
        print("farewell from MyDownloader")
        cancelAllTasks()
    }
}

extension MyUploader: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("session \(session) occurred error \(error?.localizedDescription)")
        } else {
            print("session \(session) upload completed, response: \(NSString(data: responseData as Data, encoding: String.Encoding.utf8.rawValue))")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent sent: Int64, totalBytesExpectedToSend exp: Int64) {
        print("session \(session) uploaded \(sent * 100/exp)%.")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("session \(session), received response \(response)")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data)
    }
    
}




