
import UIKit

class RTFImportUITextViewVC: UIViewController {
    @IBOutlet weak var tv: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "test", withExtension: "rtf")!
        let opts = [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType]
        var d : NSDictionary? = nil
        let s = try! NSAttributedString(url: url, options: opts, documentAttributes: &d)
        self.tv.attributedText = s
    }


}

