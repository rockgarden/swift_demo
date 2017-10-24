//
//  UILabelVC.swift
//  UILabel
//
//  Created by wangkan on 2016/9/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit


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
    @IBOutlet var stackView : UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelFontShrinkTest()
        lineBreakTest()
        selfSizingLabel()
        labelFontSizeScaling()
        showSelfSizingLabelBug()
        makeSubscriptSuperscript()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(5) {
            self.showSelfSizeingLabel()
        }
    }

    /// you can see how both string-based and attributed-string-based label behaves also now added drawing attributed string in image to show wrapping differences
    func labelFontShrinkTest() {

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
            NSAttributedStringKey.font: f,
            NSAttributedStringKey.paragraphStyle: lend {
                (para: NSMutableParagraphStyle) in
                para.alignment = align
                para.lineBreakMode = brk
                para.allowsDefaultTighteningForTruncation = tighten
            }
            ])
        mas.addAttribute(NSAttributedStringKey.foregroundColor,
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
            NSAttributedStringKey.foregroundColor: color
            ])
        lab3.attributedText = s
        lab3.sizeToFit()
        lab3.tag = 1
        lab3.highlightedTextColor = UIColor.red
    }


    /// selfSizingLabel by sizeToFit
    func showSelfSizingLabelBug() {
        let showTheBug = true //set to true and run on iPhone 5s to see the bug?
        switch showTheBug {
        case true:
            let att = self.theLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            att.addAttribute(NSAttributedStringKey.paragraphStyle,
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

    /// selfSizingLabel 在 numberOfLines 且不限制高度时才起作用（前提使用AutoLayout）
    /// 正常 normal: width constrained absolutely 宽度限制绝对, height adjusts automatically 高度自动调整.
    func showSelfSizeingLabel() {
        /// numberOfLines 为0才可selfSizingLabel
        lab1.numberOfLines = 0
        lab2.numberOfLines = 0

        let s = makeAttributedText()
        lab1.attributedText = s
        lab2.attributedText = s
    }

    func selfSizingLabel() {
        let lab = UILabel() // preferredMaxLayoutWidth is 0
        debugLog(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellow
        lab.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lab)
        lab.attributedText = makeAttributedText()
    }

    private func makeAttributedText() -> NSAttributedString {
        let s = NSMutableAttributedString(string: s2, attributes: [
            NSAttributedStringKey.font: UIFont(name: "HoeflerText-Black", size: 16)!
            ])
        s.addAttributes([
            NSAttributedStringKey.font: UIFont(name: "HoeflerText-Black", size: 24)!,
            NSAttributedStringKey.expansion: 0.3,
            NSAttributedStringKey.kern: -4
            ], range: NSMakeRange(0, 1))
        s.addAttribute(NSAttributedStringKey.paragraphStyle,
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
        return s
    }

    func makeSubscriptSuperscript() {
        let font = UIFont(name: "Helvetica", size:20)
        let fontSuper = UIFont(name: "Helvetica", size:10)
        let attString = NSMutableAttributedString(string: "6.022*1023", attributes: [NSAttributedStringKey.font:font!])
        attString.setAttributes([
            NSAttributedStringKey.font: fontSuper!,
            NSAttributedStringKey.baselineOffset: 10],
                                range: NSRange(location:8, length:2))
        labelVarName.attributedText = attString
    }

    func labelFontSizeScaling() {
        let s = NSMutableAttributedString(string:s2, attributes: [
            NSAttributedStringKey.font: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        s.addAttributes([
            NSAttributedStringKey.font: UIFont(name:"HoeflerText-Black", size:24)!,
            NSAttributedStringKey.kern: -4
            ], range:NSMakeRange(0,1))

        let lab = UILabel()
        debugLog(lab.preferredMaxLayoutWidth)
        lab.numberOfLines = 0
        lab.backgroundColor = UIColor.yellow
        lab.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(lab)

        lab.adjustsFontSizeToFitWidth = true
        lab.minimumScaleFactor = 0.7
        lab.attributedText = s
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition:nil) {
            _ in
            print(self.lab1.preferredMaxLayoutWidth)
            print(self.lab2.preferredMaxLayoutWidth)
        }
    }
}

