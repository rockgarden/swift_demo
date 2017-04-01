
import UIKit

let TILESIZE: CGFloat = 256

class ScrollWithTilingVC : UIViewController {
    fileprivate var sv = UIScrollView()
    fileprivate var content : TiledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[sv]|", options: [], metrics: nil, views: ["sv":sv]),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[sv]|", options: [], metrics: nil, views: ["sv":sv]),
            ].joined().map {$0})

        let f = CGRect(0, 0, 2*TILESIZE, 2*TILESIZE)
        let content = TiledView(frame:f)
        let tsz = TILESIZE * content.layer.contentsScale
        (content.layer as! CATiledLayer).tileSize = CGSize(tsz, tsz)
        sv.addSubview(content)
        sv.contentSize = f.size
        self.content = content
    }
}


/// there were low-memory problems with CATiledLayer in early versions of iOS 7.
class TiledView : UIView {
    
    let drawQueue = DispatchQueue(label: "drawQueue")
    
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }

    func setContentScaleFactor(contentScaleFactor: CGFloat) {
        super.contentScaleFactor = 2.0
    }
    
    override func draw(_ r: CGRect) {
        drawQueue.sync { // work around nasty thread issue...
            // we are called twice simultaneously on two different background threads!
            // logging to prove we have in fact worked around it
            NSLog("%@", "starting drawRect: \(r)")
            
            let tile = r
            let x = Int(tile.origin.x/TILESIZE)
            let y = Int(tile.origin.y/TILESIZE)
            let tileName = String(format:"CuriousFrog_500_\(x+3)_\(y)")
            let path = Bundle.main.path(forResource: tileName, ofType:"png")!
            let image = UIImage(contentsOfFile:path)!
            
            image.draw(at:CGPoint(CGFloat(x)*TILESIZE, CGFloat(y)*TILESIZE))
            
            /// in real life, comment out the following! it's here just so we can see the tile boundaries
            
            let bp = UIBezierPath(rect: r)
            UIColor.white.setStroke()
            bp.stroke()
            
            NSLog("%@", "finished drawRect: \(r)")
        }
    }
}

