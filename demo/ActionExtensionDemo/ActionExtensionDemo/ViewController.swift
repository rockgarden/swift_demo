

import UIKit
import MobileCoreServices


class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf : UITextField!
    let desiredType = kUTTypePlainText as String

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.allowsEditingTextAttributes = false
    }

    @IBAction func doShare(_ sender: Any) {
        self.view.endEditing(true)
        self.showActivityView()
    }

    func showActivityView() {
        let things = self.tf.text!
        let avc = UIActivityViewController(activityItems:[things], applicationActivities:nil)

        /*
         ## NSItemProvider对象
         提供了一种在主机应用程序和扩展之间传递数据的懒惰和安全的方式。项目提供者对象包装文本，图像或URL等数据，并存储类型信息以帮助进程识别该数据。当您实际需要项目提供者中的数据时，您可以异步加载数据，从而使项目提供者根据需要从另一个进程传输它。当检查NSExtensionItem对象的附件属性时，扩展名通常会遇到项目提供者。
         在该检查期间，扩展可以使用hasItemConformingToTypeIdentifier（_ :)方法来查找它识别的数据。项目提供者使用统一类型标识符（UTI）值来标识它们包含的数据。在找到扩展程序可以使用的数据类型之后，它调用loadItem（forTypeIdentifier：options：completionHandler :)方法来加载实际的数据，将其传递给提供的完成处理程序。
         您可以创建项目提供商以将数据出售给另一个进程。修改原始数据项的扩展可以创建一个新的NSItemProvider对象，以发送回主机应用程序。创建数据项时，可以指定数据对象和该对象的类型。您可以选择使用previewImageHandler属性为数据生成预览图像。
         单个项目提供者可以使用自定义块以许多不同的格式提供其数据。配置项目提供者时，请使用registerItem（forTypeIdentifier：loadHandler :)方法来注册您的块和每种支持的格式。当客户端以特定格式请求数据时，项目提供者执行相应的块，然后负责将数据强制为适当的类型并将其返回给客户端。
         */
        let p = NSItemProvider()
        p.registerItem(forTypeIdentifier: desiredType) {
            completion, klass, d in
            completion(self.tf.text! as NSSecureCoding, nil)
        }

        //let avc = UIActivityViewController(activityItems:[p], applicationActivities:nil)


        avc.completionWithItemsHandler = { type, ok, items, err in
            print("completed \(String(describing: type)) \(ok) \(String(describing: items)) \(String(describing: err))")
            if ok {
                guard let items = items, items.count > 0 else {
                    return
                }
                guard let extensionItem = items[0] as? NSExtensionItem,
                    let provider = extensionItem.attachments?[0] as? NSItemProvider,
                    provider.hasItemConformingToTypeIdentifier(self.desiredType)
                    else {
                        return
                }
                provider.loadItem(forTypeIdentifier: self.desiredType) { item, err in
                    DispatchQueue.main.async {
                        if let s = item as? String {
                            self.tf.text = s
                        }
                    }
                }
            }
        }
        avc.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
            .print,
            // UIActivityTypeCopyToPasteboard,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks,
        ]
        self.present(avc, animated:true)
    }
    
}
