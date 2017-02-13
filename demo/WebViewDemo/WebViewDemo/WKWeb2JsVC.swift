//
//  WKWeb2JsVC.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/1/25.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class WKWeb2JsVC: UIViewController, UIViewControllerRestoration {

    weak var wv : WKWebView!
    var decoded = false
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
        self.decoded = true
        super.decodeRestorableState(with:coder)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with:coder)
    }

    override func applicationFinishedRestoringState() {
        print("finished restoring state", self.wv.url as Any)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
                } else {}
            }
        default:break
        }

        // 已经完成加载时，我们就可以做我们的事了
        if !wv.isLoading == true {
            addJScript()
        }
    }

    //MARK: JavaScriptCore
    // 注入时间: UIWebViewDelegate func webViewDidFinishLoad(_ webView: UIWebView) 时注入 JSModel
    func addJScript() {
        let context = JSContext()
        // export Person class
        context?.setObject(Person.self, forKeyedSubscript: "Person" as (NSCopying & NSObjectProtocol)!)
        
        // load *.js
        if let JSString = try? String(contentsOfFile:"...", encoding: .utf8) {
            _ = context?.evaluateScript(JSString)
        }
        
        // get JSON string 加载JSON数据，并在JSContext中调用，将其解析到Person对象数组中，再用Mustache模板渲染即可
        if let peopleJSON = try? String(contentsOfFile:"...", encoding: .utf8) {
            // get load function
            let load = context?.objectForKeyedSubscript("loadPeopleFromJSON")
            // call with JSON and convert to an array of `Person`
            if let people = load?.call(withArguments: [peopleJSON]).toArray() as? [Person] {
                
                // get rendering function and create template
                let mustacheRender = context?.objectForKeyedSubscript("Mustache").objectForKeyedSubscript("render")
                let template = "{{getFullName}}, born {{birthYear}}"
                
                // loop through people and render Person object as string
                for person in people {
                    print(mustacheRender?.call(withArguments: [template, person]) as Any)
                }  
            }  
        }
    }
    //JSON
//    [
//    { "first": "Grace",     "last": "Hopper",   "year": 1906 },
//    { "first": "Ada",       "last": "Lovelace", "year": 1815 },
//    { "first": "Margaret",  "last": "Hamilton", "year": 1936 }
//    ]

    //MARK:  JSContext / JSValue:
    /// JSContext is an environment for running JavaScript code. A JSContext instance represents the global object in the environment—if you’ve written JavaScript that runs in a browser, JSContext is analogous to window. After creating a JSContext, it’s easy to run JavaScript code that creates variables, does calculations, or even defines functions
    func doJS() {        
        let context = JSContext()!
        context.evaluateScript("var num = 5 + 5")
        context.evaluateScript("var names = ['Grace', 'Ada', 'Margaret']")
        context.evaluateScript("var triple = function(value) { return value * 3 }")
        /// As that last line shows, any value that comes out of a JSContext is wrapped in a JSValue object. A language as dynamic as JavaScript requires a dynamic type, so JSValue wraps every possible kind of JavaScript value: strings and numbers; arrays, objects, and functions; even errors and the special JavaScript values null and undefined.
        let tripleNum: JSValue = context.evaluateScript("triple(num)")
        print("Tripled: \(tripleNum.toInt32())")
        
        /// Subscripting Values
        /// We can easily access any values we’ve created in our context using subscript notation on both JSContext and JSValue instances. JSContext requires a string subscript, while JSValue allows either string or integer subscripts for delving down into objects and arrays:
        let names = context.objectForKeyedSubscript("names")
        let initialName = names?.objectAtIndexedSubscript(0)
        print("The first name: \(initialName?.toString())")
        
        /// Calling Functions
        let tripleFunction = context.objectForKeyedSubscript("triple")
        let result = tripleFunction?.call(withArguments: [5])
        print("Five tripled: \(result?.toInt32())")
        
        /// Exception Handling
        /// JSContext has another useful trick up its sleeve: by setting the context’s exceptionHandler property, you can observe and log syntax, type, and runtime errors as they happen. exceptionHandler is a callback handler that receives a reference to the JSContext and the exception itself:
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        
        context.evaluateScript("function multiply(value1, value2) { return value1 * value2 ")
        // JS Error: SyntaxError: Unexpected end of script
        
        /// JavaScript Calling by Blocks
        /// When an Objective-C block is assigned to an identifier in a JSContext, JavaScriptCore automatically wraps the block in a JavaScript function. This makes it simple to use Foundation and Cocoa classes from within JavaScript—again, all the bridging happens for you. Witness the full power of Foundation string transformations, now accessible to JavaScript:
        let simplifyString: @convention(block) (String) -> String = { input in
            let result = input.applyingTransform(StringTransform.toLatin, reverse: false)
            return result?.applyingTransform(StringTransform.stripCombiningMarks, reverse: false) ?? ""
        }
        context.setObject(unsafeBitCast(simplifyString, to: AnyObject.self), forKeyedSubscript: "simplifyString" as (NSCopying & NSObjectProtocol)!)
        
        print(context.evaluateScript("simplifyString('안녕하새요!')"))

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear, req: \(self.wv.url)")
        if self.decoded { }
        loadHTML()
    }

    fileprivate func loadHTML() {
        let htmlBundle = Bundle.main.url(forResource: "Html", withExtension: "bundle")
        let url = Bundle(url: htmlBundle!)?.url(forResource: "test", withExtension: "html")
        //let s = try! String(contentsOf: url!, encoding: .utf8)
        //wv.loadHTMLString(s, baseURL: htmlBundle)
        wv.scrollView.isScrollEnabled = false
        wv.load(URLRequest(url: url!))
    }

    deinit {
        wv.removeObserver(self, forKeyPath: #keyPath(WKWebView.loading))
    }

}


