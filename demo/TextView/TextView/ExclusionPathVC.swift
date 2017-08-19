//
//  ExclusionPathVC.swift
//  TextView
//

import UIKit

class ExclusionPathVC: UIViewController {

    @IBOutlet var tv: UITextView!
    @IBOutlet var heightConstraintTv: NSLayoutConstraint!
    @IBOutlet var tv1: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        let mas = NSMutableAttributedString(string:sBrillig, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:14)!
            ])
        mas.addAttribute(NSParagraphStyleAttributeName,
                         value:lend(){
                            (para: NSMutableParagraphStyle) in
                            para.alignment = .left
                            para.lineBreakMode = .byWordWrapping
                            para.hyphenationFactor = 1
            }, range:NSMakeRange(0,1))

        tv.attributedText = mas
        tv.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 0)
        tv.isScrollEnabled = true

        debugPrint(tv.frame)

        do {
            let r = CGRect(0,0,500,500)
            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:CGSize(r.width, .greatestFiniteMagnitude))
            lm.addTextContainer(tc)
            let tv = UITextView(frame:r, textContainer:tc)
            _ = tv
        }

        do {
            let r = tv1.frame
            let lm = NSLayoutManager()
            let ts = NSTextStorage()
            ts.addLayoutManager(lm)
            let tc = MyTextContainer(size:CGSize(r.width, r.height))
            lm.addTextContainer(tc)
            let tv = UITextView(frame:r, textContainer:tc)

            tv1.removeFromSuperview()
            self.view.addSubview(tv)
            tv1 = tv

            tv1.attributedText = mas
            tv1.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2)
            tv1.isScrollEnabled = false
            tv1.backgroundColor = .yellow
        }
    }

    override func viewDidLayoutSubviews() {
        let sz = tv.textContainer.size

        let p = UIBezierPath()
        p.move(to: CGPoint(sz.width/4.0,0))
        p.addLine(to: CGPoint(sz.width,0))
        p.addLine(to: CGPoint(sz.width,sz.height))
        p.addLine(to: CGPoint(sz.width/4.0,sz.height))
        p.addLine(to: CGPoint(sz.width,sz.height/2.0))
        p.close()

        tv.textContainer.exclusionPaths = [p]
        debugPrint(tv.textContainer)
    }
}

