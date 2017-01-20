//
//  WKWebViewVC.swift
//  WebViewDemo
//

import UIKit
import WebKit
import JavaScriptCore

class WKWebViewVC: UIViewController, UIViewControllerRestoration {
    
    var activity = UIActivityIndicatorView()
    weak var wv : WKWebView!
    var progressView: UIProgressView!
    var decoded = false
    var loadLocal = true
    var jsContext: JSContext?

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "wvc"
        self.restorationClass = type(of:self)
        self.edgesForExtendedLayout = [] // none, get accurate offset restoration
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    class func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        return self.init(nibName:nil, bundle:nil)
    }

    // unfortunately I see no evidence that the web view is assisting us at all!
    // the view is not coming back with its URL restored etc, as a UIWebView does

    override func decodeRestorableState(with coder: NSCoder) {
        print("decode")
        self.decoded = true
        super.decodeRestorableState(with:coder)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        print("encode")
        super.encodeRestorableState(with:coder)
    }

    override func applicationFinishedRestoringState() {
        print("finished restoring state", self.wv.url as Any)
    }

    override func loadView() {
        print("loadView")
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")

        let wv = WKWebView(frame: self.view.bounds, configuration: wKWVConfig())
        wv.restorationIdentifier = "wv"
        view.restorationIdentifier = "wvcontainer" // shouldn't be necessary...
        wv.scrollView.backgroundColor = .black // web view alone, ineffective
        view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[wv]|", metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[wv]|", metrics: nil, views: ["wv":wv])
            ].flatMap{$0})
        self.wv = wv

        // take advantage of built-in "back" and "forward" swipe gestures
        wv.allowsBackForwardNavigationGestures = true

        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            act.centerXAnchor.constraint(equalTo:wv.centerXAnchor),
            act.centerYAnchor.constraint(equalTo:wv.centerYAnchor)
            ])

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.backgroundColor = .clear
        view.addSubview(self.progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo:wv.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo:wv.centerXAnchor),
            progressView.widthAnchor.constraint(equalTo:wv.widthAnchor)
            ])

        /// webkit uses KVO 监听支持KVO的属性
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: .new, context: nil)
        // show title first
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        wv.navigationDelegate = self
        wv.uiDelegate = self
    }

    fileprivate func wKWVConfig() -> WKWebViewConfiguration {
        // 创建一个webiview的配置项
        let configuretion = WKWebViewConfiguration()
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(
            source: "function showAlert() { alert('在载入WKWebview时注入的JS方法'); }",
            injectionTime: .atDocumentStart,// 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
        configuretion.userContentController.addUserScript(script)
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        configuretion.userContentController.add(self, name: "AppModel")
        return configuretion
    }

    // UIWebViewDelegate func webViewDidFinishLoad(_ webView: UIWebView) 时注入
    func addJScript() {
        let context = wv.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = myJs()
        model.controller = self
        model.jsContext = context
        self.jsContext = context

        // 这一步是将OCModel这个模型注入到JS中，在JS就可以通过OCModel调用我们公暴露的方法了。
        self.jsContext?.setObject(model, forKeyedSubscript: "OCModel" as (NSCopying & NSObjectProtocol)!)
        let url = Bundle.main.url(forResource: "test", withExtension: "html")
        self.jsContext?.evaluateScript(try? String(contentsOf: url!, encoding: .utf8));

        self.jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception as Any)
        }
    }

    /// 不通过模型来调用方法，也可以直接调用方法
    func doJS() {
        let context = JSContext()
        context?.evaluateScript("var num = 10")
        context?.evaluateScript("function square(value) { return value * 2}")
        // 直接调用
        let squareValue = context?.evaluateScript("square(num)")
        print(squareValue as Any)

        // 通过下标来获取到JS方法。
        let squareFunc = context?.objectForKeyedSubscript("square")
        print(squareFunc?.call(withArguments: ["10"]).toString() as Any);
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? WKWebView else {return}
        guard let keyPath = keyPath else {return}
        guard let change = change else {return}
        switch keyPath {
        case "loading": // new:1 or 0
            if let val = change[.newKey] as? Bool {
                if val {
                    activity.startAnimating()
                } else {
                    activity.stopAnimating()
                }
            }
        case "title":
            if let val = change[.newKey] as? String {
                self.navigationItem.title = val
            }
            //self.title = wv.title
        case "estimatedProgress":
            if let val = change[.newKey] as? Float {
                //progressView.isHidden = false
                progressView.setProgress(val, animated: true)
            } else {
                //progressView.isHidden = true
            }
        default:break
        }

        // 已经完成加载时，我们就可以做我们的事了
        if !wv.isLoading {
            // 手动调用JS代码
            let js = "callJsAlert()";
            wv.evaluateJavaScript(js) { (_, _) -> Void in
                debugPrint("call js alert")
            }
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                self.progressView.alpha = 0.0;
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.url)") // no evidence that restoration is being done for us

        let b = UIBarButtonItem(title:"Back", style:.done, target:self, action:#selector(goBack))
        let b1 = UIBarButtonItem(title: "后退", style: .done, target: self, action: #selector(goForward))
        self.navigationItem.rightBarButtonItems = [b,b1]

        if self.decoded {
            // return // forget it, just trying to see if I was in restoration's way, but I'm not
        }

        if loadLocal {
            loadHTML()
        } else {
            let url = URL(string: "http://www.apeth.com/RubyFrontierDocs/default.html")!
            self.wv.load(URLRequest(url:url))
        }
    }

    fileprivate func loadHTML() {
        let htmlBundle = Bundle.main.url(forResource: "Html", withExtension: "bundle")
        let url = Bundle(url: htmlBundle!)?.url(forResource: "test", withExtension: "html")
        let s = try! String(contentsOf: url!, encoding: .utf8)
        //wv.loadHTMLString(s, baseURL: htmlBundle)
        wv.scrollView.isScrollEnabled = false
        wv.load(URLRequest(url: url!))
    }

    deinit {
        print("dealloc")
        // using KVO, always tear down, take no chances
        wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.loading))
        wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        // with webkit, probably no need for this, but no harm done
        wv.stopLoading()
        wv.configuration.userContentController.removeScriptMessageHandler(forName: "AppModel")
    }

    func goBack(_ sender: Any) {
        wv.goBack()
    }

    func goForward() {
        if wv.canGoForward {
            wv.goForward()
        }
    }
}


// MARK: WKNavigationDelegate
/// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。但是，对于Safari是允许跨域的，不用这么处理。
extension WKWebViewVC : WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        let hostname = (navigationAction.request as NSURLRequest).url?.host?.lowercased()
        print(hostname as Any)
        // 处理跨域问题
        if navigationAction.navigationType == .linkActivated && !hostname!.contains(".baidu.com") {
            // 手动跳转
            UIApplication.shared.openURL(navigationAction.request.url!)
            // 不允许导航
            decisionHandler(.cancel)
        } else {
            self.progressView.alpha = 1.0
            decisionHandler(.allow)
        }
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        print("did commit \(navigation)")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("did fail")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("did fail provisional")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("did finish")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("did start provisional")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
        completionHandler(.performDefaultHandling, nil)
    }

}


// MARK: WKUIDelegate
extension WKWebViewVC: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print(#function)
    }
}


// MARK: WKScriptMessageHandler
extension WKWebViewVC: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        if message.name == "AppModel" {
            print("message name is AppModel")
        }
    }
}


