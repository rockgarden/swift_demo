
import UIKit


class CIFilterVC : UIViewController {

    @IBOutlet var iv : UIImageView!
    @IBOutlet var v : UIView!

    var tran : CIFilter!
    var moiextent : CGRect!
    var frame : Double!
    var timestamp : CFTimeInterval!
    lazy var context = CIContext()
    let SCALE = 0.5 /// 越小Animation越慢 0.2 for slow motion, looks a bit better in simulator

    let image = CIImage(image: UIImage(named:"Swift_Logo")!)!

    override func viewDidLoad() {
        super.viewDidLoad()
        setFilter()
    }

    func setFilter() {
        var which : Int { return 2 }

        let vf = VignetteCIFilter()

        vf.setValuesForKeys([
            "inputImage":image,
            "inputPercentage":0.7
            ])
        let outim = vf.outputImage!

        //        let outim = image.applyingFilter(
        //            "CIBlendWithMask", withInputParameters: [
        //                "inputMaskImage":outim
        //            ])

        switch which {
        case 1:
            let im = self.context.createCGImage(outim, from: outim.extent)!
            self.iv.image = UIImage(cgImage: im)
        case 2:
            self.iv.image = imageOfSize(outim.extent.size) {
                _ in
                UIImage(ciImage: outim).draw(in: outim.extent)
            }
        case 3:
            self.iv.image = UIImage(ciImage: outim, scale: 1, orientation: .up) // nope
            delay(0.1) {
                self.iv.setNeedsDisplay() // nope
                self.iv.layer.displayIfNeeded() // nope
            }
        default: break
        }
    }
}


// MARK: - Animation
extension CIFilterVC {

    @IBAction func doButton (_ sender: Any) {

        self.moiextent = image.extent

        let col = CIFilter(name:"CIConstantColorGenerator")!
        let cicol = CIColor(color:.red)
        col.setValue(cicol, forKey:"inputColor")
        let colorimage = col.value(forKey:"outputImage") as! CIImage

        let tran = CIFilter(name:"CIFlashTransition")!
        tran.setValue(colorimage, forKey:"inputImage")
        tran.setValue(image, forKey:"inputTargetImage")
        let center = CIVector(x:self.moiextent.width/2.0, y:self.moiextent.height/2.0)
        tran.setValue(center, forKey:"inputCenter")

        self.tran = tran
        self.timestamp = 0.0 // signal that we are starting
        //self.context = CIContext()

        DispatchQueue.main.async {
            let link = CADisplayLink(target:self, selector:#selector(self.nextFrame))
            link.add(to:.main, forMode:.defaultRunLoopMode)
        }

    }

    func nextFrame(_ sender:CADisplayLink) {
        if self.timestamp < 0.01 { // pick up and store first timestamp
            self.timestamp = sender.timestamp
            self.frame = 0.0
        } else { // calculate frame
            self.frame = (sender.timestamp - self.timestamp) * SCALE
        }
        sender.isPaused = true // defend against frame loss

        self.tran.setValue(self.frame, forKey:"inputTime")
        let moi = self.context.createCGImage(tran.outputImage!, from:self.moiextent)
        CATransaction.setDisableActions(true)
        self.v.layer.contents = moi

        if self.frame > 1.0 {
            print("invalidate")
            sender.invalidate()
        }
        sender.isPaused = false

        print("here \(self.frame)") // useful for seeing dropped frame rate
    }
    
}
