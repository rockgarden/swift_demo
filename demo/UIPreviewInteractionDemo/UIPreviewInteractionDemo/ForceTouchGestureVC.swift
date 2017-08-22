
import UIKit


extension Notification.Name {
    static let pop = Notification.Name("pop")
}

class ForceTouchGestureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let circle = CircleView(frame:CGRect(100,100,100,100))
        self.view.addSubview(circle)
        NotificationCenter.default.addObserver(forName: .pop, object: nil, queue: .main) {
            n in
            let minW = 50 as UInt32
            let maxW = 150 as UInt32
            let randW = arc4random_uniform(maxW-minW) + minW
            let minX = 0 as UInt32
            let minY = 20 as UInt32
            let maxX = UInt32(self.view.bounds.width) - randW
            let maxY = UInt32(self.view.bounds.height) - randW
            let randX = arc4random_uniform(maxX-minX) + minX
            let randY = arc4random_uniform(maxY-minY) + minY
            let circle = CircleView(frame:CGRect(CGFloat(randX),CGFloat(randY),CGFloat(randW),CGFloat(randW)))
            self.view.addSubview(circle)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

class CircleView: UIView, UIPreviewInteractionDelegate {
    private var _prev : UIPreviewInteraction!
    private var anim : UIViewPropertyAnimator!
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        p.fill()
    }
    func makeAnimator() {
        self.anim = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in
            self.alpha = 0.3
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    override func didMoveToSuperview() {
        self._prev = UIPreviewInteraction(view: self)
        self._prev.delegate = self
        self.makeAnimator()
    }
    func previewInteractionDidCancel(_ prev: UIPreviewInteraction) {
        self.anim.pauseAnimation()
        self.anim.isReversed = true
        self.anim.addCompletion {_ in self.makeAnimator() }
        self.anim.continueAnimation(withTimingParameters: nil, durationFactor: 0.01)
    }
    func previewInteraction(_ prev: UIPreviewInteraction,
                            didUpdatePreviewTransition prog: CGFloat,
                            ended: Bool) {
        var prog = prog
        if prog < 0.05 {prog = 0.05}
        if prog > 0.95 {prog = 0.95}
        self.anim.fractionComplete = prog
        if ended {
            self.anim.stopAnimation(false)
            self.anim.finishAnimation(at: .end)
            NotificationCenter.default.post(name: .pop, object: nil)
            self.removeFromSuperview()
        }
    }
    deinit {
        print("poof")
    }
}


class CircleView_NoAnim: UIView, UIPreviewInteractionDelegate {
    private var prev : UIPreviewInteraction!
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.isOpaque = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let p = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        p.fill()
    }
    override func didMoveToSuperview() {
        self.prev = UIPreviewInteraction(view: self)
        self.prev.delegate = self
    }
    func previewInteractionDidCancel(_ prev: UIPreviewInteraction) {
        self.transform = .identity
        self.alpha = 1
    }
    func previewInteraction(_ prev: UIPreviewInteraction,
                            didUpdatePreviewTransition prog: CGFloat,
                            ended: Bool) {
        let scale = prog + 1
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        let alph = ((1-prog)*0.6) + 0.3
        // print(alph)
        self.alpha = alph
        if ended {
            NotificationCenter.default.post(name: .pop, object: nil)
            self.removeFromSuperview()
        }
    }
    deinit {
        print("poof")
    }
}

