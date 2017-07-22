//  TODO: 断点下载 创建 task 的时候 NSData * downloadedData = ... // 上一次中断下载时候，保存的临时文件。 httpTask = [httpSession downloadTaskWithResumeData: downloadedData]; 中断 task [httpTask cancelByProducingResumeData :^( NSData *resumeData) { // 把 resumeData 存到了一个临时文件上，以便 app 完全关闭后，也能继续断点下载。 }]; 在下载完成的时候 -( void ) URLSession:( NSURLSession *)session downloadTask:( NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:( NSURL *)location { 记得把下载过程中用来存储 resumeData 的临时文件给删除掉。 }

import UIKit

class URLSessionDataTaskVC: UIViewController, URLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var task : URLSessionDataTask!
    var data = Data()

    lazy var session : URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()

    @IBAction func doHTTP (_ sender: AnyObject!) {
        guard self.task == nil else {return}
        self.iv.image = nil
        self.data.count = 0 //if data is NSMutableData() use data.length
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string: s)!
        let req = URLRequest(url: url)
        let task = self.session.dataTask(with: req) // *
        self.task = task
        task.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("received \(data.count) bytes of data; total \(self.data.count)")
        // do something with the data here!
        self.data.append(data)
    }


    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(String(describing: error))")
        self.task = nil
        if error == nil {
            DispatchQueue.main.async {
                self.iv.image = UIImage(data:self.data)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.finishTasksAndInvalidate()
        self.task = nil
    }

    deinit {
        print("farewell")
    }

}
