//
//  ProgressVC.swift
//  UIViewDemo
//

import UIKit

class ProgressingOperation {
    let progress : Progress
    init(units:Int) {
        self.progress = Progress(totalUnitCount: Int64(units))
    }
    func start() {
        Timer.scheduledTimer(timeInterval:0.4, target: self, selector: #selector(inc), userInfo: nil, repeats: true)
    }
    @objc func inc(_ t:Timer) {
        self.progress.completedUnitCount += 1
        if self.progress.fractionCompleted >= 1.0 {
            t.invalidate()
            print("done")
        }
    }
}


class ProgressVC: UIViewController {
    
    @IBOutlet var prog1 : UIProgressView!
    @IBOutlet var prog2 : UIProgressView!
    @IBOutlet var prog3 : MyProgressView!
    @IBOutlet var prog4 : MyCircularProgressButton!
    
    var op1 : ProgressingOperation?
    var op2 : ProgressingOperation?
    var op3 : ProgressingOperation?
    
    @IBAction func doButton (_ sender: Any) {
        self.prog1.progress = 0
        self.prog2.progress = 0
        self.prog3.value = 0
        self.prog3.setNeedsDisplay()
        self.prog4.progress = 0
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(inc), userInfo: nil, repeats: true)

        /// architecture 1: progress view's observedProgress is a second pointer to a vended NSProgress
        self.op1 = ProgressingOperation(units:10)
        self.prog1.observedProgress = self.op1!.progress
        self.op1!.start()
        
        /// architecture 2: progress view's observedProgress is parent of distant NSProgress
        /*
         创建并返回具有指定的totalUnitCount的NSProgress实例，该实例不是任何现有进度树的一部分。该实例使用init（parent：userInfo :)进行初始化，父级设置为nil。
         使用此方法创建您自己的自定义类返回的顶级进度对象。 返回的进度对象的用户可以使用addChild（_：withPendingUnitCount :)将其添加到进度树中。
         您负责更新创建的进度对象的进度计数。 您可以在一个线程上调用此方法，然后在另一个线程上消息返回的NSProgress。
         */
        self.prog2.observedProgress = Progress.discreteProgress(totalUnitCount: 10)
        /*
         将接收器设置为当前线程的当前进度对象，并指定由接收器的下一个子进程对象执行的部分工作。
         使用此方法构建一个进度对象树，如创建进度对象树中所述。
         */
        self.prog2.observedProgress?.becomeCurrent(withPendingUnitCount: 10)
        self.op2 = ProgressingOperation(units:10) //automatically becomes child!
        /*
         /通过将当前进度对象还原到已调用getsCurrent（withPendingUnitCount :)之前的最前一次调用getsCurrent（withPendingUnitCount :)在同一个线程上.
         */
        self.prog2.observedProgress?.resignCurrent()
        self.op2!.start()
        
        /// architecture 3: explicit KVO on an NSProgress, update progress view manually
        self.op3 = ProgressingOperation(units:10)
        self.op3!.progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [.new], context: nil)
        self.op3!.start()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = object as? Progress {
            if let frac = change?[.newKey] as? CGFloat {
                self.prog3.value = frac
                self.prog3.setNeedsDisplay()
            }
        }
    }
    
    var didSetUp = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.didSetUp { return }
        self.didSetUp = true
        
        self.prog2.backgroundColor = .black
        self.prog2.trackTintColor = .black
        
        let im = imageOfSize(CGSize(10,10)) {
            let con = UIGraphicsGetCurrentContext()!
            con.setFillColor(UIColor.yellow.cgColor)
            con.fill(CGRect(0, 0, 10, 10))
            let r = con.boundingBoxOfClipPath.insetBy(dx: 1,dy: 1)
            con.setLineWidth(2)
            con.setStrokeColor(UIColor.black.cgColor)
            con.stroke(r)
            con.strokeEllipse(in: r)
            }.resizableImage(withCapInsets:UIEdgeInsetsMake(4, 4, 4, 4), resizingMode:.stretch)
        
        self.prog2.progressImage = im

        // 不良的方式 hacky workaround, can't recommend really
        //let ims = self.prog2.subviews.filter {$0 is UIImageView} as! [UIImageView]
        //ims[1].image = im
    }

    @objc func inc(_ t:Timer) {
        var val = Float(self.prog3.value)
        val += 0.1

        /// prog1\2\3 采用 ProgressingOperation 驱动
        //self.prog1.setProgress(val, animated:true)
        //self.prog2.setProgress(val, animated:true)
        //self.prog3.value = CGFloat(val)
        //self.prog3.setNeedsDisplay()

        self.prog4.progress = val

        if val >= 1.0 {
            t.invalidate()
        }
    }

}


class MyProgressView: UIView {
    
    var value : CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        UIColor.white.set()
        let ins : CGFloat = 2.0
        let r = self.bounds.insetBy(dx: ins, dy: ins)
        let radius : CGFloat = r.size.height / 2.0
        let mpi = CGFloat.pi
        let path = CGMutablePath()
        path.move(to:CGPoint(r.maxX - radius, ins))
        path.addArc(center:CGPoint(radius+ins, radius+ins), radius: radius, startAngle: -mpi/2.0, endAngle: mpi/2.0, clockwise: true)
        path.addArc(center:CGPoint(r.maxX - radius, radius+ins), radius: radius, startAngle: mpi/2.0, endAngle: -mpi/2.0, clockwise: true)
        path.closeSubpath()
        c.addPath(path)
        c.setLineWidth(2)
        c.strokePath()
        c.addPath(path)
        c.clip()
        c.fill(CGRect(
            r.origin.x, r.origin.y, r.size.width * self.value, r.size.height))
    }
    
}


class MyCircularProgressButton : UIButton {

    var progress : Float = 0 {
        didSet {
            if let layer = self.shapelayer {
                layer.strokeEnd = CGFloat(self.progress)
            }
        }
    }
    private var shapelayer : CAShapeLayer!
    private var didLayout = false

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !self.didLayout else {return}
        self.didLayout = true
        print(self.bounds)
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.lineWidth = 2
        layer.fillColor = nil
        layer.strokeColor = UIColor.red.cgColor
        let b = UIBezierPath(ovalIn: self.bounds.insetBy(dx: 3, dy: 3))
        layer.path = b.cgPath
        self.layer.addSublayer(layer)
        layer.zPosition = -1
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2.0))
        self.shapelayer = layer
    }

}

