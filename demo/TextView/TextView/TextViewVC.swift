//
//  TextViewVC.swift
//  TextView
//
//  Created by wangkan on 16/9/13.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import ImageIO

/// tabStops 示例 NSTextTab 的用法
class TextViewVC: UIViewController {
    
    @IBOutlet var tv: UITextView!
    @IBOutlet var tv1 : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        textLayoutGeometry()
        TextTabDemo()
    }

    func TextTabDemo() {
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tv1.contentOffset = .zero
    }

    func initMenu() {
        let mail = UIMenuItem(title: "邮件", action: #selector(onMail))
        let weixin = UIMenuItem(title: "微信", action: #selector(onWeiXin))
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

extension TextViewVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print(URL)
        print((textView.text as NSString).substring(with: characterRange))
        return true
    }

}

extension TextViewVC {

    func textLayoutGeometry() {
        let mas = NSMutableAttributedString(string:sBrillig + " " + sBrillig, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])

        mas.addAttribute(NSParagraphStyleAttributeName,
                         value:lend(){
                            (para:NSMutableParagraphStyle) in
                            para.alignment = .left
                            para.lineBreakMode = .byWordWrapping
            },
                         range:NSMakeRange(0,1))

        let r = self.tv1.frame
        let lm = MyLayoutManager()
        let ts = NSTextStorage()
        ts.addLayoutManager(lm)
        let tc = NSTextContainer(size:r.size)
        lm.addTextContainer(tc)
        let tv = UITextView(frame:r, textContainer:tc)

        self.tv1.removeFromSuperview()
        self.view.addSubview(tv)
        self.tv1 = tv

        self.tv1.attributedText = mas
        self.tv1.isScrollEnabled = true
        self.tv1.backgroundColor = .yellow
        self.tv1.textContainerInset = UIEdgeInsetsMake(20,20,20,20)
        self.tv1.isSelectable = false
        self.tv1.isEditable = false

        self.tv1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat:"H:|-(10)-[tv]-(10)-|",
                                           metrics:nil, views:["tv":self.tv1]),
            NSLayoutConstraint.constraints(withVisualFormat:"V:[top][tv]-(10)-[bot]",
                                           metrics:nil, views:[
                                            "tv":self.tv1, "top":self.tv, "bot":self.bottomLayoutGuide
                ])
            ].flatMap{$0})
    }

    @IBAction func doTest(_ sender: Any) {
        // how far am I scrolled?
        let off = self.tv1.contentOffset
        // how far down is the top of the text container?
        let top = self.tv1.textContainerInset.top
        // so here's the top-left point within the text container
        var tctopleft = CGPoint(0, off.y - top)
        // so what's the character index for that?
        // this doesn't give quite the right answer
        let ixx = self.tv1.layoutManager.characterIndex(for:tctopleft, in:self.tv1.textContainer, fractionOfDistanceBetweenInsertionPoints:nil)
        _ = ixx
        // this is better
        var ix = self.tv1.layoutManager.glyphIndex(for:tctopleft, in:self.tv1.textContainer, fractionOfDistanceThroughGlyph:nil)
        let frag = self.tv1.layoutManager.lineFragmentRect(forGlyphAt:ix, effectiveRange:nil)
        if tctopleft.y > frag.origin.y + 0.5*frag.size.height {
            tctopleft.y += frag.size.height
            ix = self.tv1.layoutManager.glyphIndex(for:tctopleft, in:self.tv1.textContainer, fractionOfDistanceThroughGlyph:nil)
        }
        let charRange = self.tv1.layoutManager.characterRange(forGlyphRange: NSMakeRange(ix,0), actualGlyphRange:nil)
        ix = charRange.location

        // what word is that?
        let sch = NSLinguisticTagSchemeTokenType
        let t = NSLinguisticTagger(tagSchemes:[sch], options:0)
        t.string = self.tv1.text
        var r : NSRange = NSMakeRange(0,0)
        let tag = t.tag(at:ix, scheme:sch, tokenRange:&r, sentenceRange:nil)
        if tag == NSLinguisticTagWord {
            print((self.tv1.text as NSString).substring(with:r))
        }

        let lm = self.tv1.layoutManager as! MyLayoutManager
        lm.wordRange = r
        lm.invalidateDisplay(forCharacterRange:r)

    }

}
