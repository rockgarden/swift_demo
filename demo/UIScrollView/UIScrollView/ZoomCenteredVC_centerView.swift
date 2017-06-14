
import UIKit


class ZoomCenteredVC_centerView : UIViewController, UIScrollViewDelegate {
    @IBOutlet var sv : UIScrollView!
    @IBOutlet var iv : UIImageView!
    @IBOutlet var cB : UIBarButtonItem!
    var didSetup = false
    var oldBounces = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cB.title = APP.run ? "viewDidLayoutSubviews" : "viewDidAppear"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard APP.run else {return}
        if !self.didSetup {
            self.didSetup = true
            // 优于在ViewDidLayoutSubviews中执行
            self.centerView() //可避免view Jump
        }
    }

    override func viewDidLayoutSubviews() {
        guard !APP.run else {return}
        if !self.didSetup {
            self.didSetup = true
            let v = self.viewForZooming(in:self.sv)!
            self.sv.contentSize = v.bounds.size
            self.sv.contentOffset = CGPoint(40,0)
            self.centerView()
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.oldBounces = scrollView.bounces
        scrollView.bounces = false
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.bounces = self.oldBounces
    }
    
    func centerView() {
        let sv = self.sv!
        let v = self.viewForZooming(in:sv)!
        // normal result is that iv.center should be center of v
        var c = CGPoint(v.bounds.midX, v.bounds.midY)
        // but if dimension is smaller, we will move to center of scroll view
        let csv = CGPoint(sv.bounds.midX, sv.bounds.midY)
        // for x, center in s.v. only if width is smaller
        if sv.contentSize.width < sv.bounds.width {
            let c2 = v.convert(csv, from: sv)
            c.x = c2.x
        } else {
            // offset content to be horizontally centered itself
            sv.contentOffset.x = (sv.contentSize.width - sv.bounds.width) / 2.0
        }
        // for y, always keep centered
        let c2 = v.convert(csv, from: sv)
        c.y = c2.y
        // and set image view's center
        iv.center = c
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerView()
    }
    
    // image view is zoomable
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }
    
    // image view is also zoomable by double-tapping
    @IBAction func tapped(_ tap : UIGestureRecognizer) {
        let sv = self.sv!
        if sv.zoomScale < 1 {
            sv.setZoomScale(1, animated:true)
        }
        else if sv.zoomScale < sv.maximumZoomScale {
            sv.setZoomScale(sv.maximumZoomScale, animated:true)
        }
        else {
            sv.setZoomScale(sv.minimumZoomScale, animated:true)
        }
    }

    @IBAction func change(_ sender: Any) {
        APP.run = !APP.run
        cB.title = APP.run ? "viewDidLayoutSubviews" : "viewDidAppear"
    }

}

class MyTappableView : UIView {
    /*
     返回包含指定点的视图层次结构（包括自身）中的接收者的最远后代。
     该方法遍历视图层次结构，调用每个子视图的point（inside :) with :)方法来确定哪个子视图应该接收触摸事件。如果point（with :)返回true，则子视图的层次结构也会相似地遍历，直到找到包含指定点的最前面的视图。如果视图不包含该点，则其视图层次结构的分支将被忽略。您很少需要自己调用此方法，但您可以覆盖它以从子视图中隐藏触摸事件。
     此方法将忽略隐藏的视图对象，该对象已禁用用户交互，或者具有小于0.01的Alpha级别。当确定命中时，此方法不会考虑视图的内容。因此，即使指定的点在该视图的内容的透明部分中，仍然可以返回视图。
     位于接收者边界之外的点不会被报告为命中，即使它们实际上位于接收者的子视图之一内。如果当前视图的clipToBounds属性设置为false并且受影响的子视图超出视图的边界，则可能会发生这种情况。
     */
    override func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if let result = super.hitTest(point, with:event) {
            return result
        }
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with:event) {
                return result
            }
        }
        return nil
    }
}
