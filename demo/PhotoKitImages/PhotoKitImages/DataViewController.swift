

import UIKit
import Photos
import ImageIO
import MobileCoreServices
import VignetteFilter

class DataViewController: UIViewController, EditingViewControllerDelegate {
                            
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var frameview : UIView!
    @IBOutlet var iv : UIImageView!
    var asset: PHAsset!
    // var index : Int = -1
    var input : PHContentEditingInput!
    let myidentifier = "com.rockgarden.PhotoKitImages.vignette"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInterface()
    }
    
    func setUpInterface() {
        guard let asset = self.asset else {
            self.dataLabel.text = ""
            self.iv.image = nil
            return
        }
        self.dataLabel.text = asset.description
        // okay, this is why we are here! fetch the image data!!!!!
        // we have to say quite specifically what "view" of image we want
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300,height: 300), contentMode: .aspectFit, options: nil) {
            //(im:UIImage?, info:[AnyHashable: Any]?) in
            im, info in
            // this block can be called multiple times
            // and you can see why: initially we might get a degraded version of the image
            // and in fact we do, as I show with logging
            if let im = im {
                print("set up interface: \(im.size)")
                self.iv.image = im
            }
        }
    }
    
    // simple editing example
    // everything depends upon PHContentEditingInput and PHContentEditingOutput classes
    
    func doVignette() {
        // part one: standard dance to obtain PHContentEditingInput; hang on to it for later
        let options = PHContentEditingInputRequestOptions()
        // note that if we reply true to canHandle..., then we will be handed the *original* photo + data
        // thus we can continue our edit where we left off, or remove it (and I illustrate both here)
        options.canHandleAdjustmentData = {
            //(adjustmentData : PHAdjustmentData!) in
            adjustmentData in
            // print("here")
            // return false // just testing
            return adjustmentData.formatIdentifier == self.myidentifier
        }
        var id : PHContentEditingInputRequestID = 0
        /// 内联的写法
        //id = (self.asset?.requestContentEditingInput(with: options, completionHandler: { (input:PHContentEditingInput?, info:[AnyHashable: Any]) in }))!
        /// 尾随闭包的写法
        id = self.asset.requestContentEditingInput(with: options) {
            input, info in
            guard let input = input else {
                self.asset?.cancelContentEditingInputRequest(id)
                return
            }
            self.input = input
            
            // now we give the user an editing interface...
            // ...using the input's displaySizeImage and adjustmentData
            
            let im = input.displaySizeImage!
            let sz = CGSize(width: im.size.width/4.0, height: im.size.height/4.0)
            var im2 = UIImage()
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:sz)
                im2 = r.image { _ in
                    // perhaps no need for this, but the image they give us is much larger than we need
                    im.draw(in:CGRect(origin: .zero, size: sz))
                }
            } else {
                im2 = imageOfSize(sz) {
                    // perhaps no need for this, but the image they give us is much larger than we need
                    im.draw(in: CGRect(origin: CGPoint(), size: sz))
                }
            }
            
            let evc = EditingViewController(displayImage:CIImage(image:im2)!)
            
            evc.delegate = self
            let adj : PHAdjustmentData? = input.adjustmentData
            print(adj ?? "no data")
//            do {
//                asset.cancelContentEditingInputRequest(id)
//                return
//            }
            if let adj = input.adjustmentData, adj.formatIdentifier == self.myidentifier {
                if let vigAmount = NSKeyedUnarchiver.unarchiveObject(with: adj.data) as? Double {
                    if vigAmount >= 0.0 {
                        evc.initialVignette = vigAmount
                        evc.canUndo = true
                    }
                }
            }
            let nav = UINavigationController(rootViewController: evc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func finishEditingWithVignette(_ vignette:Double) {
        // part two: obtain PHContentEditingOutput...
        // and apply editing to actual full size image
//        let input = self.input
//        let inurl = input?.fullSizeImageURL!
//        let inorient = input?.fullSizeImageOrientation
//        let output = PHContentEditingOutput(contentEditingInput: input!)
//        let outurl = output.renderedContentURL
//        
//        let outcgimage = {
//            () -> CGImage in
//            var ci = CIImage(contentsOf: inurl!)!.applyingOrientation(inorient!)
//            if vignette >= 0.0 {
//                let vig = VignetteFilter()
//                vig.setValue(ci, forKey: "inputImage")
//                vig.setValue(vignette, forKey: "inputPercentage")
//                ci = vig.outputImage!
//            }
//            return CIContext(options: nil).createCGImage(ci, from: ci.extent)!
//        }()
//        
//        let dest = CGImageDestinationCreateWithURL(outurl as CFURL, kUTTypeJPEG, 1, nil)!
//        CGImageDestinationAddImage(dest, outcgimage, [
//            kCGImageDestinationLossyCompressionQuality as String:1
//            ] as CFDictionary) //For Swift 3 you need extra casting to CFDictionary. Otherwise Contextual type 'CFDictionary' cannot be used with dictionary literal is thrown.
//        CGImageDestinationFinalize(dest)

//        let data = NSKeyedArchiver.archivedData(withRootObject: vignette)
//        output.adjustmentData = PHAdjustmentData(
//            formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)

        // now we must tell the photo library to pick up the edited image
//        PHPhotoLibrary.shared().performChanges({
//            print("finishing")
//            let asset = self.asset
//            let req = PHAssetChangeRequest(for: asset!)
//            req.contentEditingOutput = output
//            }, completionHandler: {
//                (ok, err) in
//                print("in completion handler")
//                // at the last minute, the user will get a special "modify?" dialog
//                // if the user refuses, we will receive "false"
//                if ok {
//                    // in our case, since are already displaying this photo...
//                    // ...we should now reload it
//                    self.setUpInterface()
//                } else {
//                    print("phasset change request error: \(err)")
//                }
//        })

        let act = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        act.backgroundColor = .darkGray
        act.layer.cornerRadius = 3
        act.center = self.view.center
        self.view.addSubview(act)
        act.startAnimating()

        DispatchQueue.global(qos: .userInitiated).async {
            let inurl = self.input.fullSizeImageURL!
            let inorient = self.input.fullSizeImageOrientation
            let output = PHContentEditingOutput(contentEditingInput:self.input)
            let outurl = output.renderedContentURL
            var ci = CIImage(contentsOf: inurl)!.applyingOrientation(inorient)
            let space = ci.colorSpace!
            if vignette >= 0.0 {
                let vig = VignetteFilter()
                vig.setValue(ci, forKey: "inputImage")
                vig.setValue(vignette, forKey: "inputPercentage")
                ci = vig.outputImage!
            }
            // new in iOS 10
            // warning: this is time-consuming! (even more than how I was doing it before)
            if #available(iOS 10.0, *) {
                try! CIContext().writeJPEGRepresentation(of: ci, to: outurl, colorSpace: space)
            } else {
                let outcgimage = {
                    () -> CGImage in
                    var ci = CIImage(contentsOf: inurl)!.applyingOrientation(inorient)
                    if vignette >= 0.0 {
                        let vig = VignetteFilter()
                        vig.setValue(ci, forKey: "inputImage")
                        vig.setValue(vignette, forKey: "inputPercentage")
                        ci = vig.outputImage!
                    }
                    return CIContext(options: nil).createCGImage(ci, from: ci.extent)!
                }()

                let dest = CGImageDestinationCreateWithURL(outurl as CFURL, kUTTypeJPEG, 1, nil)!
                CGImageDestinationAddImage(dest, outcgimage, [
                    kCGImageDestinationLossyCompressionQuality as String:1
                    ] as CFDictionary) //For Swift 3 you need extra casting to CFDictionary. Otherwise Contextual type 'CFDictionary' cannot be used with dictionary literal is thrown.
                CGImageDestinationFinalize(dest)
            }

            let data = NSKeyedArchiver.archivedData(withRootObject: vignette)
            output.adjustmentData = PHAdjustmentData(
                formatIdentifier: self.myidentifier, formatVersion: "1.0", data: data)

            // now we must tell the photo library to pick up the edited image
            PHPhotoLibrary.shared().performChanges({
                print("finishing")
                let req = PHAssetChangeRequest(for: self.asset)
                req.contentEditingOutput = output
            }) { ok, err in
                DispatchQueue.main.async {
                    act.removeFromSuperview()
                    print("in completion handler")
                    // at the last minute, the user will get a special "modify?" dialog
                    // if the user refuses, we will receive "false"
                    if ok {
                        // in our case, since are already displaying this photo...
                        // ...we should now reload it
                        self.setUpInterface()
                    } else {
                        print("phasset change request error: \(err)")
                    }
                }
            }
        }
    }
    
}

