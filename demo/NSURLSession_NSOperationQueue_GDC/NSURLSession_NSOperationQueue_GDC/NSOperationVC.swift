

import UIKit

class NSOperationVC: UIViewController {

    @IBOutlet var mv : MyMandelbrotView!
    
    @IBAction func doButton (sender:AnyObject!) {
        self.mv.drawThatPuppy()
        sampleNSOperationQueue()
    }

    /**
     顺序列队
     */
    private func sampleNSOperationQueue() {
        let queue = NSOperationQueue()
        let operation1: NSBlockOperation = NSBlockOperation (
            block: {
                self.getWebs() //run first
                let operation2: NSBlockOperation = NSBlockOperation(block: {
                    self.loadWebs() //run second
                })
                queue.addOperation(operation2)
        })
        queue.addOperation(operation1)
        super.viewDidLoad()
    }
    
    func loadWebs() {
        let urls = NSMutableArray (objects:NSURL(string:"http://www.google.es")!,NSURL(string: "http://www.apple.com")!,NSURL(string: "http://carlosbutron.es")!,NSURL(string: "http://www.bing.com")!,NSURL(string: "http://www.yahoo.com")!)
        urls.addObjectsFromArray(googlewebs as [AnyObject])
        for iterator: AnyObject in urls {
            /// NSData(contentsOfURL:iterator as! NSURL)
            debugPrint("Downloaded \(iterator)")
        }
    }
    
    var googlewebs: NSArray = []
    
    func getWebs() {
        let languages: NSArray = ["com", "ad", "ae", "com.af", "com.ag", "com.ai", "am", "co.ao", "com.ar", "as", "at"]
        let languageWebs = NSMutableArray()
        for i in 0..<languages.count {
            let webString: NSString = "http://www.google.\(languages[i])"
            languageWebs.addObject(NSURL(fileURLWithPath: webString as String))
        }
        googlewebs = languageWebs
    }

}
