

import UIKit

class ScrollViewVC : UIViewController {

    var which = 0
    var subWhich = 1
    var sv : UIScrollView!

    //／ 在 svByConstraints() 中 示例_ContentInset_A 或 示例_ContentInset_B
    fileprivate let isE_ContentInset_A = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if which == 0 { svByFrame() }
        if which == 1 { svByConstraints() }
        if which == 2 { svByConstraintsSubView() }
    }

    override func viewWillLayoutSubviews() {

        /// 示例_ContentInset_B
        do {
            guard !isE_ContentInset_A else {return}
            if let sv = self.sv {
                let top = topLayoutGuide.length
                let bot = bottomLayoutGuide.length
                sv.contentInset = UIEdgeInsetsMake(top, 0, bot, 0)
                sv.scrollIndicatorInsets = self.sv.contentInset
            }
        }
    }

    fileprivate func svByConstraintsSubView() {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()

        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|[sv]|",
                                           metrics:nil,
                                           views:["sv":sv]))
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|[sv]|",
                                           metrics:nil,
                                           views:["sv":sv]))

        let v = UIView() // content view
        sv.addSubview(v)

        switch subWhich {
        case 1:
            // content view doesn't use explicit constraints
            // subviews don't use explicit constraints either
            var y : CGFloat = 10
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.text = "This is label \(i+1)"
                lab.sizeToFit()
                lab.frame.origin = CGPoint(10,y)
                v.addSubview(lab) // *
                y += lab.bounds.size.height + 10
            }

            // set content view frame and content size explicitly
            v.frame = CGRect(0,0,0,y)
            sv.contentSize = v.frame.size
            NSLayoutConstraint.activate(con)

        case 2:
            // content view uses explicit constraints
            // subviews don't use explicit constraints
            var y : CGFloat = 10
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.text = "This is label \(i+1)"
                lab.sizeToFit()
                lab.frame.origin = CGPoint(10,y)
                v.addSubview(lab) // *
                y += lab.bounds.size.height + 10
            }

            // set content view width, height, and frame-to-superview constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v(y)]|",
                                               metrics:["y":y], views:["v":v]))
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|[v(0)]|",
                                               metrics:nil, views:["v":v]))
            NSLayoutConstraint.activate(con)

        case 3:
            // content view uses explicit constraints
            // subviews use explicit constraints
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.backgroundColor = .red
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.append(contentsOf: // *
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "H:|-(10)-[lab]",
                                                   metrics:nil,
                                                   views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:|-(10)-[lab]",
                                                       metrics:nil,
                                                       views:["lab":lab]))
                } else { // all others, pin to previous
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:[prev]-(10)-[lab]",
                                                       metrics:nil,
                                                       views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }

            // last one, pin to bottom, this dictates content size height!
            con.append(contentsOf: // *
                NSLayoutConstraint.constraints(withVisualFormat: "V:[lab]-(10)-|",
                                               metrics:nil, views:["lab":previousLab!]))

            // pin content view to scroll view, sized by its subview constraints
            // content size is calculated for us
            v.translatesAutoresizingMaskIntoConstraints = false
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"V:|[v]|",
                                               metrics:nil, views:["v":v])) // *
            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|[v]|",
                                               metrics:nil, views:["v":v])) // *
            NSLayoutConstraint.activate(con)

        case 4:
            // content view doesn't use explicit constraints
            // subviews do explicit constraints
            var previousLab : UILabel? = nil
            for i in 0 ..< 30 {
                let lab = UILabel()
                lab.backgroundColor = .yellow
                lab.translatesAutoresizingMaskIntoConstraints = false
                lab.text = "This is label \(i+1)"
                v.addSubview(lab) // *
                con.append(contentsOf: // *
                    NSLayoutConstraint.constraints(withVisualFormat:
                        "H:|-(10)-[lab]",
                                                   metrics:nil,
                                                   views:["lab":lab]))
                if previousLab == nil { // first one, pin to top
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:|-(10)-[lab]",
                                                       metrics:nil,
                                                       views:["lab":lab]))
                } else { // all others, pin to previous
                    con.append(contentsOf: // *
                        NSLayoutConstraint.constraints(withVisualFormat:
                            "V:[prev]-(10)-[lab]",
                                                       metrics:nil,
                                                       views:["lab":lab, "prev":previousLab!]))
                }
                previousLab = lab
            }

            // last one, pin to bottom, this dictates content size height!
            con.append(contentsOf: // *
                NSLayoutConstraint.constraints(withVisualFormat:"V:[lab]-(10)-|",
                                               metrics:nil, views:["lab":previousLab!]))
            NSLayoutConstraint.activate(con)
            
            // autolayout helps us learn the consequences of those constraints
            let minsz = v.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            // set content view frame and content size explicitly
            v.frame = CGRect(0,0,0,minsz.height)
            sv.contentSize = v.frame.size
            
        default: break
        }
        
        delay(2) {
            print(sv.contentSize)
        }
    }

    fileprivate func svByConstraints() {
        let sv = UIScrollView()

        // sv.alwaysBounceHorizontal = true

        /// 示例_ContentInset_A
        do {
            if isE_ContentInset_A {
                sv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
                sv.scrollIndicatorInsets = sv.contentInset
            } else {
                self.sv = sv
            }
        }

        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(sv)
        var con = [NSLayoutConstraint]()
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|[sv]|",
                                           metrics:nil,
                                           views:["sv":sv]))
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|[sv]|",
                                           metrics:nil,
                                           views:["sv":sv]))
        var previousLab : UILabel? = nil
        for i in 0 ..< 30 {
            let lab = UILabel()
            // lab.backgroundColor = .red
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.text = "This is label \(i+1)"
            sv.addSubview(lab)

            con.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat:"H:|-(10)-[lab]",
                                               metrics:nil, views:["lab":lab]))
            if previousLab == nil { // first one, pin to top
                con.append(contentsOf:
                    NSLayoutConstraint.constraints(withVisualFormat:"V:|-(10)-[lab]",
                                                   metrics:nil, views:["lab":lab]))
            } else { // all others, pin to previous
                con.append(contentsOf:
                    NSLayoutConstraint.constraints(withVisualFormat:"V:[prev]-(10)-[lab]",
                                                   metrics:nil, views:["lab":lab, "prev":previousLab!]))
            }
            previousLab = lab
        }

        // last one, pin to bottom, this dictates content size height!
        con.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "V:[lab]-(10)-|",
                                           metrics:nil, views:["lab":previousLab!]))
        NSLayoutConstraint.activate(con)
    }

    fileprivate func svByFrame() {
        let sv = UIScrollView(frame: self.view.bounds)
        sv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(sv)
        sv.backgroundColor = .white
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPoint(10,y)
            sv.addSubview(lab)
            y += lab.bounds.size.height + 10

            // uncomment
            //            lab.frame.size.width = self.view.bounds.width - 20
            //            lab.backgroundColor = .red // make label bounds visible
            //            lab.autoresizingMask = .flexibleWidth

        }
        var sz = sv.bounds.size
        sz.height = y
        sv.contentSize = sz // This is the crucial line

        print(sv.contentSize)

        delay(2) {
            print(sv.contentSize)
        }
    }

}
