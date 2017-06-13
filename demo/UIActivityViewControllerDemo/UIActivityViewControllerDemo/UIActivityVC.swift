
import UIKit

// test on device
/// UIActivityViewController类是一个标准视图控制器，可用于从应用程序提供各种服务。 该系统提供多种标准服务，例如将项目复制到粘贴板，将内容发布到社交媒体网站，通过电子邮件或短信发送项目等。 Apps还可以定义自定义服务。您的应用程序负责配置，呈现和关闭此视图控制器。 视图控制器的配置包括指定视图控制器应在其上执行的数据对象。 （您还可以指定应用程序支持的自定义服务列表。）显示视图控制器时，您必须使用适当的方式来执行当前设备。 在iPad上，您必须将视图控制器呈现在弹出窗口中。 在iPhone和iPod touch上，您必须以模态方式呈现
class UIActivityVC: UIViewController {

    let ut: [UIActivityType] = [
        .postToFacebook,
        .postToTwitter,
        .postToWeibo,
        .message,
        .mail,
        .print,
        .copyToPasteboard,
        .assignToContact,
        .saveToCameraRoll,
        .addToReadingList,
        .postToFlickr,
        .postToVimeo,
        .postToTencentWeibo,
        .airDrop,
        .openInIBooks,
        UIActivityType("com.apple.mobilenotes.SharingExtension") // nope, can't exclude a sharing extension
        ]

    @IBAction func doButton (_ sender: Any) {
        /// supply `self` so we will be queried separately for the item
        //let avc = UIActivityViewController(activityItems:[self], applicationActivities:nil)
        // supply an item provider so it can supply the data lazily

        /// 系统通过判断 activityItems 类型决定分发哪些相关应用
        let avc = UIActivityViewController(activityItems:[MyProvider(placeholderItem: "")], applicationActivities:nil)
        avc.completionWithItemsHandler = {
            (type: UIActivityType?, ok: Bool, items: [Any]?, err:Error?) -> Void in
            print("completed \(String(describing: type)) \(ok) \(String(describing: items)) \(String(describing: err))")
        }
        avc.excludedActivityTypes = ut
        //avc.excludedActivityTypes = nil
        self.present(avc, animated:true)
        /// on iPad this will be an action sheet and will need a source view or bar button item
        if let pop = avc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }

    @IBAction func moreButton (_ sender: Any) {
        let url = Bundle.main.url(forResource:"sunglasses", withExtension:"png")!
        let things : [Any] = ["This is a cool picture", url]

        let avc = UIActivityViewController(activityItems:things, applicationActivities:[CoolActivity(), ElaborateActivity()])
        avc.completionWithItemsHandler = {
            type, ok, items, err in
            print("completed \(String(describing: type)) \(ok) \(String(describing: items)) \(String(describing: err))")
        }
        avc.excludedActivityTypes = ut

        self.present(avc, animated: true)
        if let pop = avc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }
}


extension UIActivityVC : UIActivityItemSource {
    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController)
        -> Any {
            return ""
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivityType)
        -> Any? {
            print(activityType)
            return "Coolness"
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivityType?) -> String {
        return "This is cool"
    }
}


class MyProvider : UIActivityItemProvider {
    override var item : Any {
        // time-consuming operation goes here
        return "Coolness"
    }
}

