//
//  myJs.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/1/21.
//  Copyright © 2017年 apple. All rights reserved.
//
//  注入模型的交互
//


import UIKit
import JavaScriptCore

/*
 先定义一个协议，而且这个协议必须要遵守JSExport协议。
 All methods that should apply in Javascript,should be in the following protocol.
 注意，这里必须使用@objc，因为JavaScriptCore库是ObjectiveC版本的。如果不加@objc，则调用无效果
 */
@objc protocol JavaScriptSwiftDelegate: JSExport {
    func btnDs()
    func btnMe()
    func choose(b: Bool)
}

@objc class myJs: NSObject, JavaScriptSwiftDelegate {

    weak var controller: UIViewController?
    weak var jsContext: JSContext?

    func btnDs() {
        let jsFunc = self.jsContext?.objectForKeyedSubscript("jsFunc");
        _ = jsFunc?.call(withArguments: [])
    }

    internal func btnMe() {
    }

    internal func choose(b: Bool) {
        let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc");
        _ = jsParamFunc?.call(withArguments: [b])
    }

    func callSystemCamera() {
        print("js call objc method: callSystemCamera");

        let jsFunc = self.jsContext?.objectForKeyedSubscript("jsFunc");
        jsFunc?.call(withArguments: []);
    }

    func showAlert(_ title: String, msg: String) {
        DispatchQueue.main.async { () -> Void in
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }

    // JS调用了我们的方法
    func callWithDict(_ dict: [String : AnyObject]) {
        print("js call objc method: callWithDict, args: %@", dict)
    }

    // JS调用了我们的就去
    func jsCallObjcAndObjcCallJsWithDict(_ dict: [String : AnyObject]) {
        print("js call objc method: jsCallObjcAndObjcCallJsWithDict, args: %@", dict)

        let jsParamFunc = self.jsContext?.objectForKeyedSubscript("jsParamFunc");
        let dict = NSDictionary(dictionary: ["age": 18, "height": 168, "name": "lili"])
        jsParamFunc?.call(withArguments: [dict])
    }
}
