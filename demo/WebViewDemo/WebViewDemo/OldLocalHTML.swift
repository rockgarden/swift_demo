//
//  OldLocalHTML.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/2/7.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit
import WebKit

class OldLocalHTML: UIViewController, UIViewControllerRestoration, WKScriptMessageHandler, WKNavigationDelegate {
    
    var webView: WKWebView?
    var decoded = false
    var buttonClicked = 0
    var colors:[String] = ["0xff00ff","#ff0000","#ffcc00","#ccff00","#ff0033","#ff0099","#cc0099","#0033ff","#0066ff","#ffff00","#0000ff","#0099cc"];
    var webConfig:WKWebViewConfiguration {
        get {
            // Create WKWebViewConfiguration instance
            let webCfg = WKWebViewConfiguration()
            
            // Setup WKUserContentController instance for injecting user script
            let userController = WKUserContentController()
            
            // Add a script message handler for receiving  "buttonClicked" event notifications posted from the JS document using window.webkit.messageHandlers.buttonClicked.postMessage script message
            userController.add(self, name: "buttonClicked")
            
            // Get script that's to be injected into the document
            let js:String = buttonClickEventTriggeredScriptToAddToDocument()
            
            // Specify when and where and what user script needs to be injected into the web document
            let userScript =  WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
            
            // Add the user script to the WKUserContentController instance
            userController.addUserScript(userScript)
            
            // Configure the WKWebViewConfiguration instance with the WKUserContentController
            webCfg.userContentController = userController
            
            return webCfg
        }
    }
    
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
    }
    
    override func loadView() {
        print("loadView")
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a WKWebView instance
        webView = WKWebView (frame: self.view.frame, configuration: webConfig)
        
        // Delegate to handle navigation of web content
        webView!.navigationDelegate = self
        
        view.addSubview(webView!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Load the HTML document
        loadHtml()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let fileName =  String("\( ProcessInfo.processInfo.globallyUniqueString)_TestFile.html")
        
        var error: NSError?
        let tempHtmlPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(atPath: tempHtmlPath)
        } catch let error1 as NSError {
            error = error1
        }
        webView = nil
    }
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("%s", #function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("%s. With Error %@", #function,error)
        showAlertWithMessage("Failed to load file with error \(error.localizedDescription)!")
    }
    
    // File Loading
    func loadHtml() {
        // NOTE: Due to a bug in webKit as of iOS 8.1.1 we CANNOT load a local resource when running on device. Once that is fixed, we can get rid of the temp copy
        let mainBundle = Bundle(for: OldLocalHTML.self)
        var error: NSError?
        
        let fileName =  String("\( ProcessInfo.processInfo.globallyUniqueString)_TestFile.html")
        
        let tempHtmlPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(fileName)
        
        if let htmlPath = mainBundle.path(forResource: "TestFile", ofType: "html") {
            do {
                try FileManager.default.copyItem(atPath: htmlPath, toPath: tempHtmlPath)
            } catch var error1 as NSError {
                error = error1
            }
            if tempHtmlPath != nil {
                let requestUrl = URLRequest(url: URL(fileURLWithPath: tempHtmlPath))
                webView?.load(requestUrl)
            }
        }
        else {
            showAlertWithMessage("Could not load HTML File!")
        }
    }
    
    // Button Click Script to Add to Document
    func buttonClickEventTriggeredScriptToAddToDocument() ->String{
        // Script: When window is loaded, execute an anonymous function that adds a "click" event handler function to the "ClickMeButton" button element. The "click" event handler calls back into our native code via the window.webkit.messageHandlers.buttonClicked.postMessage call
        var script:String?

        if let filePath = Bundle(for: OldLocalHTML.self).path(forResource: "ClickMeEventRegister", ofType:"js") {
            script = try? String (contentsOfFile: filePath, encoding: .utf8)
        }
        return script!
    }
    
    // WKScriptMessageHandler Delegate
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody:NSDictionary = message.body as? NSDictionary {
            let idOfTappedButton:String = messageBody["ButtonId"] as! String
            updateColorOfButtonWithId(idOfTappedButton)
        }
    }
    
    // Update color of Button with specified Id
    func updateColorOfButtonWithId(_ buttonId: String) {
        let count = UInt32(colors.count)
        let index = Int(arc4random_uniform(count))
        let color: String = colors [index]
        
        // Script that changes the color of tapped button
        let js2 = String(format: "var button = document.getElementById('%@'); button.style.backgroundColor='%@';", buttonId,color)
        
        webView?.evaluateJavaScript(js2, completionHandler: { (AnyObject, NSError) -> Void in
            NSLog("%s", #function)
        })
    }
    
    // Helper
    func showAlertWithMessage(_ message:String) {
        let alertAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: { () -> Void in
            })
        }
        
        let alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(alertAction)
        
        self.present(alertView, animated: true, completion: { () -> Void in
        })
    }
    
}


