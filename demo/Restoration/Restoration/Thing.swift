

import UIKit

class Thing : NSObject, UIStateRestoring {
    
    var word = ""
    
    // var restorationParent: UIStateRestoring? // unused
    
    // var objectRestorationClass: UIObjectRestoration.Type? // unused
    
    func encodeRestorableState(with coder: NSCoder) {
        print("thing encode")
        coder.encode(self.word, forKey:"word")
    }
    
    func decodeRestorableState(with coder: NSCoder) {
        print("thing decode")
        self.word = coder.decodeObject(forKey:"word") as! String
    }
    
    func applicationFinishedRestoringState() {
        print("finished thing")
    }
    
    
}
