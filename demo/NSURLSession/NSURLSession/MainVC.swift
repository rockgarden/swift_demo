//
//  main.swift
//  NSURLSessionDownload
//
//  Created by wangkan on 2016/10/15.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class MainVC: UIViewController, URLSessionDownloadDelegate {

    @IBOutlet var iv : UIImageView!
    private var task : URLSessionTask!
    private let which = 1 // 0 or 1
    private lazy var session : Foundation.URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
    }

    deinit {
        print("farewell")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)%")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
    }

    // this is the only required NSURLSessionDownloadDelegate method
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if which == 1 {
            let req = downloadTask.originalRequest!
            if let greeting = URLProtocol.property(forKey: "greeting", in: req) as? String {
                print("greeting: ", greeting)
            }
        }
        self.task = nil
        let response = downloadTask.response as! HTTPURLResponse
        let stat = response.statusCode
        print("status \(stat)")
        if stat != 200 {
            return
        }
        let d = try! Data(contentsOf: location)
        let im = UIImage(data:d)
        DispatchQueue.main.async {
            self.iv.image = im
        }
    }

    @IBAction func doElaborateHTTP (_ sender: AnyObject!) {
        if self.task != nil {
            return
        }
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let req = NSMutableURLRequest(url:url)
        if which == 1 { // show how to attach stuff to the request
            URLProtocol.setProperty("howdy", forKey:"greeting", in:req)
        }
        let task = self.session.downloadTask(with: req as URLRequest)
        self.task = task
        self.iv.image = nil
        task.resume()
    }

}

// MARK:- Base
extension MainVC {
    @IBAction func doSimpleHTTP (_ sender:AnyObject!) {
        self.iv.image = nil
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared
        let task = session.downloadTask(with: url, completionHandler: {
            loc, response, error in
            print("here")
            if error != nil {
                print(error ?? "unknown")
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            print("response status: \(status)")
            if status != 200 {
                print("oh well")
                return
            }
            let d = try! Data(contentsOf: loc!)
            let im = UIImage(data:d)
            DispatchQueue.main.async {
                self.iv.image = im
                print("done")
            }
        })
        task.resume()
    }
}
