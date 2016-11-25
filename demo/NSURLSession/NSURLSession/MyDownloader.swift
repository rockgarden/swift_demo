

import UIKit

let isMain = false // try false to move delegate methods onto a background thread

class Wrapper<T> {
	let p: T
	init(_ p: T) { self.p = p }
}

// must be @objc_block or we won't get memory management on background thread
typealias MyDownloaderCompletionVoid = @convention(block)(URL!) -> ()
typealias MyDownloaderCompletion = (URL!) -> ()

class MyDownloader: NSObject {
	let config: URLSessionConfiguration
	let q = OperationQueue()
	let main = false // try false to move delegate methods onto a background thread
	lazy var session: URLSession = {
		let queue = (self.main ? .main : self.q)
		return URLSession(configuration: self.config, delegate: self, delegateQueue: queue)
	}() //若delegate: self 改为 MyDownloaderDelegate()

	init(configuration config: URLSessionConfiguration) {
		self.config = config
		super.init()
	}

    /*
     Swift 3.0 中方法的返回值必须有接收否则会报警告
     1. @discardableResult 告诉编译器此方法可以不用接收返回值
     2. 使用"_"接收无用返回值
     */
	func download(_ s: String, completionHandler ch: MyDownloaderCompletionVoid) -> URLSessionTask {
		let url = URL(string: s)!
		let req = NSMutableURLRequest(url: url)
		URLProtocol.setProperty(Wrapper(ch), forKey: "ch", in: req)
		let task = self.session.downloadTask(with: req as URLRequest)
		task.resume()
		return task
	}

    @discardableResult
    func download(url: URL, completionHandler ch : @escaping MyDownloaderCompletion) -> URLSessionTask {
        let req = NSMutableURLRequest(url: url)
        URLProtocol.setProperty(ch as Any, forKey:"ch", in: req)
        let task = self.session.downloadTask(with: req as URLRequest)
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

    private class MyDownloaderDelegate : NSObject, URLSessionDownloadDelegate {

        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
            print("downloaded \(100*writ/exp)%")
        }

        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            // unused in this example
            print("did resume")
        }

        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo url: URL) {
            let req = downloadTask.originalRequest!
            let response = downloadTask.response as! HTTPURLResponse
            let stat = response.statusCode
            print("status \(stat)")
            if stat == 200 {
                print("download \(req.url!.lastPathComponent)")
            }
            let ch = URLProtocol.property(forKey:"ch", in:req) as! MyDownloaderCompletion
            if isMain {
                ch(url)
            } else {
                DispatchQueue.main.sync {
                    ch(url)
                }
            }
        }

        deinit {
            print("farewell from Delegate")
        }
    }

}

extension MyDownloader: URLSessionDownloadDelegate {

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
		print("downloaded \(100*writ/exp)%")
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		// unused in this example
		print("did resume")
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		let req = downloadTask.originalRequest!

        let response = downloadTask.response as! HTTPURLResponse
        let stat = response.statusCode
        print("status \(stat)")
        if stat == 200 {
            print("download \(req.url!.lastPathComponent)")
        }

        let ch = URLProtocol.property(forKey:"ch", in:req) as! MyDownloaderCompletion

        /// when Use "_ = self.downloader.download(s)"
        //let ch2: AnyObject = URLProtocol.property(forKey: "ch", in: req)! as AnyObject
        //let ch = (ch2 as! Wrapper).p as MyDownloaderCompletionVoid
        if self.main {
            ch(location)
        } else {
            DispatchQueue.main.sync {
                ch(location)
            }
        }
	}
}
