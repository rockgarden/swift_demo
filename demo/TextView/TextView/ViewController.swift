//
//  ViewController.swift
//  TextView
//
//  Created by wangkan on 16/9/13.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import ImageIO

func lend<T> (_ closure: (T) -> ()) -> T where T: NSObject {
    let orig = T()
    closure(orig)
    return orig
}

/// tabStops 示例 NSTextTab 的用法
class ViewController: UIViewController {
    
    @IBOutlet var tv: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = "Onions\t$2.34\nPeppers\t$15.2\n"
        let mas = NSMutableAttributedString(string: s, attributes: [
            NSFontAttributeName: UIFont(name: "GillSans", size: 15)!,
            NSParagraphStyleAttributeName: lend {
                (p: NSMutableParagraphStyle) in
                let terms = NSTextTab.columnTerminators(for: Locale.current)
                let tab = NSTextTab(textAlignment: .right, location: 170, options: [NSTabColumnTerminatorsAttributeName: terms])
                var which: Int { return 2 }
                switch which {
                case 1:
                    p.tabStops = [tab]
                case 2:
                    for oldTab in p.tabStops {
                        p.removeTabStop(oldTab)
                    }
                    p.addTabStop(tab)
                default: break
                }
                
                p.firstLineHeadIndent = 20
            }
            ])
        self.tv.attributedText = mas
        
        // return;
        
        let onions = self.thumbnailOfImageWithName("onion", withExtension: "jpg")
        let peppers = self.thumbnailOfImageWithName("peppers", withExtension: "jpg")
        
        let onionatt = NSTextAttachment()
        onionatt.image = onions
        onionatt.bounds = CGRect(x: 0, y: -5, width: onions.size.width, height: onions.size.height)
        let onionattchar = NSAttributedString(attachment: onionatt)
        
        let pepperatt = NSTextAttachment()
        pepperatt.image = peppers
        pepperatt.bounds = CGRect(x: 0, y: -1, width: peppers.size.width, height: peppers.size.height)
        let pepperattchar = NSAttributedString(attachment: pepperatt)
        
        let r = (mas.string as NSString).range(of: "Onions")
        mas.insert(onionattchar, at: (r.location + r.length))
        let r2 = (mas.string as NSString).range(of: "Peppers")
        mas.insert(pepperattchar, at: (r2.location + r2.length))
        
        mas.append(NSAttributedString(string: "\n\n", attributes: nil))
        mas.append(NSAttributedString(string: "LINK", attributes: [
            NSLinkAttributeName: URL(string: "http://www.apple.com")!
            ]))
        mas.append(NSAttributedString(string: "\n\n", attributes: nil))
        mas.append(NSAttributedString(string: "(805)-123-4567", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes: nil))
        mas.append(NSAttributedString(string: "123 Main Street, Anytown, CA 91234", attributes: nil))
        mas.append(NSAttributedString(string: "\n\n", attributes: nil))
        mas.append(NSAttributedString(string: "tomorrow at 4 PM", attributes: nil))
        
        self.tv.attributedText = mas
        
        // print(NSAttachmentCharacter)
        // print(0xFFFC)
        
        self.tv.isSelectable = true
        self.tv.isEditable = false
        self.tv.delegate = self
        
    }
    
    func initMenu() {
        let mail = UIMenuItem(title: "邮件", action: #selector(ViewController.onMail))
        let weixin = UIMenuItem(title: "微信", action: #selector(ViewController.onWeiXin))
        let menu = UIMenuController()
        menu.menuItems = [mail,weixin]
    }
    
    func onMail(){
        print("mail")
    }
    
    func onWeiXin(){
        print("weixin")
    }
    
    //TODO: public func classNamed(className: String) -> AnyClass?
    
    func thumbnailOfImageWithName(_ name: String, withExtension ext: String) -> UIImage {
        let url = Bundle.main.url(forResource: name,
                                                       withExtension: ext)!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let scale = UIScreen.main.scale
        let w: CGFloat = 20 * scale
        let d: [AnyHashable: Any] = [
            kCGImageSourceShouldAllowFloat as AnyHashable: true,
            kCGImageSourceCreateThumbnailWithTransform as AnyHashable: true,
            kCGImageSourceCreateThumbnailFromImageAlways as AnyHashable: true,
            kCGImageSourceThumbnailMaxPixelSize as AnyHashable: Int(w)
        ]
        let imref =
            CGImageSourceCreateThumbnailAtIndex(src, 0, d as CFDictionary?)!
        let im = UIImage(cgImage: imref, scale: scale, orientation: .up)
        return im
    }
    
}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL)
        print((textView.text as NSString).substring(with: characterRange))
        return true
    }

}
