
import UIKit

class FileManagerVC: UIViewController {

    let query = NSMetadataQuery()

    override func viewDidLoad() {
        super.viewDidLoad()
        // failed experiment; can't use NSMetadataQuery except in the iCloud folder
        //self.query.predicate = NSPredicate(format:"%K ENDSWITH '.txt'", NSMetadataItemFSNameKey)
        //self.query.startQuery()
    }

    @IBAction func getDocumentsPath (_ sender: AnyObject!) {
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print(docs)
    }

    @IBAction func getDocumentsURL (_ sender: AnyObject!) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print(docsurl)
        } catch {
            print(error)
        }
    }

    @IBAction func getAndCreateApplicationSupportURL (_ sender: AnyObject!) {
        do {
            let fm = FileManager()
            let suppurl = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print(suppurl)
        } catch {
            print(error)
        }
    }

    @IBAction func createFolderAndFiles (_ sender: AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let myfolder = docsurl.appendingPathComponent("MyFolder")

            try fm.createDirectory(at: myfolder, withIntermediateDirectories: true, attributes: nil)

            // if we get here, myfolder exists
            // let's put a couple of files into it
            try "howdy".write(to: myfolder.appendingPathComponent("file1.txt"), atomically: true, encoding: .utf8)
            try "greetings".write(to: myfolder.appendingPathComponent("file2.txt"), atomically: true, encoding: .utf8)
            print("ok")
        } catch {
            print(error)
        }
    }

    @IBAction func getContentsDirectory (_ sender: AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arr = try fm.contentsOfDirectory(at: docsurl, includingPropertiesForKeys: nil, options: [])
            arr.forEach{print($0.lastPathComponent)}
            // ======
            self.query.enumerateResults({
                obj, ix, stop in
                print(obj)
            })
        } catch {
            print(error)
        }
    }

    @IBAction func deepTraversalDirectory (_ sender:AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dir = fm.enumerator(at: docsurl, includingPropertiesForKeys: nil, options: [], errorHandler: nil)!
            for case let f as URL in dir where f.pathExtension == "txt" {
                print(f.lastPathComponent)
            }
        } catch {
            print(error)
        }
    }

    let which = 1
    @IBAction func savePerson (_ sender: AnyObject!) {
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moi = Person(firstName: "Matt", lastName: "Neuburg")
            let moidata = NSKeyedArchiver.archivedData(withRootObject: moi)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
//                try? moidata.write(to: moifile, options: [.atomic])
//                try (moifile as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                try moidata.write(to: moifile, options: .atomic)
                var moifilevar = moifile
                var rv = URLResourceValues()
                rv.isExcludedFromBackup = true
                try moifilevar.setResourceValues(rv)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.writingIntent(with: moifile)
                fc.coordinate(with: [intent], queue: .main) {
                    (err) in
                    // compiler gets confused if a one-liner returns a BOOL result
                    do {
                        try moidata.write(to: intent.url, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
            default:break
            }

            // note that you still can't save an array of Person as a plist,
            // even though Person adopts NSCoding
            // it won't turn itself automagically into a Data object

            let arr = [moi]
            let arrfile = docsurl.appendingPathComponent("arr.plist")
            let ok = (arr as NSArray).write(to: arrfile, atomically: true)
            print(ok) // false
        } catch {
            print(error)
        }
    }

    @IBAction func retrievePerson (_ sender: AnyObject!) {
        do {
            let fm = FileManager()
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let moifile = docsurl.appendingPathComponent("moi.txt")
            switch which {
            case 1:
                let persondata = try! Data(contentsOf: moifile)
                let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                print(person)
            case 2:
                // ==== the NSFileCoordinator way
                let fc = NSFileCoordinator()
                let intent = NSFileAccessIntent.readingIntent(with: moifile)
                fc.coordinate(with: [intent], queue: .main) {
                    (err) in
                    do {
                        let persondata = try Data(contentsOf: intent.url)
                        let person = NSKeyedUnarchiver.unarchiveObject(with: persondata) as! Person
                        print(person)
                    } catch {
                        print(error)
                    }
                }
            default:break
            }
            let arrfile = docsurl.appendingPathComponent("arr.plist")
            let arr = NSArray(contentsOf: arrfile)
            print(arr as Any)
        } catch {
            print(error)
        }
    }
    
}

