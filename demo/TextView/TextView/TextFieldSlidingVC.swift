//
//  TextFieldSlidingVC.swift
//  TextView
//

import UIKit

class TextFieldSlidingVC: UIViewController {

    @IBOutlet var scrollView : UIScrollView!
    // var fr : UIView?
    var oldContentInset = UIEdgeInsets.zero
    var oldIndicatorInset = UIEdgeInsets.zero
    var oldOffset = CGPoint.zero
    var keyboardShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)

        /// content view's width and height constraints in storyboard are placeholders
        /// contentView.topAnchor 必须是 superview scrollView 才能 Sliding
        let contentView = self.scrollView.subviews[0]
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo:self.scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo:self.scrollView.heightAnchor),
            ])

        self.scrollView.keyboardDismissMode = .interactive
    }

    //    func textFieldDidBeginEditing(tf: UITextField) {
    //        self.fr = tf // keep track of first responder
    //    }

    func textFieldShouldReturn(_ tf: UITextField) -> Bool {
        print("return")
        // self.fr = nil
        tf.resignFirstResponder()
        return true
    }

    override var shouldAutorotate : Bool {
        return !self.keyboardShowing
    }

    func keyboardShow(_ n:Notification) {
        if self.keyboardShowing {
            return
        }
        self.keyboardShowing = true

        print("show")

        self.oldContentInset = self.scrollView.contentInset
        self.oldIndicatorInset = self.scrollView.scrollIndicatorInsets
        self.oldOffset = self.scrollView.contentOffset

        let d = n.userInfo!

        /// 包含CGRect的NSValue对象的键，用于在屏幕坐标中标识键盘的结束帧。 这些坐标不考虑由于界面定向改变而应用于窗口内容的任何旋转因子。 因此，在使用它之前，您可能需要将矩形转换为窗口坐标（使用convert（_：from :)方法）或查看坐标（使用convert（_：from :)方法）。
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let margin: CGFloat = 10

        /// 将矩形从另一个视图的坐标系转换为接收器scrollView?的坐标系
        r = self.scrollView.convert(r, from:nil)
        
        /// no need to scroll, as the scroll view will do it for us, so all we have to do is adjust the inset
        self.scrollView.contentInset.bottom = r.size.height + margin
        self.scrollView.scrollIndicatorInsets.bottom = r.size.height + margin
    }

    func keyboardHide(_ n:Notification) {
        if !self.keyboardShowing {
            return
        }
        self.keyboardShowing = false
        //        do { // work around bug
        //            let d = n.userInfo!
        //            let beginning = d[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        //            let ending = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        //            if beginning == ending {print("bail!"); return}
        //        }
        self.scrollView.contentOffset = self.oldOffset
        self.scrollView.scrollIndicatorInsets = self.oldIndicatorInset
        self.scrollView.contentInset = self.oldContentInset
        //        self.fr?.resignFirstResponder()
        //        self.fr = nil
    }
    
}

