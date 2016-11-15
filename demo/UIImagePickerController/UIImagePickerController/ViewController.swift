
import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos

func imageOfSize(_ size:CGSize, closure:() -> ()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    closure()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result!
}

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var redView: UIView!
    weak var picker : UIImagePickerController?

    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .default, handler: {
                    _ in
                    let url = URL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared.openURL(url)
            }))
            self.present(alert, animated:true, completion:nil)
            return false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(determineStatus),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }


    @IBAction func doTake (_ sender:AnyObject!) {
        let cam = UIImagePickerControllerSourceType.camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeImage as NSString as String
        // let desiredType = kUTTypeMovie as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for: cam)
        print(arr!)
        if arr?.index(of: desiredType) == nil {
            print("no capture")
            return
        }
        let picker = MyImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        picker.allowsEditing = true
        picker.delegate = self

        //FIXME: cameraOverlayView addGestureRecognizer 无效
//        picker.showsCameraControls = false
//        let f = self.view.window!.bounds
//        let v = UIView(frame:f)
//        debugPrint(v)
//        let t = UITapGestureRecognizer(target:self, action:#selector(tap))
//        t.numberOfTapsRequired = 2
//        v.addGestureRecognizer(t)
//        picker.cameraOverlayView = v

        self.picker = picker

        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        // better to get authorization beforehand
        self.present(picker, animated: true, completion: nil)
    }

    func clearAll() {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as! AVPlayerViewController
            av.willMove(toParentViewController: nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.redView.subviews.forEach { $0.removeFromSuperview() }
    }

    func showImage(_ im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }

    func showMovie(_ url:URL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVPlayer(url:url)
        av.player = player
        self.addChildViewController(av)
        av.view.frame = self.redView.bounds
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParentViewController: self)
    }

    func tap (_ g: UIGestureRecognizer) {
        self.picker?.takePicture()
    }

    //MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        let url = info[UIImagePickerControllerMediaURL] as? URL //iOS 10 url = nil
        var im = info[UIImagePickerControllerOriginalImage] as? UIImage
        let edim = info[UIImagePickerControllerEditedImage] as? UIImage
        if edim != nil {
            im = edim
        }

        // push photo view
        let svc = SecondViewController(image:im)
        picker.pushViewController(svc, animated: true)

        // back to ViewController
        /*
        self.dismiss(animated: true) {
            let type = info[UIImagePickerControllerMediaType] as? String
            if type != nil {
                switch type! {
                case kUTTypeImage as NSString as String:
                    if im != nil {
                        self.showImage(im!)
                        // showing how simple it is to save into the Camera Roll
                        let lib = PHPhotoLibrary.shared()
                        lib.performChanges({
                            PHAssetChangeRequest.creationRequestForAsset(from: im!)
                        }, completionHandler: nil)
                    }
                case kUTTypeMovie as NSString as String:
                    if url != nil {
                        self.showMovie(url!)
                    }
                default:break
                }
            }
        }*/
    }

    //MARK: - UINavigationControllerDelegate
    /*
    func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        if vc is SecondViewController {
            nc.isToolbarHidden = true
            return
        }
        nc.isToolbarHidden = false

        let sz = CGSize(width: 10,height: 10)
        let im = imageOfSize(sz) {
            UIColor.black.withAlphaComponent(0.1).setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz))
        }
        nc.toolbar.setBackgroundImage(im, forToolbarPosition: .any, barMetrics: .default)
        nc.toolbar.isTranslucent = true
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doCancel))
        let lab = UILabel()
        lab.text = "Double tap to take a picture"
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.sizeToFit()
        let b2 = UIBarButtonItem(customView: lab)
        nc.topViewController!.toolbarItems = [b,b2]
        nc.topViewController!.title = "Retake"
    }*/

    func doCancel(_ sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func doUse(_ im:UIImage?) {
        if im != nil {
            showImage(im!)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
