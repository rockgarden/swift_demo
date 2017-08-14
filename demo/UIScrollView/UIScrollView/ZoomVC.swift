

import UIKit


class ZoomVC : UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sv)

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
        NSLayoutConstraint.activate(con)

        var w : CGFloat = 0
        var y : CGFloat = 10
        for i in 0 ..< 30 {
            let lab = UILabel()
            lab.text = "This is label \(i+1)"
            lab.sizeToFit()
            lab.frame.origin = CGPoint(10,y)
            v.addSubview(lab)
            y += lab.bounds.size.height + 10
            
            if lab.bounds.width > w { // *
                w = lab.bounds.width
            }
        }
        
        // set content view frame and content size explicitly
        v.frame = CGRect(0,0,w+20,y)
        sv.contentSize = v.frame.size

        v.tag = 999 // *
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 2.0
        sv.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var which : Int {return 0} // 1 to add some interesting logging :)
        switch which {
        case 1:
            print(scrollView.bounds.size) // this is constant
            print(scrollView.contentSize) // this is changing
            let v = self.viewForZooming(in:scrollView)!
            print(v.bounds.size) // this is constant
            print(v.frame.size) // this is changing (and here it matches the content size)
            print()
        default : break
        }
    }

}
