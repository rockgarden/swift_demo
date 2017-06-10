

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController, SizeDelegate {
    
    weak var config : SLComposeSheetConfigurationItem?
    var selectedText = "Large" {
        didSet {
            self.config?.value = self.selectedText
        }
    }


    /// 在此处验证contentText和/或NSExtensionContext附件
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
    
        let s = self.contentText // and do something with it
        
        self.extensionContext?.completeRequest(returningItems:[])
        
        _ = s
    }

    override func configurationItems() -> [Any]! {
        //  要通过表格底部的表格单元格添加配置选项，请在此处返回SLComposeSheetConfigurationItem数组。
        let c = SLComposeSheetConfigurationItem()!
        c.title = "Size"
        c.value = self.selectedText
        c.tapHandler = { [unowned self] in
            let tvc = TableViewController(style: .grouped)
            tvc.selectedSize = self.selectedText
            tvc.delegate = self
            self.pushConfigurationViewController(tvc)
        }
        self.config = c
        return [c]
    }

}
