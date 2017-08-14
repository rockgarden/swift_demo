
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
        let content = TiledView(frame: f)
        let tsz = TILESIZE * content.layer.contentsScale
        (content.layer as! CATiledLayer).tileSize = CGSize(tsz, tsz)
        sv.addSubview(content)
        sv.contentSize = f.size
        self.content = content
    }
}


class TiledView : UIView {
    
    let drawQueue = DispatchQueue(label: "drawQueue")
    
    override class var layerClass : AnyClass {
        return CATiledLayer.self
    }

    func setContentScaleFactor(contentScaleFactor: CGFloat) {
        super.contentScaleFactor = 2.0
    }
    
    override func draw(_ r: CGRect) {
        /// sync: 提交块对象以便在调度队列上执行，并等待该块完成。将一个块提交到调度队列以进行同步执行。与dispatch_async（_：_ :)不同，该函数在块完成之前不会返回。调用此功能并定位当前队列会导致死锁。与dispatch_async（_：_ :)不同，在目标队列上不执行保留。 因为这个函数的调用是同步的，所以它“借用”了调用者的引用。此外，在块上不执行Block_copy。作为优化，此函数可能会调用当前线程上的块。
        drawQueue.sync {
            /// 在两个不同的后台线程上"同时"(实际上不是并发)调用两次, called twice simultaneously on two different background threads! See logging "%@",
            NSLog("threads %@", "starting drawRect: \(r)")
            
            let tile = r
            let x = Int(tile.origin.x/TILESIZE)
            let y = Int(tile.origin.y/TILESIZE)
            let tileName = String(format:"CuriousFrog_500_\(x+3)_\(y)")
            let path = Bundle.main.path(forResource: tileName, ofType: "png")!
            let image = UIImage(contentsOfFile: path)!
            
            image.draw(at:CGPoint(CGFloat(x)*TILESIZE, CGFloat(y)*TILESIZE))
            
            /// see the tile boundaries
            let bp = UIBezierPath(rect: r)
            UIColor.white.setStroke()
            bp.stroke()
            
            NSLog("%@", "finished drawRect: \(r)")
        }
    }
}

