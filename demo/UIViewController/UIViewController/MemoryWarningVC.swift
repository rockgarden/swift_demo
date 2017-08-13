
import UIKit
import Foundation

@objc protocol Dummy {
    func _performMemoryWarning()
}


/// trigger a memory warning
class MemoryWarningVC : UIViewController {
    
    // NSCache now comes across as a true Swift generic!
    /// NSCache对象是一个可变集合，可以存储键值对，类似于NSDictionary对象。 NSCache类提供了一个编程接口，用于添加和删除对象，并根据缓存中的对象总成本和数量设置逐出策略。
    /// NSCache对象与其他可变集合有以下几种不同：
    /// NSCache类包含各种自动驱逐策略，可以确保高速缓存不会占用系统内存的太多。如果其他应用程序需要内存，这些策略将从缓存中删除一些项目，从而最大限度地减少其内存占用。
    /// 您可以从不同的线程添加，删除和查询缓存中的项目，而无需自己锁定缓存。
    /// 与NSMutableDictionary对象不同，缓存不会复制放在其中的关键对象。
    /// 您通常使用NSCache对象临时存储创建成本较高的瞬态数据的对象。重新使用这些对象可以提供性能优势，因为它们的值不必重新计算。但是，这些对象对于应用程序并不重要，如果内存不足，可能会丢弃该对象。如果丢弃，则需要重新计算它们的值。
    /// 具有可以在不使用时可以丢弃的子组件的对象可以采用NSDiscardableContent协议来提高缓存驱逐行为。默认情况下，如果缓存中的NSDiscardableContent对象的内容被丢弃，则会自动删除，尽管可以更改此自动删除策略。如果将NSDiscardableContent对象放入高速缓存中，缓存将在删除时调用discardContentIfPossible（）
    private let _cache = NSCache<NSString, NSData>()
    var cachedData : Data {
        let key = "somekey" as NSString
        var data = self._cache.object(forKey:key) as Data?
        if data != nil {
            return data!
        }
        // recreate data here
        data = Data(bytes:[1,2,3,4])
        self._cache.setObject(data! as NSData, forKey: key)
        return data!
    }

    /// 当您具有可以在不再需要时可以丢弃的字节的对象时，应使用NSPurgeableData类。清理这些字节对于您的系统可能是有利的，因为这样做可以释放其他应用程序所需的内存。 NSPurgeableData类提供了NSDiscardableContent协议的默认实现，它从中继承其接口。
    /// NSPurgeableData对象从其超类NSMutableData继承其创建方法。所有NSPurgeableData对象开始“访问”，以确保它们不被立即丢弃（请参见NSDiscardableContent）。beginContentAccess（）方法将对象的字节标记为“已访问”，从而保护对象的字节不被丢弃，并且必须在访问对象之前调用该对象，否则将引发异常，如果字节未被丢弃，并且已成功标记为“已访问”，则此方法返回true。任何直接或间接访问这些字节或不被访问的字符串的方法，将引发异常，完成数据后，调用endContentAccess（）以允许它们被丢弃，以便快速释放内存。
    /// 您可以自己使用这些对象，并不一定必须与NSCache一起使用它们来获取清除行为。 NSCache类包含缓存机制和一些自动删除策略，以确保其内存占用不会太大。
    /// NSPurgeableData对象不应该用作基于哈希的集合中的键，因为在每次数据突变之后，字节指针的值可以改变。
    private var _purgeable = NSPurgeableData()
    var purgeabledata : Data {
        if self._purgeable.beginContentAccess() && self._purgeable.length > 0 {
            let result = self._purgeable.copy() as! Data
            self._purgeable.endContentAccess()
            return result
        } else {
            // recreate data here
            let data = Data(bytes:[6,7,8,9])
            self._purgeable = NSPurgeableData(data:data)
            self._purgeable.endContentAccess()
            return data
        }
    }
    

    // this is the actual example
    
    private var _myBigData : Data! = nil
    var myBigData : Data! {
        set (newdata) {
            self._myBigData = newdata
        }
        get {
            if _myBigData == nil {
                let fm = FileManager.default
                if #available(iOS 10.0, *) {
                    let f = fm.temporaryDirectory.appendingPathComponent("myBigData")
                    if let d = try? Data(contentsOf:f) {
                        print("loaded big data from disk")
                        self._myBigData = d
                        do {
                            try fm.removeItem(at:f)
                            print("deleted big data from disk")
                        } catch {
                            print("Couldn't remove temp file")
                        }
                    }
                } else {
                    let f = (NSTemporaryDirectory() as NSString).appendingPathComponent("myBigData")
                    if fm.fileExists(atPath: f) {
                        print("loading big data from disk")
                        self._myBigData = try? Data(contentsOf: URL(fileURLWithPath: f))
                        do {
                            try fm.removeItem(atPath: f)
                            print("deleted big data from disk")
                        } catch {
                            print("Couldn't remove temp file")
                        }
                    }
                }
            }
            return self._myBigData
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // this is some big data!
        self.myBigData = "howdy".data(using:.utf8, allowLossyConversion: false)
    }
    
    // tap button to prove we've got big data
    
    @IBAction func doButton (_ sender: Any?) {
        let s = String(data: self.myBigData, encoding:.utf8)
        let av = UIAlertController(title: "Got big data, and it says:", message: s, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(av, animated: true)
    }
    
    func saveAndReleaseMyBigData() {
        if let myBigData = self.myBigData {
            print("unloading big data")
            let fm = FileManager.default
            if #available(iOS 10.0, *) {
                let f = fm.temporaryDirectory.appendingPathComponent("myBigData")
                try? myBigData.write(to:f)
                self.myBigData = nil
            } else {
                let f = (NSTemporaryDirectory() as NSString).appendingPathComponent("myBigData")
                try? myBigData.write(to: URL(fileURLWithPath: f), options: [])
                self.myBigData = nil
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        let av = UIAlertController(title: "did receive memory warning", message: nil, preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(av, animated: true)
        super.didReceiveMemoryWarning()
        self.saveAndReleaseMyBigData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// private API 提交AppStore时必须删除 (you'd have to remove it from shipping code)
    @IBAction func doButton2(_ sender: Any) {
        UIApplication.shared.perform(#selector(Dummy._performMemoryWarning))
    }
    
    @IBAction func testCaches(_ sender: Any) {
        print(self.cachedData)
        print(self.purgeabledata)
    }

    // backgrounding

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(backgrounding), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    func backgrounding(_ n:Notification) {
        self.saveAndReleaseMyBigData()
    }
    
}
