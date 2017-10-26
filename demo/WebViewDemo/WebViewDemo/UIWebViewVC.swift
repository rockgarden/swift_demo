
import UIKit

class UIWebViewVC: UIViewController, UIViewControllerRestoration {

    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue?
    var canNavigate = false
    var wv : UIWebView {
        return self.view as! UIWebView
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        restorationIdentifier = "wvc"
        restorationClass = type(of: self)
        let b = UIBarButtonItem(title:"Back", style:.plain, target:self, action:#selector(goBack))
        let a = UIBarButtonItem(title:"Other", style:.plain, target:self, action:#selector(loadOther))
        navigationItem.setRightBarButtonItems([b,a], animated: true)
        edgesForExtendedLayout = [] //none; get accurate offset restoration
    }

    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    class func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return self.init(nibName:nil, bundle:nil)
    }

    /// 为本地页面示例，我们必须自己保存和恢复偏移量, for the local page example, we must save and restore offset ourselves
    /// note that I don't touch the web view at this point: just an var
    /// we don't have any web content yet!
    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        super.decodeRestorableState(with:coder)
        self.oldOffset = coder.decodeObject(forKey:"oldOffset") as? NSValue // for local example
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("encode")
        super.encodeRestorableState(with:coder)
        if !self.canNavigate { // local example; we have to manage offset ourselves
            print("saving offset")
            let off = self.wv.scrollView.contentOffset
            coder.encode(NSValue(cgPoint:off), forKey:"oldOffset")
        }
    }

    override func applicationFinishedRestoringState() {
        if self.wv.request != nil {
            // remote example
            self.wv.reload()
        }
    }

    deinit {
        print("dealloc")
        wv.stopLoading()
        wv.delegate = nil
    }

    override func loadView() {
        let wv = UIWebView()
        wv.restorationIdentifier = "wv"
        wv.backgroundColor = .black
        self.view = wv
        wv.delegate = self

        // new iOS 7 feature
        wv.paginationMode = .leftToRight
        wv.scrollView.isPagingEnabled = true

        /// 将手势识别器附加到web view的滚动视图, attach gesture recognizer to web view's scroll view
        let swipe = UISwipeGestureRecognizer(target:self, action:#selector(swiped))
        swipe.direction = .left
        wv.scrollView.addGestureRecognizer(swipe)

        /// prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerX, relatedBy: .equal, toItem: wv, attribute: .centerX, multiplier: 1, constant: 0)
        )
        view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerY, relatedBy: .equal, toItem: wv, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }

    @objc func swiped(_ g: UIGestureRecognizer) {
        print("swiped")
    }

    /// 等于1时载入实际请求，让您尝试进行状态保存和恢复. one that loads an actual request and lets you experiment with state saving and restoration
    let LOADREQ = 1

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(String(describing: self.wv.request))")

        if LOADREQ == 1 {
            self.canNavigate = true
            if self.wv.request != nil {
                /// let applicationFinished handle reloading? applicationFinished句柄重新加载?
                return
            }
            let url = URL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
            self.wv.loadRequest(URLRequest(url:url))
            return
        }
    }

    var which = 1
    @objc func loadOther() {
        if which < 11 {
            which += 1
        } else {
            which = 1
        }
        var path = ""
        switch which {
        case 1:
            let p1 = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
            let base = URL(fileURLWithPath: p1)
            let ss = try! String(contentsOfFile: p1)

            let p2 = Bundle.main.path(forResource: "htmlTemplate", ofType:"txt")!
            var s = try! String(contentsOfFile: p2)

            s = s.replacingOccurrences(of:"<maximagewidth>", with:"80%")
            s = s.replacingOccurrences(of:"<fontsize>", with:"18")
            s = s.replacingOccurrences(of:"<margin>", with:"10")
            s = s.replacingOccurrences(of:"<guid>", with:"http://tidbits.com/article/12228")
            s = s.replacingOccurrences(of:"<ourtitle>", with:"Lion Details Revealed with Shipping Date and Price")
            s = s.replacingOccurrences(of:"<playbutton>", with:"<img src=\"listen.png\" onclick=\"document.location='play:me'\">")
            s = s.replacingOccurrences(of:"<author>", with:"TidBITS Staff")
            s = s.replacingOccurrences(of:"<date>", with:"Mon, 06 Jun 2011 13:00:39 PDT")
            s = s.replacingOccurrences(of:"<content>", with:ss)

            self.wv.loadHTMLString(s, baseURL: base)
        case 2:
            path = Bundle.main.path(forResource: "release", ofType:"pdf")!
        case 3:
            path = Bundle.main.path(forResource: "testing", ofType:"pdf")!
        case 4:
            path = Bundle.main.path(forResource: "test", ofType:"rtf")!
        case 5:
            path = Bundle.main.path(forResource: "test", ofType:"doc")!
        case 6:
            path = Bundle.main.path(forResource: "test", ofType:"docx")!
        case 7:
            path = Bundle.main.path(forResource: "test", ofType:"pages")!
        case 8:
            /// unbelievably slow
            path = Bundle.main.path(forResource: "test.pages", ofType:"zip")!
        case 9:
            /// blank in simulator, blank on device, no message
            path = Bundle.main.path(forResource: "test", ofType:"rtfd")!
        case 10:
            /// in iOS 10 I see the document! However, I don't see the embedded image.
            path = Bundle.main.path(forResource: "test.rtfd", ofType:"zip")!
        case 11:
            path = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
        case 12:
            let p = Bundle.main.path(forResource: "test.rtfd", ofType:"zip")!
            let url = URL(fileURLWithPath: p)
            let data = try! Data.init(contentsOf: url)
            self.wv.load(data, mimeType: "application/zip", textEncodingName: "utf-8", baseURL: url)
        default:
            break
        }
        if path != "" {
            let url = URL(fileURLWithPath: path)
            self.wv.loadRequest(URLRequest(url: url))
        }
    }

    @objc func goBack(_ sender: Any) {
        if self.wv.canGoBack {
            self.wv.goBack()
        }
    }
}


extension UIWebViewVC: UIWebViewDelegate {

    func webViewDidStartLoad(_ wv: UIWebView) {
        self.activity.startAnimating()
    }

    func webViewDidFinishLoad(_ wv: UIWebView) {
        self.activity.stopAnimating()
        /// for our *local* example, restoring offset is up to us
        if self.oldOffset != nil && !self.canNavigate { //local example
            print("restoring offset")
            wv.scrollView.contentOffset = self.oldOffset!.cgPointValue
        }
        self.oldOffset = nil
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activity.stopAnimating()
    }

    /// 在Web视图开始加载frame之前判断，如果网页视图可以开始加载内容，则为true; 否则，false.
    func webView(_ webView: UIWebView, shouldStartLoadWith r: URLRequest, navigationType nt: UIWebViewNavigationType) -> Bool {
        if let scheme = r.url?.scheme, scheme == "play" {
            print("user would like to hear the podcast")
            return false
        }
        if nt == .linkClicked { // disable link-clicking
            if self.canNavigate {
                return true
            }
            print("user would like to navigate to \(String(describing: r.url))")
            // this is how you would open in Safari
            UIApplication.shared.canOpenURL(r.url!)
            return false
        }
        return true
    }

}
