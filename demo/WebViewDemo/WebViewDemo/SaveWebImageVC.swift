//
//  SaveWebImageVC
//

import UIKit

class SaveWebImageVC: UIViewController, UIWebViewDelegate {
    
    var myWebView: UIWebView! {
        return self.view as! UIWebView
    }
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Vars & Lets
    let kTouchJavaScriptString: String = "document.ontouchstart=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:start:\"+x+\":\"+y;};document.ontouchmove=function(event){x=event.targetTouches[0].clientX;y=event.targetTouches[0].clientY;document.location=\"myweb:touch:move:\"+x+\":\"+y;};document.ontouchcancel=function(event){document.location=\"myweb:touch:cancel\";};document.ontouchend=function(event){document.location=\"myweb:touch:end\";};"
    var _gesState: Int = 0, _imgURL: String = "", _timer: Timer = Timer()
    /*
     _gesState {
     none : 0,
     start : 1,
     move : 2,
     end = 4,
     }
     */

    override func loadView() {
        let wv = UIWebView()
        self.view = wv
        wv.delegate = self
        
        // prepare nice activity indicator to cover loading
        let act = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
        act.backgroundColor = UIColor(white:0.1, alpha:0.5)
        self.activityIndicator = act
        wv.addSubview(act)
        
        act.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerX, relatedBy: .equal, toItem: wv, attribute: .centerX, multiplier: 1, constant: 0)
        )
        self.view.addConstraint(
            NSLayoutConstraint(item: act, attribute: .centerY, relatedBy: .equal, toItem: wv, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith _request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if (_request.url?.absoluteString == "about:blank") {
            return false
        }
        
        let requestString: String = (_request.url?.absoluteString)!
        var components: [String] = requestString.components(separatedBy: ":")
        if (components.count > 1 && components[0] == "myweb") {
            if (components[1] == "touch") {
                if (components[2] == "start") {
                    _gesState = 1
                    let ptX: Float = Float(components[3])!
                    let ptY: Float = Float(components[4])!
                    let js: String = "document.elementFromPoint(\(ptX), \(ptY)).tagName"
                    let tagName: String = myWebView.stringByEvaluatingJavaScript(from: js)!
                    _imgURL = ""
                    if (tagName == "IMG") {
                        _imgURL = myWebView.stringByEvaluatingJavaScript(from: "document.elementFromPoint(\(ptX), \(ptY)).src")!
                        _timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(handleLongTouch), userInfo: nil, repeats: false)
                    }
                } else {
                    if (components[2] == "move") {
                        self._gesState = 2
                    } else {
                        if (components[2] == "end") {
                            _timer.invalidate()
                            self._timer = Timer()
                            self._gesState = 4
                        }
                    }
                }
            }
            return false
        }
        return true
    }
    
    func handleLongTouch() {
        let hokusai = Hokusai()
        _ = hokusai.addButton("Save") {
            Drop.down("Saving...", state: DropState.info)
            self.saveImage()
        }
        hokusai.show()
    }
    
    func saveImage () {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            do {
                let data = try Data(contentsOf: URL(string: self._imgURL)!)
                let getImage = UIImage(data: data)
                let newImagePNG = UIImagePNGRepresentation(getImage!)
                _ = UIImage(data: newImagePNG!)
                // Save to album
            }
            catch {
                Drop.down("Failed", state: DropState.error)
                return
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        if didFinishSavingWithError != nil {
            Drop.down("Failed", state: DropState.error)
            return
        }
        Drop.down("Success", state: DropState.success)
    }
    
    // MARK: - Functions
    func loadWebPage () {
        self.myWebView.loadRequest(URLRequest(url: URL(string: "https://education.github.com/")!))
    }
    
    // MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        loadWebPage()
    }
    
    // MARK: - UIWebView delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        myWebView.stringByEvaluatingJavaScript(from: kTouchJavaScriptString)
    }
}
