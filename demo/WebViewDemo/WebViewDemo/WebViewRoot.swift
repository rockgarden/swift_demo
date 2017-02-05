//
//  ViewController.swift
//  WebViewDemo
//

import UIKit

class WebViewRoot: UIViewController {

    @IBAction func doButton (_ sender: Any!) {
        let wvc = WebViewVC()
        self.navigationController!.pushViewController(wvc, animated:true)
    }

    @IBAction func showNoNav (_ sender: Any!) {
        let wvc = NoNavigationWebViewVC()
        self.navigationController!.pushViewController(wvc, animated:true)
    }

    @IBAction func showWKWeb (_ sender: Any!) {
        let wvc = WKWebViewVC()
        self.navigationController!.pushViewController(wvc, animated:true)
    }

    @IBAction func showSwift2JS (_ sender: Any!) {
        let wvc = UIWeb2JsVC()
        self.navigationController!.pushViewController(wvc, animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Start"
    }

}

