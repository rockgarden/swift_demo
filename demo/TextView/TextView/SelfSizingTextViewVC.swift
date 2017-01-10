//
//  SelfSizing_KeyboardVC.swift
//  TextView
//

import UIKit

class SelfSizing_KeyboardVC: UIViewController, UITextViewDelegate {

    @IBOutlet var tv: UITextView!
    @IBOutlet var heightConstraint: NSLayoutConstraint! //FIXME: 最在高度有限制,自动适配keyboard
    @IBOutlet var tv1: UITextView! //FIXME: AdjustsScrollViewInsets 没起作用
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 若是navBar由rootVC带入时就不会AdjustsScrollViewInsets
        automaticallyAdjustsScrollViewInsets = false

        self.tv.isScrollEnabled = false // *
        self.heightConstraint.isActive = false // *

        let s = "Twas brillig, and the slithy toves did gyre and gimble in the wabe; " +
        "all mimsy were the borogoves, and the mome raths outgrabe."

        let mas = NSMutableAttributedString(string:s, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:20)!
            ])

        mas.addAttribute(NSParagraphStyleAttributeName,
                         value:lend(){
                            (para:NSMutableParagraphStyle) in
                            para.alignment = .left
                            para.lineBreakMode = .byWordWrapping
        }, range:NSMakeRange(0,1))

        self.tv.attributedText = mas

        setTV1()
    }

    override func viewDidLayoutSubviews() {
        let h = self.tv.contentSize.height
        let limit : CGFloat = 200 // or whatever
        if h > limit && !self.tv.isScrollEnabled {
            self.tv.isScrollEnabled = true
            self.heightConstraint.constant = limit
            self.heightConstraint.isActive = true
        } else if h < limit && self.tv.isScrollEnabled {
            self.tv.isScrollEnabled = false
            self.heightConstraint.isActive = false
        }
    }

    func setTV1() {
        let mas = NSMutableAttributedString(string:sBrillig, attributes:[
            NSFontAttributeName: UIFont(name:"GillSans", size:14)!
            ])
        mas.addAttribute(NSParagraphStyleAttributeName,
                         value:lend(){
                            (para:NSMutableParagraphStyle) in
                            para.alignment = .left
                            para.lineBreakMode = .byWordWrapping
            },
                         range:NSMakeRange(0,1))
        tv1.attributedText = mas

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
        tv1.keyboardDismissMode = .interactive
    }

    override var shouldAutorotate : Bool {
        return !keyboardShowing
    }

    // as long as you play your part (adjust content offset),
    // iOS 8 will play its part (scroll cursor to visible)
    // and we don't have to animate
    func keyboardShow(_ n:Notification) {
        if keyboardShowing {
            return
        }
        self.keyboardShowing = true

        print("show")

        let d = n.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        r = tv1.convert(r, from:nil)
        tv1.contentInset.bottom = r.size.height
        tv1.scrollIndicatorInsets.bottom = r.size.height
    }

    func keyboardHide(_ n:Notification) {
        if !keyboardShowing {
            return
        }
        keyboardShowing = false

        print("hide")

        tv1.contentInset = .zero
        tv1.scrollIndicatorInsets = .zero
    }

    //TODO: This action "doDone:" is not difined on 'ViewController' 可以不用IBAction直接引入Storyboard
    @IBAction func doDone(_ sender: Any) {
        self.view.endEditing(false)
    }
    

}
