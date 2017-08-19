//
//  SelfSizing_KeyboardVC.swift
//  TextView
//

import UIKit

class SelfSizing_KeyboardVC: UIViewController, UITextViewDelegate {

    @IBOutlet var tvSelfSize: UITextView!
    @IBOutlet var heightConstraint: NSLayoutConstraint! //FIXME: 最在高度有限制,自动适配keyboard
    @IBOutlet var tv1: UITextView! //FIXME: AdjustsScrollViewInsets 没起作用

    @IBOutlet weak var tvAutoHeight: UITextView!

    @IBOutlet weak var tvNormal: UITextView!
    @IBOutlet var heightConstraintNormal: NSLayoutConstraint!
    
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 若是navBar由rootVC带入时就不会AdjustsScrollViewInsets
        automaticallyAdjustsScrollViewInsets = false

        self.tvSelfSize.isScrollEnabled = false // *
        self.heightConstraint.isActive = false // *

        tvNormal.isScrollEnabled = false // *
        heightConstraintNormal.isActive = false // *

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

        tvSelfSize.attributedText = mas
        tvAutoHeight.attributedText = mas

        setTV1()
    }

    override func viewDidLayoutSubviews() {
        let h = self.tvSelfSize.contentSize.height
        let limit : CGFloat = 200
        if h > limit && !self.tvSelfSize.isScrollEnabled {
            self.tvSelfSize.isScrollEnabled = true
            self.heightConstraint.constant = limit
            self.heightConstraint.isActive = true
        } else if h < limit && self.tvSelfSize.isScrollEnabled {
            self.tvSelfSize.isScrollEnabled = false
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

    /// 基于用户在TextView输入位置调整内容偏移量, >iOS 8 将显示滚动光标
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

    // TODO: This action "doDone:" is not difined on 'ViewController' 可以不用IBAction直接引入Storyboard
    @IBAction func doDone(_ sender: Any) {
        self.view.endEditing(false)
    }
}
