//
//  UILabelVC.swift
//  UILabel
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

func imageOfSize(_ size: CGSize, closure: () -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

class UILabelVC: UIViewController {
    
    @IBOutlet var lab1: UILabel!
    @IBOutlet var lab2: UILabel!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet var lab3: UILabel!
    @IBOutlet var labelVarName: UILabel!
    let s2 = "Fourscore and seven years ago, our fathers brought forth " +
        "upon this continent a new nation, conceived in liberty and dedicated " +
    "to the proposition that all men are created equal."
    @IBOutlet var theLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFontShrinkTest()
        lineBreakTest()
        selfSizingLabel()
        moreStringDrawingTest()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(5) {
            self.doYourThing()
        }
    }

    func labelFontShrinkTest() {
        // idea is to provide a test bed for playing with these parameters
        // you can see how both string-based and attributed-string-based label behaves also now added drawing attributed string in image to show wrapping differences

        let f = UIFont(name: "GillSans", size: 20)!

        let align: NSTextAlignment = .left
        let brk: NSLineBreakMode = .byTruncatingMiddle
        let numLines = 2
        let tighten = true

        let adjusts = false
        let min: CGFloat = 0.8
        let base: UIBaselineAdjustment = .none

        self.lab1.adjustsFontSizeToFitWidth = adjusts
        self.lab2.adjustsFontSizeToFitWidth = adjusts
        self.lab1.minimumScaleFactor = min
        self.lab2.minimumScaleFactor = min
        self.lab1.baselineAdjustment = base
        self.lab2.baselineAdjustment = base
        self.lab1.numberOfLines = numLines
        self.lab2.numberOfLines = numLines
        self.lab1.allowsDefaultTighteningForTruncation = tighten
        self.lab2.allowsDefaultTighteningForTruncation = tighten

        let s = "Little poltergeists make up the principal form of material manifestation."
        self.lab1.text = s
        self.lab1.font = f
        self.lab1.textAlignment = align
        self.lab1.lineBreakMode = brk

        let mas = NSMutableAttributedString(string: s, attributes: [
            NSFontAttributeName: f,
            NSParagraphStyleAttributeName: lend {
                (para: NSMutableParagraphStyle) in
                para.alignment = align
                para.lineBreakMode = brk
                para.allowsDefaultTighteningForTruncation = tighten
            }
            ])
        mas.addAttribute(NSForegroundColorAttributeName,
                         value: UIColor.blue,
                         range: (s as NSString).range(of: "poltergeists"))
        self.lab2.attributedText = mas

        let r = self.iv.bounds
        self.iv.image = imageOfSize(r.size) {
            mas.draw(in: r)
        }
    }
    
    func lineBreakTest() {
        print(lab3.lineBreakMode.rawValue)
        let color = UIColor.blue
        let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
            NSForegroundColorAttributeName: color
            ])
        lab3.attributedText = s
        lab3.sizeToFit()
        lab3.tag = 1
        lab3.highlightedTextColor = UIColor.red
    }


    func showBug() {
        let showTheBug = true // set to true and run on iPhone 5s to see the bug
        switch showTheBug {
        case true:
            let att = self.theLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            att.addAttribute(NSParagraphStyleAttributeName,
                             value: lend {
                                (para : NSMutableParagraphStyle) in
                                para.headIndent = 20;
                                para.firstLineHeadIndent = 20
                                para.tailIndent = -20
                } ,
                             range:NSMakeRange(0,1))
            self.theLabel.attributedText = att

        default:break
        }
        
        self.theLabel.sizeToFit()
    }

    func doYourThing() {
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8, broken again in iOS 8.3
            ], range:NSMakeRange(0,1))

        content2.addAttribute(NSParagraphStyleAttributeName,
                              value: lend {
                                (para : NSMutableParagraphStyle) in
                                para.headIndent = 10
                                para.firstLineHeadIndent = 10
                                para.tailIndent = -10
                                para.lineBreakMode = .byWordWrapping
                                para.alignment = .justified
                                para.lineHeightMultiple = 1.2
                                para.hyphenationFactor = 1.0
            },
                              range:NSMakeRange(0,1))
        self.lab1.attributedText = content2
        self.lab2.attributedText = content2
    }

    //TODO: 加入有效的constraints
    func selfSizingLabel() {
        let content2 = NSMutableAttributedString(string: s2, attributes: [
            NSFontAttributeName: UIFont(name: "HoeflerText-Black", size: 16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name: "HoeflerText-Black", size: 24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8, broken again in iOS 8.3
            ], range: NSMakeRange(0, 1))
        
        content2.addAttribute(NSParagraphStyleAttributeName,
                              value: lend {
                                (para: NSMutableParagraphStyle) in
                                para.headIndent = 10
                                para.firstLineHeadIndent = 10
                                para.tailIndent = -10
                                para.lineBreakMode = .byWordWrapping
                                para.alignment = .justified
                                para.lineHeightMultiple = 1.2
                                para.hyphenationFactor = 1.0
            },
                              range: NSMakeRange(0, 1))
        
        let lab = UILabel() // preferredMaxLayoutWidth is 0
        print(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellow
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lab)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(30)-[v]-(30)-|",
                options: [], metrics: nil, views: ["v": lab]),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(260)-[v]",
                options: [], metrics: nil, views: ["v": lab])
            ].joined().map { $0 })
        lab.attributedText = content2
    }

    func makeSubscriptSuperscript() {
        let font = UIFont(name: "Helvetica", size:20)
        let fontSuper = UIFont(name: "Helvetica", size:10)
        let attString = NSMutableAttributedString(string: "6.022*1023", attributes: [NSFontAttributeName:font!])
        attString.setAttributes([
            NSFontAttributeName: fontSuper!,
            NSBaselineOffsetAttributeName: 10],
                                range: NSRange(location:8, length:2))
        labelVarName.attributedText = attString
    }

    //TODO: 加入有效的constraints
    func labelFontSizeScaling() {
        let content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSKernAttributeName: -4
            ], range:NSMakeRange(0,1))

        let lab = UILabel() // preferredMaxLayoutWidth is 0
        print(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellow
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lab)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(30)-[v]-(30)-|",
                options: [], metrics: nil, views: ["v": lab]),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-(260)-[v]",
                options: [], metrics: nil, views: ["v": lab])
            ].joined().map { $0 })
        lab.adjustsFontSizeToFitWidth = true
        lab.minimumScaleFactor = 0.7
        lab.attributedText = content2
    }

    func moreStringDrawingTest() {
        let con = NSStringDrawingContext()

        // testing string measurement

        let s = self.makeAttributedString()
        let r = s.boundingRect(with:CGSize(400,10000), options: .usesLineFragmentOrigin, context: con)
        print("boundingRect:", r, "==", con.totalBounds) // about 150 tall, sounds right to me :)

        // testing minimumScaleFactor; we never get an actual scale factor other than 1

        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    p.allowsDefaultTighteningForTruncation = false
                    p.lineBreakMode = .byTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRect(with:CGSize(CGFloat(w),10000), options: [.usesLineFragmentOrigin], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }

        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    // this new feature does make a difference, but not in the scale factor
                    p.allowsDefaultTighteningForTruncation = true
                    p.lineBreakMode = .byTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRect(with:CGSize(CGFloat(w),10000), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }
    }

    fileprivate func makeAttributedString() -> NSAttributedString {
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!

        let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
        "(namely Thursday, November 19, 1863) by A. Lincoln"
        content = NSMutableAttributedString(string:s1, attributes:[
            NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
            NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
        )
        let r = (s1 as NSString).range(of:"Gettysburg Address")
        let atts : [String:Any] = [
            NSStrokeColorAttributeName: UIColor.red,
            NSStrokeWidthAttributeName: -2.0
        ]
        content.addAttributes(atts, range: r)

        content.addAttribute(NSParagraphStyleAttributeName,
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
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))

        content2.addAttribute(NSParagraphStyleAttributeName,
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition:nil) {
            _ in
            print(self.lab1.preferredMaxLayoutWidth)
            print(self.lab2.preferredMaxLayoutWidth)
        }

    }
    
}

