//
//  JSModel.swift
//  WebViewDemo
//
//  Created by wangkan on 2017/1/21.
//  Copyright © 2017年 apple. All rights reserved.
//
//  Swift2JS通过注入模型交互
//


import UIKit
import JavaScriptCore

/*
 先定义一个协议，而且这个协议必须要遵守JSExport协议。
 借助JSExport协议可以在JavaScript上使用自定义对象。在JSExport协议中声明的实例方法、类方法，不论属性，都能自动与JavaScrip交互。
 All methods that should apply in Javascript,should be in the following protocol.
 注意: Custom protocol must be declared with `@objc`，因为JavaScriptCore库是ObjectiveC版本的。如果不加@objc，则调用无效果
 */
@objc protocol JavaScriptSwiftDelegate: JSExport {
    func btnDs()
    func btnMe()
    func choose(b: Bool)
    func callSystemCamera()
    func showAlertMsg(_ title: String, msg: String)
    func callWithDict(_ dict: [String: AnyObject])
    func jsCallObjcAndObjcCallJsWithDict(_ dict: [String: AnyObject])
    // js调用App的微信支付功能 演示最基本的用法
    func wxPay(_ orderNo: String)
    // js调用App的微信分享功能 演示字典参数的使用
    func wxShare(_ dict: [String: AnyObject])
    //js调用app的提示框
    func showDialog(_ title: String, message: String)
    //js执行app方法后的回掉
    func callHandler(_ handleFuncName: String)
}

/// 定义一个模型,Custom class must inherit from `NSObject`
@objc class JSModel: NSObject, JavaScriptSwiftDelegate {

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
        print("js call objc method: callSystemCamera")
        // JS调用Siwft方法时,也让Swift反馈给JS,通过objectForKeyedSubscript方法来获取变量jsFunc
        let jsFunc = jsContext?.objectForKeyedSubscript("jsFunc");
        _ = jsFunc?.call(withArguments: [])
    }

    // FIXME: 无法调用
    func showAlertMsg(_ title: String, msg: String) {
        print("js call objc method: showAlertMsg")
        DispatchQueue.main.async { _ in
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
        _ = jsParamFunc?.call(withArguments: [dict])
    }
    
    func wxPay(_ orderNo: String) {
        print("订单号：", orderNo)
    }
    
    func wxShare(_ dict: [String: AnyObject]) {
        print("分享信息：", dict)
    }
    
    func showDialog(_ title: String, message: String){
        DispatchQueue.main.async { _ in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
    }
    
    func callHandler(_ handleFuncName: String) {
        let handleFunc = jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name":"seen","age":18] as [String : Any]
        let handle = handleFunc?.call(withArguments: [dict])
        print("\(handle)-------test")
    }

}

