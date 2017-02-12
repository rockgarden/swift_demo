//
//  BKWebBridgeDemo.swift
//  WKWebView和 JS 交互
//


import UIKit
import WebKit
import AVFoundation

class BKWebBridgeDemo: UIViewController {

    var webView : WKWebView?
    var bridge : BKWebBridge?
    var player : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let config                  = WKWebViewConfiguration()
        let preferences             = WKPreferences()
        preferences.minimumFontSize = 40.0 // 设置网页字体大小
        config.preferences          = preferences
      
        self.webView            = WKWebView(frame:UIScreen.main.bounds, configuration: config)
        self.webView?.backgroundColor = UIColor.red
        self.view.addSubview(self.webView!)
        
        let filePath        = Bundle.main.path(forResource: "index.html", ofType: nil)
        let url : URL       = URL(fileURLWithPath: filePath!)
        let reqeust         = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 15.0)
        let _ = self.webView?.load(reqeust)
        
        self.bridge = BKWebBridge(webView: self.webView!)

        javaScriptCallOC()
        runJavaScript()
    
    }
    
    /// JS 调用 OC 代码
    func javaScriptCallOC() {

        // 扫一扫功能
        self.bridge?.registerHandler("ScanAction", handle: { data in
            print("扫一扫")
        })
        
        // 播放声音
        self.bridge?.registerHandler("PlaySound", handle: { data in
            print("播放声音")
            self.playSound()
        })
        
        // 获取定位
        self.bridge?.registerHandler("Location", handle: { (data) in
            print("获取定位")
            self.getLocation()
        })
    }

    fileprivate func getLocation() {
        runJavaScript()
    }

    /// 调用 JS 代码 并给 JS 传递参数
    fileprivate func runJavaScript() {
        let js = "setLocation('广东省深圳市南山区学府路XXXX号')"

        // 执行 JS代码 拼写完整的 js 代码
        self.bridge?.runJavaScript(js, completionHandler: { (callBack) in
            print(callBack.errroMsg ?? "")
        })
        
        // 第二种参数单独拼写 js 方法名 + 参数 参数仅支持 String 类型
        // js 代码对应  setLocation('广东省深圳市南山区学府路XXXX号')
        self.bridge?.runJavaScript("setLocation", data:"'上海市宝山区顾村镇'", completionHandler: { (result) in
            print(result.errroMsg ?? "")
            
        })
        
        // 第三种参数放字典里边 js 方法名 + 参数 参数仅支持 [:] 类型
        // 完整的 js 代码如下
        // edirect_to_order_success({return_code: 200, return_message: '成功' })
//        self.bridge?.runJavaScript("setLocation", data:["return_code" : 200,return_message : "'成功过'"], completionHandler: { (result) in
//            print(result.errroMsg ?? "")
//        })
    }
    
    /// 播放声音
    func playSound() {
        let path = Bundle.main.path(forResource: "shake_sound_male.wav", ofType: nil)
        let url : URL       = URL(fileURLWithPath: path!)
        let player          = try? AVAudioPlayer(contentsOf: url)
        player?.volume      = 10
        player?.prepareToPlay()
        player?.play()
        self.player = player
    }

}

