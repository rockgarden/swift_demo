

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var sess : AVCaptureSession!
    var snapper : AVCaptureStillImageOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var iv : UIImageView!

    let previewRect = CGRect(x: 10,y: 30,width: 300,height: 300)

    @IBAction func doStart (_ sender:AnyObject!) {
        if self.sess != nil && self.sess.isRunning {
            self.sess.stopRunning()
            self.previewLayer.removeFromSuperlayer()
            self.sess = nil
            return
        }

        self.sess = AVCaptureSession()

        self.sess.sessionPreset = AVCaptureSessionPreset640x480
        self.snapper = AVCaptureStillImageOutput()
        self.snapper.outputSettings = [
            AVVideoCodecKey: AVVideoCodecJPEG,
            AVVideoQualityKey: 0.6
        ]
        self.sess.addOutput(self.snapper)

        let cam = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let input = try? AVCaptureDeviceInput(device:cam) else {return}
        self.sess.addInput(input)

        let lay = AVCaptureVideoPreviewLayer(session:self.sess)
        lay?.frame = self.previewRect
        self.view.layer.addSublayer(lay!)
        self.previewLayer = lay // keep a ref

        self.sess.startRunning()
    }

    @IBAction func doSnap (_ sender:AnyObject!) {
        if self.sess == nil || !self.sess.isRunning {
            return
        }
        let vc = self.snapper.connection(withMediaType: AVMediaTypeVideo)
        self.snapper.captureStillImageAsynchronously(from: vc) {
            (buf, err) in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buf)
            let im = UIImage(data:data!)
            DispatchQueue.main.async {

                self.previewLayer.removeFromSuperlayer()
                self.sess.stopRunning()
                self.sess = nil

                let iv = UIImageView(frame:self.previewLayer.frame)
                iv.contentMode = .scaleAspectFit
                iv.image = im
                self.view.addSubview(iv)
                self.iv?.removeFromSuperview()
                self.iv = iv
            }
        }
    }
}
