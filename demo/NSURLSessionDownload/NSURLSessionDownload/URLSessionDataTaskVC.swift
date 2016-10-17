

import UIKit

class URLSessionDataTaskVC: UIViewController, URLSessionDataDelegate {

    @IBOutlet var iv : UIImageView!
    var task : URLSessionDataTask!
    var data = NSMutableData()

    lazy var session : Foundation.URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()

    @IBAction func doHTTP (_ sender:AnyObject!) {
        if self.task != nil {
            return
        }
        let s = "http://www.apeth.net/matt/images/phoenixnewest.jpg"
        let url = URL(string:s)!
        let req = NSMutableURLRequest(url: url)
        let task = self.session.dataTask(with: req as URLRequest) // *
        self.task = task
        self.iv.image = nil
        self.data.length = 0 // *
        task.resume()
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("received \(data.count) bytes of data")
        // do something with the data here!
        self.data.append(data)
    }


    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
        self.task = nil
        if error == nil {
            self.iv.image = UIImage(data:self.data as Data)
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
