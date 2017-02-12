//
//  WKMagicBridgeDemo.swift
//  WebViewDemo
//

import UIKit
import WebKit

class WKMagicBridgeDemo: UIViewController, WKNavigationDelegate {
    let webView = WKWebView()
    var bridge: WKMagicBridge!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        bridge = WKMagicBridge(webView: webView)
        setUpMagicBridge()

        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "https://www.mozilla.org")!))
    }

    func setUpMagicBridge() {
        let path = Bundle.main.path(forResource: "Sample", ofType: "js")!
        let source = try! String(contentsOfFile: path)
        let script = WKMagicBridgeScript(source: source, injectionTime: .atDocumentEnd)
        bridge.addUserScript(script)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Posting PageTitle message")
        bridge.postMessage(handlerName: "PageTitle", data: nil) { response in
            print("Page title response: \(response!)")
        }
    }
}
