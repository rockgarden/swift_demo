

import UIKit

class MyDownloaderTableVC: UITableViewController, UITableViewDataSourcePrefetching {

	lazy var configuration: URLSessionConfiguration = {
		let config = URLSessionConfiguration.ephemeral
		config.allowsCellularAccess = true
		config.urlCache = nil
		return config
	}()

	lazy var downloader: MyDownloader = {
		return MyDownloader(configuration: self.configuration)
	}()

	var model: [Model] = {
		let mannyurl = "http://www.apeth.com/pep/manny.jpg"
		let jackurl = "http://www.apeth.com/pep/jack.jpg"
		let moeurl = "http://www.apeth.com/pep/moe.jpg"
		var arr = [Model]()
		for _ in 0 ..< 15 {
			let m = Model()
			m.text = "Manny"
			m.picurl = mannyurl
			arr.append(m)
		}
		for _ in 0 ..< 15 {
			let m = Model()
			m.text = "Moe"
			m.picurl = moeurl
			arr.append(m)
		}
		for _ in 0 ..< 15 {
			let m = Model()
			m.text = "Jack"
			m.picurl = jackurl
			arr.append(m)
		}
		return arr
	}()

    var didSetup = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.tableView.prefetchDataSource = self //turn on prefetching
        }
    }

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.model.count
	}

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for ip in indexPaths {
            let m = self.model[ip.row]
            guard m.im == nil else { print("nop \(ip)"); return } // we have a picture, nothing to do
            guard m.task == nil else { print("nop2 \(ip)"); return } // we're already downloading
            print("prefetching for \(ip)")
            let url = URL(string: m.picurl)!
            m.task = self.downloader.download(url: url) { url in
                m.task = nil
                if let url = url, let data = try? Data(contentsOf: url) {
                    print("got \(ip)")
                    m.im = UIImage(data:data)
                    tableView.reloadRows(at:[ip], with: .none)
                }
            }
        }
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let m = self.model[indexPath.row]
		cell.textLabel!.text = m.text

        if #available(iOS 10.0, *) {
            cell.imageView!.image = m.im // picture or nil
            if m.task == nil && m.im == nil {
                self.tableView(tableView, prefetchRowsAt:[indexPath])
            }
        } else {
            // have we got a picture?
            if let im = m.im {
                cell.imageView!.image = im
            } else {
                if m.task == nil { // no task? start one!
                    cell.imageView!.image = nil
                    m.task = self.downloader.download(m.picurl) { // *
                        [weak self] url in // *
                        m.task = nil // *
                        if url == nil {
                            return
                        }
                        let data = try! Data(contentsOf: url)
                        let im = UIImage(data: data)
                        m.im = im
                        DispatchQueue.main.async {
                            self!.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
		return cell
	}

    // uncomment to try expunging
	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let m = self.model[indexPath.row]

        if #available(iOS 10.0, *) {
            if let task = m.task {
                if task.state == .running {
                    task.cancel()
                    print("cancel task for row \((indexPath as NSIndexPath).row)")
                    m.task = nil
                }
        } else {
                if m.task == nil && m.im != nil {
                    m.im = nil // expunge
                }
            }
        }

	}

	deinit {
		self.downloader.cancelAllTasks()
		print("table view controller dealloc")
	}

}

// unfortunately a Swift dictionary inside an array is effectively immutable?!
// but we need to mutate our model objects
// one solution would be to resort to NSMutableDictionary
// but the truth is that this should have been a simple value class all along, so here it is

class Model {
	var text: String!
	var im: UIImage!
	var picurl: String!
	var task: URLSessionTask!
}
