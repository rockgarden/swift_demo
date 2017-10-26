/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import WebKit

public typealias WKMagicHandler = (WKScriptMessage, WKMagicResponse) -> ()
public typealias WKMagicResponse = (AnyObject?) -> ()

class JSONSerializationError: Error {}

public enum WKMagicBridgeScriptInjectionTime {
    case atDocumentStart
    case atDocumentEnd
}

open class WKMagicBridgeScript {
    let source: String
    let injectionTime: WKMagicBridgeScriptInjectionTime

    public init(source: String, injectionTime: WKMagicBridgeScriptInjectionTime) {
        self.source = source
        self.injectionTime = injectionTime
    }
}

// TODO: Allow multiple bridges?
open class WKMagicBridge: NSObject, WKScriptMessageHandler {
    let bundle = Bundle(identifier: "WKMagicBridge")!
    let secret = UUID().uuidString
    let sharedSource: String
    let webView: WKWebView
    let isolatedContext: Bool

    open internal(set) var userScripts = [WKMagicBridgeScript]()
    var injectedScript: WKUserScript?

    var handlerMap = [String: WKMagicHandler]()
    var responseID = 0
    var responseMap = [Int: WKMagicResponse]()

    public init(webView: WKWebView, isolatedContext: Bool = true) {
        self.webView = webView
        self.isolatedContext = isolatedContext

        let shared = bundle.path(forResource: "WKMagicBridge", ofType: "js")!
        sharedSource = try! String(contentsOfFile: shared)

        super.init()

        webView.configuration.userContentController.add(self, name: "__wkutilsHandler__")
    }

    func rebuildScripts() {
        let startScripts = userScripts.flatMap { ($0.injectionTime == .atDocumentStart) ? $0.source : nil }.joined(separator: "\n")
        let endScripts = userScripts.flatMap { ($0.injectionTime == .atDocumentEnd) ? $0.source : nil }.joined(separator: "\n")

        let source =
            "(function () {\n" +
            "  'use strict';\n" +
            "  var __wksecret__ = '\(secret)';\n" +
            "  \(sharedSource)\n" +
            "  \(startScripts)\n" +
            "  document.addEventListener('DOMContentLoaded', function () {\n" +
            "    \(endScripts)\n" +
            "  }, false);\n" +
            (isolatedContext ? "" : "window.wkutils = wkutils;\n") +
            "}) ();"
        
        let newScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        let controller = webView.configuration.userContentController
        let activeScripts = controller.userScripts
        controller.removeAllUserScripts()

        var added = false
        for script in activeScripts {
            if script === injectedScript {
                injectedScript = newScript
                controller.addUserScript(newScript)
                added = true
                continue
            }

            controller.addUserScript(script)
        }

        if !added {
            injectedScript = newScript
            controller.addUserScript(newScript)
        }
    }

    open func addUserScript(_ script: WKMagicBridgeScript) {
        userScripts.append(script)
        rebuildScripts()
    }

    open func removeUserScript(_ script: WKMagicBridgeScript) {
        guard let index = userScripts.index(where: { $0 === script }) else { return }
        userScripts.remove(at: index)
        rebuildScripts()
    }

    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: AnyObject] else {
            print("Invalid message! \(message)")
            return
        }

        guard let key = body["secret"] as? String, key == secret else {
            print("Secret denied! \(message)")
            return
        }

        let data = body["data"]

        if let responseID = body["responseID"] as? Int {
            guard let sendResponse = responseMap[responseID] else {
                print("No response handler for response ID: \(responseID)")
                return
            }

            sendResponse(data)
            responseMap.removeValue(forKey: responseID)
            return
        }

        guard let name = body["name"] as? String else {
            print("Invalid message! \(message)")
            return
        }

        if name == "__wkprint__" {
            if let message = data as? String {
                print(message)
            }
            return
        }

        if name == "__wkreset__" {
            print("Clearing callbacks")
            responseMap.removeAll()
            return
        }

        guard let ID = body["id"] as? Int else {
            assertionFailure("Invalid message! \(message)")
            return
        }

        if name == "__wkxhr__" {
            guard let data = body["data"],
                  let URLString = data["url"] as? String,
                  let URL = URL(string: URLString) else {
                print("Invalid message (XHR)")
                return
            }

            URLSession.shared.dataTask(with: URL, completionHandler: { data, response, error in
                let response = response as! HTTPURLResponse

                var responseData = [String: AnyObject]()
                responseData["status"] = response.statusCode as AnyObject?
                responseData["mimeType"] = response.mimeType as AnyObject?

                let encoding: String.Encoding
                if let encodingName = response.textEncodingName {
                    let CFEncoding = CFStringConvertIANACharSetNameToEncoding(encodingName as CFString!)
                    encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFEncoding))
                } else {
                    encoding = String.Encoding.isoLatin1
                }

                if let data = data,
                   let responseString = String(data: data, encoding: encoding) {
                    responseData["text"] = responseString as AnyObject?
                }

                self.postResponse(ID, data: responseData as AnyObject?)
            }) .resume()

            return
        }

        guard let handler = handlerMap[name] else {
            print("No handler exists for name: \(name)")
            return
        }

        // TODO: Not message
        handler(message) { response in
            self.postResponse(ID, data: response)
        }
    }

    open func addHandler(withName name: String, handler: @escaping WKMagicHandler) {
        handlerMap[name] = handler
    }

    open func removeHandler(withName name: String) {
        handlerMap.removeValue(forKey: name)
    }

    open func postMessage(handlerName name: String, data: AnyObject?, response: @escaping WKMagicResponse) {
        responseMap[responseID] = response

        var message = [String: AnyObject]()
        message["secret"] = secret as AnyObject?
        message["id"] = responseID as AnyObject?
        message["name"] = name as AnyObject?
        message["data"] = data ?? NSNull()

        guard let JSON = toJSON(message) else { return }

        webView.evaluateJavaScript("__wkutils__.receiveMessage(\(JSON))", completionHandler: nil)

        responseID += 1
    }

    func postResponse(_ ID: Int, data: AnyObject?) {
        var message = [String: AnyObject]()
        message["secret"] = secret as AnyObject?
        message["responseID"] = ID as AnyObject?
        message["data"] = data ?? NSNull()

        guard let JSON = toJSON(message) else { return }

        webView.evaluateJavaScript("__wkutils__.receiveMessage(\(JSON))", completionHandler: nil)
    }

    func toJSON(_ object: [String: AnyObject]) -> String? {
        guard JSONSerialization.isValidJSONObject(object) else {
            print("Error: Data could not be serialized.")
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: [])
            guard let JSON = String(data: data, encoding: .utf8) else {
                throw JSONSerializationError() as Error
            }
            return JSON
        } catch {
            print("Error: Data could not be serialized.")
        }

        return nil
    }
}
