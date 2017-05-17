//
//  ZoomCenteredVC.swift
//  UIScrollView
//
//  Created by wangkan on 2017/5/17.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class ZoomCenteredVC: UIViewController, UIScrollViewDelegate {

    var oldBounces = false
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var v: UIView!
    var didSetup = false

    override func viewDidLayoutSubviews() {
        if !self.didSetup {
            self.didSetup = true
            // turn off auto layout and assign content size manually
            sv.contentSize = CGSize(208,238)
        }
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        oldBounces = scrollView.bounces
        scrollView.bounces = false
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if let view = view {
            scrollView.bounces = oldBounces
            view.contentScaleFactor = scale * UIScreen.main.scale // *
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(999)
    }

    // same annoying "jump" bug in iOS 8
    // there is also a slight "jump" as we zoom

    @IBAction func tapped(_ tap : UIGestureRecognizer) {
        let v = tap.view!
        let sv = v.superview as! UIScrollView
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
}


class MyScrollView: UIScrollView {

    override func layoutSubviews() {
        var which : Int {return 1}
        switch which {
        case 1:
            super.layoutSubviews()
            if let v = self.delegate?.viewForZooming?(in:self) {
                let svw = self.bounds.width
                let svh = self.bounds.height
                let vw = v.frame.width
                let vh = v.frame.height
                var f = v.frame
                if vw < svw {
                    f.origin.x = (svw - vw) / 2.0
                } else {
                    f.origin.x = 0
                }
                if vh < svh {
                    f.origin.y = (svh - vh) / 2.0
                } else {
                    f.origin.y = 0
                }
                v.frame = f
            }
        default:break
        }
    }
}


class TiledStrokeView : UIView {

    var currentImage : UIImage!
    var currentSize : CGSize = .zero

    let drawQueue = DispatchQueue(label: "drawQueue")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let lay = self.layer as! CATiledLayer
        let scale = lay.contentsScale
        lay.tileSize = CGSize(208*scale,238*scale)
        lay.levelsOfDetail = 3
        lay.levelsOfDetailBias = 2
    }

    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }

    override func draw(_ rect: CGRect) {
        drawQueue.sync { // work around nasty thread issue...
            // we are called twice simultaneously on two different background threads!
            let oldSize = currentSize
            if !oldSize.equalTo(rect.size) {
                // make a new size
                currentSize = rect.size
                // make a new image
                let lay = self.layer as! CATiledLayer

                let tr = UIGraphicsGetCurrentContext()!.ctm
                let sc = tr.a/lay.contentsScale
                let scale = sc/4.0

                let path = Bundle.main.path(forResource: "CuriousFrog_500_3_1", ofType:"png")!
                let im = UIImage(contentsOfFile:path)!
                let sz = CGSize(im.size.width * scale, im.size.height * scale)

                if #available(iOS 10.0, *) {
                    let f = UIGraphicsImageRendererFormat.default()
                    f.opaque = true
                    f.scale = 1 // *
                    let r = UIGraphicsImageRenderer(size: sz, format: f)
                    currentImage = r.image { _ in
                        im.draw(in:CGRect(origin:.zero, size:sz))
                    }
                } else {
                    // Fallback on earlier versions
                    UIGraphicsBeginImageContextWithOptions(sz, true, 1)
                    im.draw(in:CGRect(0,0,sz.width,sz.height))
                    currentImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                }
            }
            currentImage?.draw(in:self.bounds)

            // comment out the following! it's here just so we can see the tile boundaries
            let bp = UIBezierPath(rect: rect)
            UIColor.white.setStroke()
            bp.stroke()
        }
    }
}


// TODO: 用 ScalableView 动态替换 TiledStrokeView
class ScalableView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .black
    }

    override func draw(_ rect: CGRect) {
        print("rect: \(rect); bounds: \(self.bounds); scale: \(self.layer.contentsScale)")
        let path = Bundle.main.path(forResource: "CuriousFrog_500_3_1", ofType:"png")!
        let im = UIImage(contentsOfFile:path)!
        im.draw(in:rect)
    }
    
}
