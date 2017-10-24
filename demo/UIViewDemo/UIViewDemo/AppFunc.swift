//
//  AppFunc.swift
//  UIViewDemo
//
//  Created by wangkan on 2017/8/19.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

func makeAttributedString() -> NSAttributedString {
    var content : NSMutableAttributedString!
    var content2 : NSMutableAttributedString!

    let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
    "(namely Thursday, November 19, 1863) by A. Lincoln"
    content = NSMutableAttributedString(string:s1, attributes:[
        NSAttributedStringKey.font: UIFont(name:"Arial-BoldMT", size:15)!,
        NSAttributedStringKey.foregroundColor: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
    )
    let r = (s1 as NSString).range(of:"Gettysburg Address")
    let atts : [NSAttributedStringKey:Any] = [
        NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue): UIColor.red,
        NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeWidth.rawValue): -2.0
    ]
    content.addAttributes(atts, range: r)

    content.addAttribute(NSAttributedStringKey.paragraphStyle,
                         value:lend() {
                            (para : NSMutableParagraphStyle) in
                            para.headIndent = 10
                            para.firstLineHeadIndent = 10
                            para.tailIndent = -10
                            para.lineBreakMode = .byWordWrapping
                            para.alignment = .center
                            para.paragraphSpacing = 15
    }, range:NSMakeRange(0,1))

    var s2 = "Fourscore and seven years ago, our fathers brought forth " +
    "upon this continent a new nation, conceived in liberty and dedicated "
    s2 = s2 + "to the proposition that all men are created equal."
    content2 = NSMutableAttributedString(string:s2, attributes: [
        NSAttributedStringKey.font: UIFont(name:"HoeflerText-Black", size:16)!
        ])
    content2.addAttributes([
        NSAttributedStringKey.font: UIFont(name:"HoeflerText-Black", size:24)!,
        NSAttributedStringKey.expansion: 0.3,
        NSAttributedStringKey.kern: -4 // negative kerning bug fixed in iOS 8
        ], range:NSMakeRange(0,1))

    content2.addAttribute(NSAttributedStringKey.paragraphStyle,
                          value:lend() {
                            (para2 : NSMutableParagraphStyle) in
                            para2.headIndent = 10
                            para2.firstLineHeadIndent = 10
                            para2.tailIndent = -10
                            para2.lineBreakMode = .byWordWrapping
                            para2.alignment = .justified
                            para2.lineHeightMultiple = 1.2
                            para2.hyphenationFactor = 1.0
    }, range:NSMakeRange(0,1))

    let end = content.length
    content.replaceCharacters(in:NSMakeRange(end, 0), with:"\n")
    content.append(content2)

    return content
}

