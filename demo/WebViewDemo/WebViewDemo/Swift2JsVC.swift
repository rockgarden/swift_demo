//
//  Swift2JsVC.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/1/25.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class Swift2JsVC: UIViewController, UIViewControllerRestoration {

    weak var wv : WKWebView!
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
        wv.addObserver(self, forKeyPath: #keyPath(WKWebView.loading), options: .new, context: nil)

    }

    fileprivate func wKWVConfig() -> WKWebViewConfiguration {
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuretion.userContentController = WKUserContentController()
        return configuretion
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? WKWebView else {return}
        guard let keyPath = keyPath else {return}
        guard let change = change else {return}
        switch keyPath {
        case "loading": // new:1 or 0
            if let val = change[.newKey] as? Bool {
                if val {
                    doJS()
                    addJScript()
                } else {}
            }
        default:break
        }

        // 已经完成加载时，我们就可以做我们的事了
        if !wv.isLoading == true {
            doJS()
        }
    }

    //MARK: Swift2JS-Model注入
    // 注入时间: UIWebViewDelegate func webViewDidFinishLoad(_ webView: UIWebView) 时注入 JSModel
    func addJScript() {
        // 通过webView的valueForKeyPath获取的
        let context = wv.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        let model = JSModel()
        model.controller = self
        model.jsContext = context
        self.jsContext = context

        /// 这一步是将JSModel这个模型注入到JS中，在JS就可以通过JSModel调用我们公暴露的方法了。
        self.jsContext?.setObject(model, forKeyedSubscript: "OCModel" as (NSCopying & NSObjectProtocol)!)
        let url = Bundle.main.url(forResource: "test", withExtension: "html")
        self.jsContext?.evaluateScript(try? String(contentsOf: url!, encoding: .utf8));
        self.jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception @", exception as Any)
        }
    }

    //MARK: Swift2JS-直接调用
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.url)")
        if self.decoded { }

        if loadLocal {
            loadHTML()
        } else { }
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
        wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.loading))
    }

}


