
import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var lab: UILabel!

    let list : [String:String] = {
        let path = Bundle.main.url(forResource:"abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path)
        let arr = s.components(separatedBy:"\n")
        var result : [String:String] = [:]
        stride(from: 0, to: arr.count, by: 2).map{($0,$0+1)}.forEach {
            result[arr[$0.0]] = arr[$0.1]
        }
        return result
    }()

    let desiredType = kUTTypePlainText as String
    var orig : String?
    var expansion : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.isEnabled = false
        self.lab.text = "No expansion available."

        /// UIViewController新增了一个扩展上下文属性extensionContext。来处理containing app与扩展之间的通信,返回视图控制器的扩展上下文，上下文的类型是NSExtensionContext。视图控制器可以检查此属性以查看它是否参与扩展请求。 如果没有为当前视图控制器设置扩展上下文，系统将向上移动视图控制器层次结构，以查找具有非零extensionContext值的父视图控制器。
        if self.extensionContext == nil {
            return
        }
        let items = self.extensionContext!.inputItems
        /// 宿主APP调用时没传入 open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem,
            let provider = extensionItem.attachments?[0] as? NSItemProvider,
            provider.hasItemConformingToTypeIdentifier(self.desiredType)
            else { return }
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            (item:NSSecureCoding?, err:Error!) -> () in
            DispatchQueue.main.async {
                if let orig = item as? String {
                    self.orig = orig
                    if let exp = self.state(for:orig) {
                        debugPrint(exp)
                        self.expansion = exp
                        self.lab.text = "Can expand to \(exp)."
                        self.doneButton.isEnabled = true
                    }
                }
            }
        }
    }

    func state(for abbrev:String) -> String? {
        return self.list[abbrev.uppercased()]
    }

    func stuffThatEnvelope(_ item:String) -> [NSExtensionItem] {
        // everything has to get stuck back into the right sort of envelope
        let extensionItem = NSExtensionItem()
        let itemProvider = NSItemProvider(item: item as NSString, typeIdentifier: desiredType)
        extensionItem.attachments = [itemProvider]
        return [extensionItem]
    }

    @IBAction func cancel(_ sender: Any) {
        self.extensionContext?.completeRequest(returningItems: nil)
    }

    @IBAction func done(_ sender: Any) {
        self.extensionContext?.completeRequest(
            returningItems: self.stuffThatEnvelope(self.expansion!))
    }

}

extension ActionViewController : UIBarPositioningDelegate {
    func positionForBar(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
