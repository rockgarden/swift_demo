

import UIKit

class Wrapper<T> {
	let p: T
	init(_ p: T) { self.p = p }
}

// must be @objc_block or we won't get memory management on background thread
typealias MyDownloaderCompletion = @convention(block)(URL!) -> ()

class MyDownloader: NSObject, URLSessionDownloadDelegate {
	let config: URLSessionConfiguration
	let q = OperationQueue()
	let main = true // try false to move delegate methods onto a background thread
	lazy var session: Foundation.URLSession = {
		let queue = (self.main ? OperationQueue.main : self.q)
		return Foundation.URLSession(configuration: self.config, delegate: self, delegateQueue: queue)
	}()

	init(configuration config: URLSessionConfiguration) {
		self.config = config
		super.init()
	}

    /*
     Swift 3.0 中方法的返回值必须有接收否则会报警告
     1. @discardableResult 告诉编译器此方法可以不用接收返回值
     2. 使用"_"接收无用返回值
     */
	func download(_ s: String, completionHandler ch: MyDownloaderCompletion) -> URLSessionTask {
		let url = URL(string: s)!
		let req = NSMutableURLRequest(url: url)
		URLProtocol.setProperty(Wrapper(ch), forKey: "ch", in: req)
		let task = self.session.downloadTask(with: req as URLRequest)
		task.resume()
		return task
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
		print("downloaded \(100*writ/exp)%")
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
		// unused in this example
		print("did resume")
	}

	func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		let req = downloadTask.originalRequest!
		let ch: AnyObject = URLProtocol.property(forKey: "ch", in: req)! as AnyObject
		let response = downloadTask.response as! HTTPURLResponse
		let stat = response.statusCode
		print("status \(stat)")
		var url: URL! = nil
		if stat == 200 {
			url = location
			print("download \(req.url!.lastPathComponent)")
		}
		let ch2 = (ch as! Wrapper).p as MyDownloaderCompletion
		if self.main {
			ch2(url)
		} else {
			DispatchQueue.main.sync {
				ch2(url)
			}
		}
	}

	func cancelAllTasks() {
		self.session.invalidateAndCancel()
	}

	deinit {
		print("farewell from MyDownloader")
	}

}

