//
//  ViewController.swift
//  UILabel
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

func lend<T where T: NSObject> (closure: (T) -> ()) -> T {
    let orig = T()
    closure(orig)
    return orig
}

func imageOfSize(size: CGSize, closure: () -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

class ViewController: UIViewController {
    
    @IBOutlet var lab1: UILabel!
    @IBOutlet var lab2: UILabel!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet var lab3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLab3()
        setupLab4()
        // idea is to provide a test bed for playing with these parameters
        // you can see how both string-based and attributed-string-based label behaves
        
        // also now added drawing attributed string in image to show wrapping differences
        
        let f = UIFont(name: "GillSans", size: 20)!
        
        let align: NSTextAlignment = .Left
        let brk: NSLineBreakMode = .ByTruncatingMiddle
        let numLines = 2
        let tighten = true
        
        let adjusts = false
        let min: CGFloat = 0.8
        let base: UIBaselineAdjustment = .None
        
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
                         value: UIColor.blueColor(),
                         range: (s as NSString).rangeOfString("poltergeists"))
        self.lab2.attributedText = mas
        
        let r = self.iv.bounds
        self.iv.image = imageOfSize(r.size) {
            mas.drawInRect(r)
        }
    }
    
    func setupLab3() {
        print(lab3.lineBreakMode.rawValue)
        let color = UIColor.blueColor()
        let s = NSMutableAttributedString(string: "This is\n a test", attributes: [
            NSForegroundColorAttributeName: color
            ])
        lab3.attributedText = s
        lab3.sizeToFit()
        lab3.tag = 1
        lab3.highlightedTextColor = UIColor.redColor()
    }
    
    func setupLab4() {
        let s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated " +
        "to the proposition that all men are created equal."
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
                                para.lineBreakMode = .ByWordWrapping
                                para.alignment = .Justified
                                para.lineHeightMultiple = 1.2
                                para.hyphenationFactor = 1.0
            },
                              range: NSMakeRange(0, 1))
        
        let lab = UILabel() // preferredMaxLayoutWidth is 0
        print(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellowColor()
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lab)
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-(30)-[v]-(30)-|",
                options: [], metrics: nil, views: ["v": lab]),
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(260)-[v]",
                options: [], metrics: nil, views: ["v": lab])
            ].flatten().map { $0 })
        lab.attributedText = content2
    }
    
}

