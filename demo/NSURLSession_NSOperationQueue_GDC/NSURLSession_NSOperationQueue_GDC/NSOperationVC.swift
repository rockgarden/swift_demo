

import UIKit

class NSOperationVC: UIViewController {

    @IBOutlet var mv : MandelbrotView!
    
    @IBAction func doButton (_ sender:AnyObject!) {
        self.mv.drawThatPuppy()
        sampleNSOperationQueue()
    }

    /**
     顺序列队
     */
    fileprivate func sampleNSOperationQueue() {
        let queue = OperationQueue()
        let operation1: BlockOperation = BlockOperation (
            block: {
                self.getWebs() //run first
                let operation2: BlockOperation = BlockOperation(block: {
                    self.loadWebs() //run second
                })
                queue.addOperation(operation2)
        })
        queue.addOperation(operation1)
        super.viewDidLoad()
    }
    
    func loadWebs() {
        let urls = NSMutableArray (objects:URL(string:"http://www.google.es")!,URL(string: "http://www.apple.com")!,URL(string: "http://carlosbutron.es")!,URL(string: "http://www.bing.com")!,URL(string: "http://www.yahoo.com")!)
        urls.addObjects(from: googlewebs as [AnyObject])
        for iterator: Any in urls {
            /// NSData(contentsOfURL:iterator as! NSURL)
            debugPrint("Downloaded \(iterator)")
        }
    }
    
    var googlewebs: NSArray = []
    
    func getWebs() {
        let languages: NSArray = ["com", "ad", "ae", "com.af", "com.ag", "com.ai", "am", "co.ao", "com.ar", "as", "at"]
        let languageWebs = NSMutableArray()
        for i in 0..<languages.count {
            let webString: NSString = "http://www.google.\(languages[i])" as NSString
            languageWebs.add(URL(fileURLWithPath: webString as String))
        }
        googlewebs = languageWebs
    }

}
