//
//  ViewController.swift
//  WebViewDemo
//

import UIKit

class WebViewRoot: UITableViewController {
    
    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            switch id {
            case 0 :
                let wvc = WebViewVC()
                self.navigationController!.pushViewController(wvc, animated:true)
            case 1 :
                let wvc = NoNavigationWebViewVC()
                self.navigationController!.pushViewController(wvc, animated:true)
            case 2 :
                let wvc = WKWebViewVC()
                //wvc.loadUrlSting(string: "https://www.baidu.com")
                self.navigationController!.pushViewController(wvc, animated:true)
            case 3 :
                let wvc = UIWeb2JsVC()
                self.navigationController!.pushViewController(wvc, animated:true)
            case 4 :
                let wvc = WKWeb2JsVC()
                show(wvc, sender: nil)
            case 5 :
                let wvc = OldLocalHTML()
                show(wvc, sender: nil)
            case 6 :
                break
            case 7 :
                let wvc = BKWebBridgeDemo()
                show(wvc, sender: nil)
            case 8 :
                let wvc = SaveWebImageVC()
                show(wvc, sender: nil)
            default:
                break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WebView Start"
    }

}

