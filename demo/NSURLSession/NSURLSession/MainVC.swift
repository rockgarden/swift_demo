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
    var dataTask : URLSessionDataTask!
    var data = Data()
    private let which = 1 // 0 or 1
    fileprivate lazy var session : URLSession = {
        /// ephemeral: 临时session配置，与默认配置相比，这个配置不会将缓存、cookie等存在本地，只会存在内存里，所以当程序退出时，所有的数据都会消失
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
        self.dataTask = nil
    }

    deinit {
        print("farewell")
    }

    @IBAction func doElaborateHTTP (_ sender: Any!) {
        guard self.task == nil else {return}
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string: s)!
        self.iv.image = nil
        switch which {
        case 0:
            let req = URLRequest(url: url)
            let task = self.session.downloadTask(with: req)
            self.task = task
            task.resume()
        case 1:
            let req = NSMutableURLRequest(url: url)
            /// show how to attach stuff to the
            URLProtocol.setProperty("howdy", forKey: "greeting", in: req)
            let task = self.session.downloadTask(with: req as URLRequest)
            self.task = task
            task.resume()
        default: break
        }
    }

    // TODO: test URLSession URLRequest
    @IBAction func normalRequest(_ sender: Any) {
        let urlString = "http://112.13.167.70:80/WebServices/Mobile.asmx/Login_New_V3?v_login_name=lixue&v_password=e2f2b3670cf60c4435b17f77853886f8&v_version=debug&v_device_type=2"
        (sender as? UIButton)?.isEnabled = false
        synchronousRequest(urlString, successHandler: {_ in
            defer {
                DispatchQueue.main.async {
                    (sender as? UIButton)?.isEnabled = true
                }
            }
        })
    }

    func synchronousRequest(_ urlString: String, timeout: Double = 10, successHandler: @escaping (_ result: [AnyHashable: Any]) -> Void, failureHandler: @escaping (String)->Void = {_ in}) {

        var errorInfo: String!

        //创建URL对象
        guard let url = URL(string: urlString) else {
            errorInfo = NSLocalizedString("URL异常", comment: "Failed to init  URL")
            failureHandler(errorInfo)
            return
        }

        //创建请求对象
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in

            guard (error != nil) else {
                debugPrint(error!)
                errorInfo = error?.localizedDescription
                failureHandler(errorInfo)
                return
            }

            // If we don't get data back, alert the user.
            //
            guard let d = data else {
                errorInfo = NSLocalizedString("Could not get data from the remote server", comment: "Failed to connect to server")
                debugPrint(errorInfo)
                failureHandler(errorInfo)
                return
            }

            // If we get data but can't unpack it as JSON, alert the user.
            //
            let jsonDictionary: [AnyHashable: Any]

            do {
                //let str = String(data: data!, encoding: String.Encoding.utf8)
                //debugPrint(str!)
                /// .allowFragments: 指定解析器应该允许不是NSArray或NSDictionary的实例的顶级对象。
                jsonDictionary = try JSONSerialization.jsonObject(with: d, options: [.allowFragments]) as! [AnyHashable: Any]
                successHandler(jsonDictionary)
                debugPrint(jsonDictionary)
            }
            catch {
                errorInfo = NSLocalizedString("Could not analyze data", comment: "Failed to unpack JSON")
                debugPrint(errorInfo)
                failureHandler(errorInfo)
                return
            }
            semaphore.signal()
        }) as URLSessionTask

        /// 使用resume方法启动任务
        dataTask.resume()

        let start = Date().timeIntervalSince1970
        /// DispatchTime.distantFuture 在遥远的未来返回一个时间,您可以将此值传递给调度工作以使系统无限期地等待特定事件发生或满足条件的方法。
        _ = semaphore.wait(timeout: DispatchTime.now()+timeout)
        debugPrint("Timeline Request \(String(describing: url)): ",Date().timeIntervalSince1970 - start)
        debugPrint("数据加载完毕！")
    }


    // MARK: URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)%")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.task = nil
        print("completed: error: \(String(describing: error))")
        self.dataTask = nil
        if error == nil {
            DispatchQueue.main.async {
                self.iv.image = UIImage(data:self.data)
            }
        }
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
        let status = response.statusCode
        print("response status \(stat)")
        guard status == 200 else {
            print(status)
            return
        }
        if let d = try? Data(contentsOf: location) {
            let im = UIImage(data:d)
            DispatchQueue.main.async {
                self.iv.image = im
            }
        }
        /// 如果URLSessionConfiguration == default, 则要删除下载过程中用来存储 resumeData 的临时文件给.
    }

}


// URLSessionDataDelegate 继承 URLSessionTaskDelegate
extension MainVC: URLSessionDataDelegate {

    @IBAction func doHTTP (_ sender: Any!) {
        if self.dataTask != nil {
            return
        }
        self.iv.image = nil
        self.data.count = 0 // *
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let req = URLRequest(url:url)
        let task = self.session.dataTask(with:req) // *
        self.dataTask = task
        task.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // do something with the data here!
        self.data.append(data)
        print("received \(data.count) bytes of data; total \(self.data.count)")
    }

}

// MARK: - Base
extension MainVC {

    @IBAction func doSimpleHTTP (_ sender: Any!) {
        self.iv.image = nil
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let session = URLSession.shared
        let task = session.downloadTask(with: url) {
            loc, response, err in
            print("here")
            guard err == nil else {
                print(err as Any)
                return
            }
            let status = (response as! HTTPURLResponse).statusCode
            print("response status: \(status)")
            guard status == 200 else {
                print(status)
                return
            }
            if let loc = loc, let d = try? Data(contentsOf:loc) {
                let im = UIImage(data: d)
                DispatchQueue.main.async {
                    self.iv.image = im
                    print("done")
                }
            }
        }
        // 展示语法 just demonstrating syntax
        task.priority = URLSessionTask.defaultPriority
        task.resume()
    }

    // just showing some "return a value" strategies 策略
    // this can never work
    func doSomeNetworking() -> UIImage? {
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string: s)!
        var image : UIImage? = nil
        let session = URLSession.shared
        let task = session.downloadTask(with: url) {
            loc, resp, err in
            if let loc = loc, let d = try? Data(contentsOf: loc) {
                let im = UIImage(data:d)
                image = im
            }
        }
        task.resume()
        return image
    }

    /// get image 与 show image 分离
    func doSomeNetworking2(callBackWithImage: @escaping (UIImage?) -> Void) {
        let s = "https://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string: s)!
        let session = URLSession.shared
        let task = session.downloadTask(with: url) {
            loc, resp, err in
            if let loc = loc, let d = try? Data(contentsOf: loc) {
                let im = UIImage(data:d)
                callBackWithImage(im)
            }
        }
        task.resume()
    }

    @IBAction func doSimpleHTTPandReturn() {
        doSomeNetworking2 { im in
            DispatchQueue.main.async {
                self.iv.image = im
            }
        }
    }

}
