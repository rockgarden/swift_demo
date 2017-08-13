
import UIKit

/*
 Launch the app, push, and Write a value into our Thing.
 Now background the app and relaunch it.
 We restore state, so we are still in the pushed v.c....
 ...and now Read and you will see that the text of the Thing has been restored.
 That's because Thing is itself an archivable object.

 However, if you pop so that the ViewController is lost, then of course there is no Thing any more either.
 所以如果再推一次，就像预期一样清理了Thing。
 So if you push again, the Thing has been cleaned out, as expected.
 */

class SaveAndRestoreArbitraryObjectVC : UIViewController {

    var thing : Thing!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.thing = type(of:self).makeThing()
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
        // must show this object to the archiver
        coder.encode(self.thing, forKey: "mything")
    }

    override func applicationFinishedRestoringState() {
        print("finished view controller")
        // self.thing.restorationParent = self
    }

    @IBAction func doRead(_ sender: Any?) {
        let alert = UIAlertController(title: "Read", message: self.thing.word, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style:.cancel))
        self.present(alert, animated: true)
    }

    @IBAction func doWrite(_ sender: Any?) {
        let alert = UIAlertController(title: "Write", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in tf.text = self.thing.word }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            self.thing.word = alert.textFields![0].text!
        })
        self.present(alert, animated: true)
    }

    deinit {
        print("farewell from ViewController")
    }

}

extension SaveAndRestoreArbitraryObjectVC /*: UIObjectRestoration*/ {

    class func makeThing () -> Thing {
        let thing = Thing()
        UIApplication.registerObject(forStateRestoration: thing, restorationIdentifier: "thing")
        // thing.objectRestorationClass = self
        return thing
    }

    // unused, no actual restoration, just showing it can be done
    /*
     class func object(withRestorationIdentifierPath ip: [String],
     coder: NSCoder) -> UIStateRestoring? {
     print(ip)
     let thing = self.makeThing()
     return thing
     }
     */

}
