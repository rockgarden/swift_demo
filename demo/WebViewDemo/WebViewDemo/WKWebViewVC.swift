//
//  WKWebViewVC.swift
//  WebViewDemo
//

import UIKit
import WebKit
import JavaScriptCore

//网页加载类型
enum WkWebLoadType{
    case loadWebURLString
    case loadWebHTMLString
    case POSTWebURLString
}

let FuncHistoryBack = "FuncHistoryBack"
let FuncAddHotelLike = "FuncAddHotelLike"
let FuncClickPhoto = "FuncClickPhoto"
let DocumentEnd = "DocumentEnd"

let jsGetHotelLikeSpanString = "function oc_getSpanLikeEle() {var spans = document.getElementsByTagName('span');var spanLike=null;for (var i=0;i<spans.length;i++) {var temp = spans[i];if (temp.className=='cr like like-act' || temp.className=='cr like') {spanLike = temp;return spanLike;}}}"
let jsChangeHotelLikeSpanMethod = "\(jsGetHotelLikeSpanString) function oc_changeLikeSpan(isLike) {var target = oc_getSpanLikeEle();if (isLike == 0 && $(target).hasClass('like-act')) {$(target).removeClass('like-act');}else if (isLike == 1 && $(target).hasClass('like')){$(target).removeClass('like-act');$(target).addClass('like-act');}}"

class WKWebViewVC: UIViewController, UIViewControllerRestoration {

    fileprivate var activity = UIActivityIndicatorView()
    fileprivate weak var webView : WKWebView!
    fileprivate var progressView: UIProgressView!
    fileprivate var decoded = false
    fileprivate var jsContext: JSContext?

    //保存的网址链接
    fileprivate var urltring: String!
    //保存POST请求体
    fileprivate var postData: String!
    //是否是第一次加载
    fileprivate var needLoadJSPOST:Bool?
    //保存请求链接
    fileprivate var snapShotsArray:Array<Any>?
    //加载类型
    fileprivate var loadWebType: WkWebLoadType?

    //关闭按钮
    fileprivate lazy var closeButtonItem: UIBarButtonItem = {
        let closeButtonItem = UIBarButtonItem.init(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(closeItemClicked))
        return closeButtonItem
    }()

    //返回按钮
    fileprivate lazy var customBackBarItem:UIBarButtonItem = {
        let backItemImage = UIImage.init(named: "backItemImage")
        let backItemHlImage = UIImage.init(named: "backItemImage-hl")
        let backButton = UIButton.init(type: .system)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(self.navigationController?.navigationBar.tintColor, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.setImage(backItemImage, for: .normal)
        backButton.setImage(backItemHlImage, for: .highlighted)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(customBackItemClicked), for: .touchUpInside)
        let customBackBarItem = UIBarButtonItem.init(customView: backButton)
        return customBackBarItem
    }()

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
        self.decoded = true
        super.decodeRestorableState(with:coder)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
    }

    override func applicationFinishedRestoringState() {
        print("finished restoring state", self.webView.url as Any)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addWkWebView()
    }

    /// 添加 WKWebView
    fileprivate func addWkWebView() {
        // 创建 WKWebView 实例
        let wv = WKWebView(frame: view.bounds, configuration: makeConfig())
        wv.restorationIdentifier = "wv"
        view.restorationIdentifier = "wvcontainer" // shouldn't be necessary...
        view.addSubview(wv)

        wv.scrollView.backgroundColor = .black // web view alone, ineffective
        wv.backgroundColor = UIColor.clear
        wv.scrollView.bounces = false
        wv.scrollView.alwaysBounceVertical = false
        wv.scrollView.isScrollEnabled = false

        // 若布局采用了 AutoLayout 必须使用 NSLayoutConstraint 来控制 WKWebView 的大小, 不然引起 html 页面大小缩放异常
        wv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|[wv]|", metrics: nil, views: ["wv":wv]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:|[wv]|", metrics: nil, views: ["wv":wv])
            ].flatMap{$0})

        addIndicatorView(wv)
        addProgressView(wv)

        /// webkit uses KVO 监听支持KVO的属性
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: .new, context: nil)
        // show title first
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: [.new], context: nil)

        wv.navigationDelegate = self
        wv.uiDelegate = self

        // 开启手势交互 take advantage of built-in "back" and "forward" swipe gestures
        wv.allowsBackForwardNavigationGestures = true
        wv.allowsBackForwardNavigationGestures = true
        wv.isMultipleTouchEnabled = true

        if #available(iOS 9.0, *) {wv.allowsLinkPreview = true}

        //内容自适应
        wv.sizeToFit()

        webView = wv
    }

    fileprivate func makeConfig() -> WKWebViewConfiguration {
        // 创建一个webiview的配置项
        let config = WKWebViewConfiguration()

        // Webview的偏好设置
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true

        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        // 通过js与webview内容交互配置
        config.userContentController = WKUserContentController()

        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(
            source: "function showAlert() { alert('在载入WKWebview时注入的JS方法'); }",
            injectionTime: .atDocumentStart,// 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
        config.userContentController.addUserScript(script)

        // 添加messageHandlers.name,就可以在JS通过这个名称发送消息
        // JS code: window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        config.userContentController.add(self, name: "AppModel")
        // JS code: window.webkit.messageHandlers.closeWindow.postMessage({body: 'xxx'})
        config.userContentController.add(self, name: "closeWindow")
        return config
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
            /*
             progressView.alpha = 1.0
             let animated = Float(webView.estimatedProgress) > progressView.progress
             progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
             if Float(webView.estimatedProgress) >= 1.0{
             UIView.animate(withDuration: 1, delay: 0.01, options: .curveEaseOut, animations:{()-> Void in
             self.progressView.alpha = 0.0
             },completion:{(finished:Bool) -> Void in
             self.progressView.setProgress(0.0, animated: false)
             })
             }
             */
        default:
            break
        }

        // 已经完成加载时，我们就可以做我们的事了
        if !webView.isLoading == true {
            // 手动调用JS代码
            let js = "callJsAlert()";
            webView.evaluateJavaScript(js) { (_, _) -> Void in
                debugPrint("call js alert")
            }
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                self.progressView.alpha = 0.0;
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("view did appear, req: \(self.webView.url)") // no evidence that restoration is being done for us

        // 添加前进、后退按钮
        let b = UIBarButtonItem(title:"Back", style:.done, target:self, action:#selector(goBack))
        let b1 = UIBarButtonItem(title: "后退", style:.done, target: self, action: #selector(goForward))
        self.navigationItem.rightBarButtonItems = [b,b1]

        if self.decoded {
            // return // forget it, just trying to see if I was in restoration's way, but I'm not
        }
        loadType()

        //webView.reload()
    }

    // webView is weak so viewDidDisappear & deinit don't need?
    override func viewDidDisappear(_ animated: Bool) {
        // with webkit, probably no need for this, but no harm done
        webView.stopLoading()
        removeScriptMessageHandler("AppModel")
        removeScriptMessageHandler("closeWindow")
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    fileprivate func removeScriptMessageHandler(_ name: String?) {
        if name != nil {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name!)
        }
    }

    deinit {
        // using KVO, always tear down, take no chances
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.loading))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    func goBack(_ sender: Any) {
        webView.goBack()
    }

    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}


extension WKWebViewVC {
    // 添加进度条
    fileprivate func addProgressView(_ wv: UIView) {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.backgroundColor = .clear
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .green
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: wv.topAnchor),
            progressView.centerXAnchor.constraint(equalTo: wv.centerXAnchor),
            progressView.widthAnchor.constraint(equalTo: wv.widthAnchor)
            ])
    }

    // prepare nice activity indicator to cover loading
    fileprivate func addIndicatorView(_ wv: UIView) {
        let act = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        activity = act
        wv.addSubview(act)
        act.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            act.centerXAnchor.constraint(equalTo: wv.centerXAnchor),
            act.centerYAnchor.constraint(equalTo: wv.centerYAnchor)
            ])
    }

    // 自定义返回按钮
    @objc fileprivate func customBackItemClicked() {
        if (webView.goBack() != nil) {
            webView.goBack()
        } else {
            _ = navigationController?.popViewController(animated: true) //pop Self
        }
    }

    // 关闭按钮
    @objc fileprivate func closeItemClicked() {
        _ = navigationController?.popViewController(animated: true)
    }

    fileprivate func loadType() {
        if loadWebType != nil {
            switch loadWebType! {
            case .loadWebURLString :
                let urlstr = URL.init(string: urltring!)
                let request = URLRequest.init(url: urlstr!)
                webView.load(request)
            case .loadWebHTMLString:
                loadHost(string: urltring!)
            case .POSTWebURLString:
                needLoadJSPOST = true
                loadHost(string: "WKJSPOST")
            }
        }
        loadHTML()
    }

    fileprivate func loadHTML() {
        /// 使用 Bundle 载入资源可避免 路径问题
        let htmlBundle = Bundle.main.url(forResource: "Html", withExtension: "bundle")
        let url = Bundle(url: htmlBundle!)?.url(forResource: "test", withExtension: "html")
        //let s = try! String(contentsOf: url!, encoding: .utf8)
        //wv.loadHTMLString(s, baseURL: htmlBundle)
        webView.load(URLRequest(url: url!))
    }

    fileprivate func loadHost(string: String) {
        let path = Bundle.main.path(forResource: string, ofType: "html")
        // 获得html内容
        do {
            let html = try String(contentsOfFile: path!, encoding: .utf8)
            // 加载js
            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        } catch { }
    }

    // 调用JS发送POST请求
    fileprivate func postRequestWithJS() {
        // 拼装成调用JavaScript的字符串 urltring请求的页面地址 postData发送POST的参数
        let jscript = "post('\(urltring!)', {\(postData!)});"
        // 调用JS代码
        webView.evaluateJavaScript(jscript) { (object, error) in
        }
    }

    /// 普通URL加载方式
    /// Parameter urlString: 需要加载的url字符串
    func loadUrlSting(string: String!) {
        urltring = string
        loadWebType = .loadWebURLString
    }

    /// 加载本地HTML
    /// Parameter urlString: 需要加载的本地文件名
    func loadHTMLSting(string: String!) {
        loadWebType = .loadWebHTMLString
        loadHost(string: string)
    }

    /// POST方式请求加载
    /// urlString: post请求的url字符串
    /// postString: post参数体 详情请搜索swift/oc转义字符（注意格式："\"username\":\"aaa\",\"password\":\"123\""）
    func loadPOSTUrlSting(string:String!,postString:String!) {
        loadWebType = .POSTWebURLString
        urltring = string
        postData = postString
    }

}


// MARK: WKNavigationDelegate
/// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。但是，对于Safari是允许跨域的，不用这么处理。
extension WKWebViewVC : WKNavigationDelegate {

    //服务器开始请求的时候调用
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint(#function)

        let hostname = (navigationAction.request as NSURLRequest).url?.host?.lowercased()
        debugPrint(hostname as Any)

        switch navigationAction.navigationType {
        case WKNavigationType.linkActivated:

            // 处理跨域问题
            if !hostname!.contains(".baidu.com") {
                // 手动跳转
                UIApplication.shared.openURL(navigationAction.request.url!)
                // 不允许导航
                decisionHandler(.cancel)
            } else {
                pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
                progressView.alpha = 1.0
                decisionHandler(.allow)
            }
            break
        case WKNavigationType.formSubmitted:
            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
            break
        case WKNavigationType.backForward:
            break
        case WKNavigationType.reload:
            break
        case WKNavigationType.formResubmitted:
            break
        case WKNavigationType.other:
            pushCurrentSnapshotView(navigationAction.request as NSURLRequest)
            break
        }
        //更新左边返回按钮
        updateNavigationItems()
        decisionHandler(.allow)
    }

    //请求链接处理
    fileprivate func pushCurrentSnapshotView(_ request: NSURLRequest) -> Void {
        guard let urlStr = snapShotsArray?.last else {
            return
        }
        let url = URL(string: urlStr as! String)
        let lastRequest = NSURLRequest(url: url!)

        //如果url是很奇怪的就不push
        if request.url?.absoluteString == "about:blank"{
            return
        }

        //如果url一样就不进行push
        if (lastRequest.url?.absoluteString == request.url?.absoluteString) {
            return
        }

        let currentSnapShotView = webView.snapshotView(afterScreenUpdates: true);

        //向数组添加字典
        snapShotsArray = [["request":request, "snapShotView":currentSnapShotView]]
    }

    fileprivate func updateNavigationItems(){
        if webView.canGoBack {
            let spaceButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spaceButtonItem.width = -6.5
            navigationItem.setLeftBarButtonItems([spaceButtonItem,customBackBarItem,closeButtonItem], animated: false)
        } else {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            navigationItem.setLeftBarButtonItems([customBackBarItem],animated: false)
        }
    }

    //进度条代理事件
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint(#function)
    }

    //内容返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint(#function)
    }

    //这个是网页加载完成，导航的变化
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint(#function)
        // 判断是否需要加载（仅在第一次加载）
        if needLoadJSPOST == true {
            // 调用使用JS发送POST请求的方法
            postRequestWithJS()
            // 将Flag置为NO（后面就不需要加载了）
            needLoadJSPOST = false
        }
        updateNavigationItems()
        title = webView.title
    }

    // 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
        progressView.isHidden = false
    }

    // 跳转失败的时候调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }

    // 服务器请求跳转的时候调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }

    // 内容加载失败时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        debugPrint(#function)
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        debugPrint(#function)
        completionHandler(.performDefaultHandling, nil)
    }

}


// MARK: WKUIDelegate
/// 不是必须实现的，但是如果我们的页面中有调用了js的alert、confirm、prompt方法，我们应该实现下面这几个代理方法，然后在原来这里调用native的弹出窗，因为使用WKWebView后，HTML中的alert、confirm、prompt方法调用是不会再弹出窗口了，只是转化成ios的native回调代理方法
extension WKWebViewVC: WKUIDelegate {

    // 获取js 里面的提示
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            completionHandler()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            completionHandler()
        }))

        self.present(alert, animated: true, completion: nil)
        self.present(alert, animated: true, completion: nil)
    }

    // js 信息的交流
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // We must call back js
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // 交互。可输入的文本。
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)

        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
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
        if message.name == "closeWindow" {
            _ = navigationController?.popViewController(animated: true)
        }
    }
}


