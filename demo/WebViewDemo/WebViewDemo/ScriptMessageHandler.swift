//
//  ScriptMessageHandler.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit
import WebKit

protocol ScriptMessageHandlerDelegate : NSObjectProtocol {
    @available(iOS 8.0, *)
    func scriptHandlerUserController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)->Void
}


@available(iOS 8.0, *)
class ScriptMessageHandler: NSObject,WKScriptMessageHandler {

    weak var handlerDelegate:ScriptMessageHandlerDelegate?
    
    init(handlerDelegate:ScriptMessageHandlerDelegate){
        self.handlerDelegate = handlerDelegate
    }
    
    @objc func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.handlerDelegate?.scriptHandlerUserController(userContentController, didReceiveScriptMessage: message)
    }
    
}
