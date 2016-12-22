
import UIKit

class MyProvider : UIActivityItemProvider {
    override var item : Any {
        // time-consuming operation goes here
        return "Coolness"
    }
}

// test on device

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
            print("completed \(type) \(ok) \(items) \(err)")
        }
        avc.excludedActivityTypes = ut
        //avc.excludedActivityTypes = nil
        self.present(avc, animated:true)
        // on iPad this will be an action sheet and will need a source view or bar button item
        if let pop = avc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }

    @IBAction func moreButton (_ sender: Any) {
        let url = Bundle.main.url(forResource:"sunglasses", withExtension:"png")!
        let things : [Any] = ["This is a cool picture", url]
        //let avc = UIActivityViewController(activityItems:things, applicationActivities:nil)
        let avc = UIActivityViewController(activityItems:things, applicationActivities:[MyCoolActivity(), MyElaborateActivity()])
        // new in iOS 8, completionHander replaced by completionWithItemsHandlers
        // the reason is that an extension, using this same API, can return values
        // type is (UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
        avc.completionWithItemsHandler = {
            type, ok, items, err in
            print("completed \(type) \(ok) \(items) \(err)")
        }
        avc.excludedActivityTypes = ut
        //avc.excludedActivityTypes = nil
        self.present(avc, animated: true)
        // on iPad this will be an action sheet and will need a source view or bar button item
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

