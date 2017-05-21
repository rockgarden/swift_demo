//
//  NoNavigationWebView.swift
//  WebViewDemo
//


import UIKit
import WebKit
import SafariServices

/*
 A simple no-navigation web view - we just show our own custom content and that's all.
 Demonstrates basic web kit configuration and some cool features.
 */

class MyMessageHandler : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(_ ucc: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(ucc, didReceive: message)
    }
    deinit {
        print("message handler dealloc")
    }
}


class NoNavigationWKWebViewVC: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIViewControllerRestoration, SFSafariViewControllerDelegate {

    var activity = UIActivityIndicatorView()
    var oldOffset : NSValue? // use nil as indicator
    var oldHTMLString : String?

    var fontsize = 18
    var cssrule : String {
        var s = "var s = document.createElement('style');\n"
        s += "s.textContent = '"
        s += "body { font-size: \(self.fontsize)px; }"
        s += "';\n"
        s += "document.documentElement.appendChild(s);\n"
        return s
    }
    weak var wv : WKWebView!

    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = type(of:self)
        self.edgesForExtendedLayout = []
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }


    class func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let id = identifierComponents.last as! String
        if id == "wvc" {
            print("recreating wvc view controller")
            return self.init(nibName:nil, bundle:nil)
        }
        return nil
    }

    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        super.decodeRestorableState(with:coder)
        if let oldOffset = coder.decodeObject(forKey:"oldOffset") as? NSValue {
            self.oldOffset = oldOffset
        }

        let fontsize = coder.decodeInteger(forKey:"fontsize")
        self.fontsize = fontsize

        if let oldHTMLString = coder.decodeObject(forKey:"oldHTMLString") as? String {
            self.oldHTMLString = oldHTMLString
        }
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
        // we have to manage offset ourselves
        let off = self.wv.scrollView.contentOffset
        print("saving offset \(off)")
        coder.encode(NSValue(cgPoint:off), forKey:"oldOffset")
        coder.encode(self.fontsize, forKey:"fontsize")
        coder.encode(self.oldHTMLString, forKey:"oldHTMLString")
    }

    override func applicationFinishedRestoringState() {
        print("finished restoring state")
        // still too soon to fix offset, not loaded yet
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // a configuration consists of preferences (e.g. JavaScript behavior), and a user content controller that allows JavaScript messages to be sent/received it is copied, so if we supply one we can't change it later alternatively, to use a default configuration, use frame alone?
        // here, frame unimportant, we will be sized automatically
        //let config = WKWebViewConfiguration()
        //let wv = WKWebView(frame: .zero, configuration:config)
        // 相当于
        let wv = WKWebView(frame: .zero)

        self.wv = wv

        /// prepare to receive messages under the "playbutton" name unfortunately there's a bug: the script message handler cannot be self, or we will leak
        var leak : Bool { return false }
        switch leak {
        case true:
            let config = self.wv.configuration
            config.userContentController.add(self, name: "playbutton")
        case false:
            let config = self.wv.configuration
            let handler = MyMessageHandler(delegate: self)
            config.userContentController.add(handler, name: "playbutton")
        }

        wv.restorationIdentifier = "wv"
        wv.scrollView.backgroundColor = .black
        view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[wv]|", metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[wv]|", metrics: nil, views: ["wv":wv])
            ].flatMap{$0})
        wv.navigationDelegate = self

        // WKWebView missing .paginationMode feature
        //wv.paginationMode = .leftToRight
        wv.scrollView.isPagingEnabled = true

        let swipe = UISwipeGestureRecognizer(target:self, action:#selector(swiped))
        swipe.direction = .left
        wv.scrollView.addGestureRecognizer(swipe)
        wv.allowsBackForwardNavigationGestures = false

        let act = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            act.centerXAnchor.constraint(equalTo:wv.centerXAnchor),
            act.centerYAnchor.constraint(equalTo:wv.centerYAnchor)
            ])
        // webkit uses KVO
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: .new, context: nil)
        // cool feature, show title
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let wv = object as? WKWebView else {return}
        guard let keyPath = keyPath else {return}
        guard let change = change else {return}
        switch keyPath {
        case "loading": // new:1 or 0
            if let val = change[.newKey] as? Bool {
                if val {
                    print("starting animating")
                    self.activity.startAnimating()
                } else {
                    self.activity.stopAnimating()
                    print("stopping animating")
                    // for our *local* example, restoring offset is up to us
                    if self.oldOffset != nil { // local example
                        if wv.estimatedProgress == 1 {
                            delay(0.1) {
                                print("finished loading! restoring offset")
                                wv.scrollView.contentOffset = self.oldOffset!.cgPointValue
                                self.oldOffset = nil
                            }
                        }
                    }
                }
            }
        case "title": // not actually showing it in this example
            if let val = change[.newKey] as? String {
                print(val)
            }
        default:break
        }
    }

    func swiped(_ g:UIGestureRecognizer) {
        print("swiped")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(String(describing: self.wv.url))")

        if !self.isMovingToParentViewController {
            return
        }

        let b = UIBarButtonItem(title: "Size", style: .plain, target: self, action: #selector(doDecreaseSize))
        let a = UIBarButtonItem(title:"Other", style:.plain, target:self, action:#selector(loadOther))
        let c = UIBarButtonItem(title:"Nav", style:.plain, target:self, action:#selector(setWhichNav))
        navigationItem.setRightBarButtonItems([a,b,c], animated: true)

        /// inject a CSS rule: (instead of body style containing font-size:<fontsize>px; in template)
        do {
            _ = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
            let rule = self.cssrule
            let script = WKUserScript(source: rule, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            let config = self.wv.configuration
            config.userContentController.addUserScript(script)
        }

        if let oldHTMLString = self.oldHTMLString {
            print("restoring html")
            let templatepath = Bundle.main.path(forResource: "htmlTemplate", ofType:"txt")!
            let oldBase = URL(fileURLWithPath: templatepath)
            self.wv.loadHTMLString(oldHTMLString, baseURL:oldBase)
            return
        }

        let bodypath = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
        let ss = try! String(contentsOfFile: bodypath)

        let templatepath = Bundle.main.path(forResource: "htmlTemplate", ofType: "txt")!
        let base = URL(fileURLWithPath: templatepath)
        var s = try! String(contentsOfFile: templatepath)

        s = s.replacingOccurrences(of:"<maximagewidth>", with: "80%")
        s = s.replacingOccurrences(of:"<margin>", with:"10")
        s = s.replacingOccurrences(of:"<guid>", with:"http://tidbits.com/article/12228")
        s = s.replacingOccurrences(of:"<ourtitle>", with:"Lion Details Revealed with Shipping Date and Price")
        // note way to set up messaging from web page's javascript to us
        s = s.replacingOccurrences(of:"<playbutton>", with:"<img src=\"listen.png\" onclick=\"window.webkit.messageHandlers.playbutton.postMessage('play')\">")
        s = s.replacingOccurrences(of:"<author>", with:"TidBITS Staff")
        s = s.replacingOccurrences(of:"<date>", with:"Mon, 06 Jun 2011 13:00:39 PDT")
        s = s.replacingOccurrences(of:"<content>", with:ss)

        self.wv.loadHTMLString(s, baseURL:base) // works in iOS 9! local and remote images are loading
        self.oldHTMLString = s
    }

    var which = 1
    func loadOther() {
        if which < 18 {
            which += 1
        } else {
            which = 1
        }
        switch which {
        case 2:
            let path = Bundle.main.path(forResource: "release", ofType:"pdf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 3:
            let path = Bundle.main.path(forResource: "testing", ofType:"pdf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 4:
            let path = Bundle.main.path(forResource: "test", ofType:"rtf")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 5:
            let path = Bundle.main.path(forResource: "test", ofType:"doc")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 6:
            let path = Bundle.main.path(forResource: "test", ofType:"docx")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 7:
            let path = Bundle.main.path(forResource: "test", ofType:"pages")! // blank on device
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 8:
            let path = Bundle.main.path(forResource: "test.pages", ofType:"zip")! // slow, but it does work!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 9:
            let path = Bundle.main.path(forResource: "test", ofType:"rtfd")! // blank on device
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 10:
            let path = Bundle.main.path(forResource: "test.rtfd", ofType:"zip")! // displays (new in iOS 10), but not the image
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 11:
            let path = Bundle.main.path(forResource: "htmlbody", ofType:"txt")!
            let url = URL(fileURLWithPath:path)
            self.wv.loadFileURL(url, allowingReadAccessTo: url)
        case 12:
            let url = URL(string: "http://www.apeth.com/rez/release.pdf")!
            self.wv.load(URLRequest(url: url))
        case 13:
            let url = URL(string: "http://www.apeth.com/rez/testing.pdf")!
            self.wv.load(URLRequest(url: url))
        case 14:
            let url = URL(string: "http://www.apeth.com/rez/test.rtf")!
            self.wv.load(URLRequest(url: url))
        case 15:
            let url = URL(string: "http://www.apeth.com/rez/test.doc")!
            self.wv.load(URLRequest(url: url))
        case 16:
            let url = URL(string: "http://www.apeth.com/rez/test.docx")!
            self.wv.load(URLRequest(url: url))
        case 17:
            let url = URL(string: "http://www.apeth.com/rez/test.pages.zip")!
            self.wv.load(URLRequest(url: url))
        case 18:
            let url = URL(string: "http://www.apeth.com/rez/test.rtfd.zip")! // iOS 10, text but not image
            self.wv.load(URLRequest(url: url))
        default:
            break
        }
    }

    /// showing how to inject JavaScript dynamically (as opposed to at page-load time)
    func doDecreaseSize (_ sender: Any) {
        self.fontsize -= 1
        if self.fontsize < 10 {
            self.fontsize = 20
        }
        let s = self.cssrule
        self.wv.evaluateJavaScript(s)
    }

    deinit {
        print("dealloc")
        // using KVO, always tear down, take no chances
        self.wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.loading))
        self.wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        // with webkit, probably no need for this, but no harm done
        self.wv.stopLoading()
        // break all retains
        let ucc = self.wv.configuration.userContentController
        ucc.removeAllUserScripts()
        ucc.removeScriptMessageHandler(forName: "playbutton")
    }

    var whichNav = 0
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                print("user would like to navigate to \(url)")
                /// open in Mobile Safari
                switch whichNav {
                case 0:
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    decisionHandler(.cancel)
                    return
                case 1:
                    /// use the new Safari view controller
                    let svc = SFSafariViewController(url: url)
                    svc.restorationIdentifier = "sf" // doesn't help
                    // svc.delegate = self
                    self.present(svc, animated: true)
                    decisionHandler(.cancel)
                    return
                default:break
                }
            }
        }
        // must always call _something_
        decisionHandler(.allow)
    }

    func setWhichNav() {
        if whichNav == 0 {
            whichNav = 1
        } else {
            whichNav = 0
        }
    }

    /// new in iOS 9
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("process did terminate")
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated:true)
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("loaded svc")
    }

    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        if message.name == "playbutton" {
            if let body = message.body as? String {
                if body == "play" {
                    print("user would like to hear the podcast")
                }
            }
        }
    }
    
}


